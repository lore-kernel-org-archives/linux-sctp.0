From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 23 Apr 2010 15:09:51 +0000
Subject: Re: [PATCH 2/2] sctp: COOKIE-ACK should back to where the COOKIE-ECHO
Message-Id: <4BD1B83F.6090400@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD174DC.40308@cn.fujitsu.com>
In-Reply-To: <4BD174DC.40308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Wei Yongjun wrote:
> An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
> etc.) to the same destination transport address from which it
> received the DATA or control chunk to which it is replying.
> 
> But if endpoint is multi-homed, retransmit COOKIE-ECHO will cause
> COOKIE-ACK be sent back to the destination transport address from
> which the INIT chunk is received. This patch fixed it while
> retransmit COOKIE-ECHO is because of either COOKIE-ECHO lost or
> COOKIE-ACK lost.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  net/sctp/sm_statefuns.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index abf601a..e95f6e5 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -724,10 +724,15 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
>  	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
>  
>  	if (!sctp_process_init(new_asoc, chunk->chunk_hdr->type,
> -			       &chunk->subh.cookie_hdr->c.peer_addr,
> +			       sctp_source(chunk),
>  			       peer_init, GFP_ATOMIC))
>  		goto nomem_init;
>  
> +	/* The peer's original address may not appear in address parameters */
> +	if (!sctp_assoc_add_peer(new_asoc, &chunk->subh.cookie_hdr->c.peer_addr,
> +				 GFP_ATOMIC, SCTP_UNCONFIRMED))
> +		goto nomem_init;
> +

Actually, the interesting thing here is that here is what rfc 4960 states

5.4.  Path Verification
...
 the following rules are applied to all addresses of the
   new association:

   1)  Any address passed to the sender of the INIT by its upper layer
      is automatically considered to be CONFIRMED.

   2)  For the receiver of the COOKIE ECHO, the only CONFIRMED address
      is the one to which the INIT-ACK was sent.

   3)  All other addresses not covered by rules 1 and 2 are considered
      UNCONFIRMED and are subject to probing for verification.


The proper way to solve this is to implement the following text:

   -  A COOKIE ACK MAY be sent to an UNCONFIRMED address, but it MUST be
      bundled with a HEARTBEAT including a nonce.  An implementation
      that does NOT support bundling MUST NOT send a COOKIE ACK to an
      UNCONFIRMED address.

   -  A COOKIE ECHO MAY be sent to an UNCONFIRMED address, but it MUST
      be bundled with a HEARTBEAT including a nonce, and the packet MUST
      NOT exceed the path MTU.  If the implementation does NOT support
      bundling or if the bundled COOKIE ECHO plus HEARTBEAT (including
      nonce) would exceed the path MTU, then the implementation MUST NOT
      send a COOKIE ECHO to an UNCONFIRMED address.

>  	/* SCTP-AUTH:  Now that we've populate required fields in
>  	 * sctp_process_init, set up the assocaition shared keys as
>  	 * necessary so that we can potentially authenticate the ACK
> @@ -1914,6 +1919,9 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(const struct sctp_endpoint *ep,
>  		}
>  	}
>  
> +	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_ON,
> +			SCTP_TRANSPORT(chunk->transport));
> +

sctp_cmd_transport_on() assumes that the chunk passed to it is a HB chunk.
This is not the right thing to do.  I am truly amazed that this worked for you.

-vlad

>  	repl = sctp_make_cookie_ack(new_asoc, chunk);
>  	if (!repl)
>  		goto nomem;
