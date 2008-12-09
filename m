From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 09 Dec 2008 15:38:34 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081209153834.GA5527@dhcp35.suse.cz>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
To: linux-sctp@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[CCing David Sterba]

On Mon 08-12-08 13:53:11, Vlad Yasevich wrote:
[...]
> Michal
> 
> Can you try this patch.  This applies on top of a clean tree.  I've started a
> run with it here as well.

I am still testing with your previous patch (sent in private email -
attached) and the kernel survived overnight. I will give it another day
and then try it without patch. Unfortunatelly it can be HW related so I
don't want to make any fast statements.

I can try the following patch afterwards.

> 
> Thanks
> -vlad

> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 247ebc9..0fdf544 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -604,6 +604,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
>  		if (fast_rtx && !chunk->fast_retransmit)
>  			continue;
>  
> +again:
>  		/* Attempt to append this chunk to the packet. */
>  		status = sctp_packet_append_chunk(pkt, chunk);
>  
> @@ -617,20 +618,14 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
>  			 */
>  			if (rtx_timeout || fast_rtx)
>  				done = 1;
> +			else {
> +				/* Bundle this chunk in the next round.  */
> +				goto again;
> +			}
>  
> -			/* Bundle next chunk in the next round.  */
>  			break;
>  
>  		case SCTP_XMIT_RWND_FULL:
> -			/* Send this packet. */
> -			error = sctp_packet_transmit(pkt);
> -
> -			/* Stop sending DATA as there is no more room
> -			 * at the receiver.
> -			 */
> -			done = 1;
> -			break;
> -
>  		case SCTP_XMIT_NAGLE_DELAY:
>  			/* Send this packet. */
>  			error = sctp_packet_transmit(pkt);
> @@ -929,7 +924,6 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  		}
>  
>  		/* Finally, transmit new packets.  */
> -		start_timer = 0;
>  		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
>  			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
>  			 * stream identifier.
> @@ -1028,7 +1022,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  			list_add_tail(&chunk->transmitted_list,
>  				      &transport->transmitted);
>  
> -			sctp_transport_reset_timers(transport, start_timer-1);
> +			sctp_transport_reset_timers(transport, 0);
>  
>  			q->empty = 0;
>  


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--ReaqsoxgOBHFXBhH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="try.patch"

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 247ebc9..a3c930b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -605,6 +605,7 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			continue;
 
 		/* Attempt to append this chunk to the packet. */
+append:
 		status = sctp_packet_append_chunk(pkt, chunk);
 
 		switch (status) {
@@ -619,9 +620,12 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 				done = 1;
 
 			/* Bundle next chunk in the next round.  */
+			goto append;
+			/* NOT REACHED */
 			break;
 
 		case SCTP_XMIT_RWND_FULL:
+		case SCTP_XMIT_NAGLE_DELAY:
 			/* Send this packet. */
 			error = sctp_packet_transmit(pkt);
 
@@ -631,14 +635,6 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 			done = 1;
 			break;
 
-		case SCTP_XMIT_NAGLE_DELAY:
-			/* Send this packet. */
-			error = sctp_packet_transmit(pkt);
-
-			/* Stop sending DATA because of nagle delay. */
-			done = 1;
-			break;
-
 		default:
 			/* The append was successful, so add this chunk to
 			 * the transmitted list.

--ReaqsoxgOBHFXBhH--
