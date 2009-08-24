From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 24 Aug 2009 14:26:39 +0000
Subject: Re: [PATCH] sctp: fix retransmit for multi-homed endpoints
Message-Id: <4A92A31F.7010903@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A8F618F.70708@cn.fujitsu.com>
In-Reply-To: <4A8F618F.70708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> When T3-rtx has expired on multi-homed endpoints, the outstanding
> DATA chunks may be retransmited to different path, if there are new
> outstanding DATA chunks can be transmit. Such as the following:
> 
>   Endpoint (IP=X,Y)                Endpoint (IP=M,N)
>                                            <--- Send (SizeH0)
>               <--------------   DATA1 (SRC=M)
>                                            <--- Send (SizeH0)
>                                    (DATA2 not send with Nagle Algo)
>              ...T3-rtx expired...
>               <--------------   DATA1 (SRC=N)
>               <--------------   DATA2 (SRC=M)
> 
> DATA1 and DATA2 should be sent bundled with SRC=N. So this patch
> fixed it.

Hard to say if this is the right thing to do.  What happens if we are
here not due to Nagle, but due to congestion delay?  Since we're sending
new data on retransmit path, we may end up with more data outstanding that
is allowed...

Also, if the user over-rode the destination address (new_transport != NULL),
we'll skip the over-ride and transmit on the retransmit path.  Not so good...

Looking at the rfc4960, I can't find anything to allow or prohibit this.  I
can see it being attractive in the Nagle delay above as we'd send only 1 packet
instead of 2.  On the other hand, sending DATA2 on path M may speed up path
failover, which is a good thing.

See my dilemma... :)

-vlad

> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/outqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index d765fc5..4109db8 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -960,7 +960,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  				new_transport = asoc->peer.active_path;
>  
>  			/* Change packets if necessary.  */
> -			if (new_transport != transport) {
> +			if (new_transport != transport && !rtx_timeout) {
>  				transport = new_transport;
>  
>  				/* Schedule to have this transport's

