From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 06:48:54 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A714256.7060602@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> This patch corrects the conditions under which a SACK will be piggybacked
> on a DATA packet.  The previous condition was incorrect due to a
> misinterpretation of RFC 4960 and/or RFC 2960.  Specifically, the
> following paragraph from section 6.2 had not been implemented correctly:
>
>    Before an endpoint transmits a DATA chunk, if any received DATA
>    chunks have not been acknowledged (e.g., due to delayed ack), the
>    sender should create a SACK and bundle it with the outbound DATA
>    chunk, as long as the size of the final SCTP packet does not exceed
>    the current MTU.  See Section 6.2.
>   

The above text said that SACK is create when the size of the final SCTP
packet
does not exceed  the current MTU. With the patch, what will happend?
If the packet is too large for bundle with SACK, the packet sequence will
like this:

Endpoint A                         Endpoint B

DATA            ------------->
                <-------------     SACK
                <-------------     DATA (size52)
SACK            ------------->
DATA (size52)------------->
                <-------------     SACK
                <-------------     DATA (size52)

The behavior is the same as no delayed ack support. So I think
you also need to check the packet size before append the SACK.


> When about to send a DATA chunk, the code now checks to see if the SACK
> timer is running.  If it is, we know we have a SACK to send to the
> peer, so we append the SACK (assuming available space in the packet)
> and turn off the timer.  For a simple request-response scenario, this
> will result in the SACK being bundled with the response, meaning the
> the SACK is received quickly by the client, and also meaning that no
> separate SACK packet needs to be sent by the server to acknowledge the
> request.  Prior to this patch, a separate SACK packet would have been
> sent by the server SCTP only after its delayed-ACK timer had expired
> (usually 200ms).  This is wasteful of bandwidth, and can also have a
> major negative impact on performance due the interaction of delayed ACKs
> with the Nagle algorithm.
>
> Signed-off-by: Doug Graham <dgraham@nortel.com>
>
> ---
>
> --- linux-2.6.29/net/sctp/output.c	2009/07/24 23:37:44	1.1
> +++ linux-2.6.29/net/sctp/output.c	2009/07/26 03:55:36
> @@ -237,18 +237,19 @@ static sctp_xmit_t sctp_packet_bundle_sa
>  	if (sctp_chunk_is_data(chunk) && !pkt->has_sack &&
>  	    !pkt->has_cookie_echo) {
>  		struct sctp_association *asoc;
> +		struct timer_list *timer;
>  		asoc = pkt->transport->asoc;
> +		timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
>  
> -		if (asoc->a_rwnd > asoc->rwnd) {
> +		/* If the SACK timer is running, we have a pending SACK */
> +		if (timer_pending(timer)) {
>  			struct sctp_chunk *sack;
>  			asoc->a_rwnd = asoc->rwnd;
>  			sack = sctp_make_sack(asoc);
>  			if (sack) {
> -				struct timer_list *timer;
>  				retval = sctp_packet_append_chunk(pkt, sack);
>  				asoc->peer.sack_needed = 0;
> -				timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
> -				if (timer_pending(timer) && del_timer(timer))
> +				if (del_timer(timer))
>  					sctp_association_put(asoc);
>  			}
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>   


