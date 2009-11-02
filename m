From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Nov 2009 14:49:50 +0000
Subject: Re: [PATCH] sctp: Fix mis-ordering of user space data when multihoming
Message-Id: <4AEEF18E.7050802@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091030141056.GA5181@hmsreliant.think-freely.org>
In-Reply-To: <20091030141056.GA5181@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Neil

Neil Horman wrote:
> Fix use of sctp_packet_transmit so as to prevent packet re-ordering
> 
> Recently had a bug reported to me, in which the user was sending packets with a
> payload containing a sequence number.  The packets were getting delivered in
> order according the chunk TSN values, but the sequence values in the payload
> were arriving out of order.  At first I thought it must be an application error,
> but we eventually found it to be a problem on the transmit side in the sctp
> stack.
> 
> The conditions for the error are that multihoming must be in use, and it helps
> if each transport has a different pmtu.  The problem occurs in sctp_outq_flush.
> Basically we dequeue packets from the data queue, and attempt to append them to
> the orrered packet for a given transport.  After we append a data chunk we add
> the trasport to the end of a list of transports to have their packets sent at
> the end of sctp_outq_flush.  The problem occurs when a data chunks fills up a
> offered packet on a transport.  The function that does the appending
> (sctp_packet_transmit_chunk), will try to call sctp_packet_transmit on the full
> packet, and then append the chunk to a new packet.  This call to
> sctp_packet_transmit, sends that packet ahead of the others that may be queued
> in the transport_list in sctp_outq_flush.  The result is that frames that were
> sent in one order from the user space sending application get re-ordered prior
> to tsn assignment in sctp_packet_transmit, resulting in mis-sequencing of data
> payloads, even though tsn ordering is correct.
> 
> The fix is to add a parameter to sctp_packet_transmit_chunk, to inform that
> function if it should send the packet immediately or not.  It makes sense to do
> so for control chunks, which are handled prior to data chunks, but for data
> chunks we want to do what sctp_outq_flush already does, which is to replace the
> overflowing data chunk on the outq, and then flush all the queued transports.
> 

Wouldn't that mean that if we fill a path mtu, we will only generate a single
DATA packet?

The code seems to confirm that.  If we get a return of SCTP_XMIT_PMTU_FULL,
we stop walking the queue jump to 'sctp_flush_out'.  If we are here in response
to a SACK and congestion window is open, we'll never end up filling it.

Is there something special that the application is doing to trigger this?

In any case, I think a better solution would be to change where TSN happens.
Right now, we assign TSNs in sctp_packet_transmit.  Thus it's theoretically
possible, with the current code, to re-order the data.
If we assign TSNs at the time the DATA is assigned to a packet, then the order
problem would be solved.

-vlad

> This patch has been tested by myself and the reporter, and found to solve the
> reported problem
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: William Reich <reich@ulticom.com>
> 
> 
>  include/net/sctp/structs.h |    2 +-
>  net/sctp/output.c          |    4 ++--
>  net/sctp/outqueue.c        |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 9661d7b..766564c 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -829,7 +829,7 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *,
>  				     __u16 sport, __u16 dport);
>  struct sctp_packet *sctp_packet_config(struct sctp_packet *, __u32 vtag, int);
>  sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *,
> -                                       struct sctp_chunk *, int);
> +                                       struct sctp_chunk *, int, int);
>  sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *,
>                                       struct sctp_chunk *);
>  int sctp_packet_transmit(struct sctp_packet *);
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 7363935..1d66ae4 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -159,7 +159,7 @@ void sctp_packet_free(struct sctp_packet *packet)
>   */
>  sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
>  				       struct sctp_chunk *chunk,
> -				       int one_packet)
> +				       int one_packet, int force_tx)
>  {
>  	sctp_xmit_t retval;
>  	int error = 0;
> @@ -169,7 +169,7 @@ sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
>  
>  	switch ((retval = (sctp_packet_append_chunk(packet, chunk)))) {
>  	case SCTP_XMIT_PMTU_FULL:
> -		if (!packet->has_cookie_echo) {
> +		if ((!packet->has_cookie_echo) && force_tx) {
>  			error = sctp_packet_transmit(packet);
>  			if (error < 0)
>  				chunk->skb->sk->sk_err = -error;
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index bc411c8..81ffe71 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -856,7 +856,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  		case SCTP_CID_ASCONF:
>  		case SCTP_CID_FWD_TSN:
>  			status = sctp_packet_transmit_chunk(packet, chunk,
> -							    one_packet);
> +							    one_packet, 1);
>  			if (status  != SCTP_XMIT_OK) {
>  				/* put the chunk back */
>  				list_add(&chunk->list, &q->control_chunk_list);
> @@ -990,7 +990,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  					atomic_read(&chunk->skb->users) : -1);
>  
>  			/* Add the chunk to the packet.  */
> -			status = sctp_packet_transmit_chunk(packet, chunk, 0);
> +			status = sctp_packet_transmit_chunk(packet, chunk, 0, 0);
>  
>  			switch (status) {
>  			case SCTP_XMIT_PMTU_FULL:
> 
