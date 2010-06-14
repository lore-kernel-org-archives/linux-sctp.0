From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 14 Jun 2010 18:04:44 +0000
Subject: Re: [PATCH v3 3/3] sctp: COOKIE-ACK should back to where the COOKIE-ECHO
Message-Id: <4C166F3C.8040302@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C05FC8E.8050201@cn.fujitsu.com>
In-Reply-To: <4C05FC8E.8050201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Wei Yongjun wrote:
> This patch fixed to send COOKIE-ACK back to where the COOKIE-ECHO
> came from, and if COOKIE ACK is sent to an UNCONFIRMED address,
> bundled it with a HEARTBEAT including a nonce. Based on RFC4960:
> 
>   Section 6.4.  Multi-Homed SCTP Endpoints
> 
>   An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
>   etc.) to the same destination transport address from which it
>   received the DATA or control chunk to which it is replying.
> 
>   Section 5.4.  Path Verification:
> 
>   -  A COOKIE ACK MAY be sent to an UNCONFIRMED address, but it MUST be
>      bundled with a HEARTBEAT including a nonce.  An implementation
>      that does NOT support bundling MUST NOT send a COOKIE ACK to an
>      UNCONFIRMED address.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
> v2 -> V3
>   - bundle HB at the first
>   - update error counters, and set hb_sent to update timer when expires
> ---
>  net/sctp/output.c        |   27 +++++++++++++++++++++++++++
>  net/sctp/outqueue.c      |    1 +
>  net/sctp/sm_make_chunk.c |    4 ++--
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index a646681..40f5d76 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -260,6 +260,28 @@ static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  	return retval;
>  }
>  
> +/* Try to bundle a HEARTBEAT with the packet. */
> +static sctp_xmit_t sctp_packet_bundle_hb(struct sctp_packet *pkt,
> +					 struct sctp_chunk *chunk)
> +{
> +	sctp_xmit_t retval = SCTP_XMIT_OK;
> +
> +	if (pkt->transport->state = SCTP_UNCONFIRMED &&
> +	    chunk->chunk_hdr->type = SCTP_CID_COOKIE_ACK) {
> +		struct sctp_transport *transport = pkt->transport;
> +		struct sctp_chunk *hb;
> +
> +		hb = sctp_make_heartbeat(transport->asoc, transport);
> +		if (hb) {
> +			retval = sctp_packet_append_chunk(pkt, hb);
> +			transport->hb_sent = 1;
> +			transport->error_count++;
> +		}
> +	}
> +

You need to check that HB are enabled on the transport.  If the HB are disabled,
we can't send the cookie-ack.

-vlad

> +	return retval;
> +}
> +
>  /* Append a chunk to the offered packet reporting back any inability to do
>   * so.
>   */
> @@ -292,6 +314,11 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
>  	if (retval != SCTP_XMIT_OK)
>  		goto finish;
>  
> +	/* Try to bundle HEARTBEAT chunk */
> +	retval = sctp_packet_bundle_hb(packet, chunk);
> +	if (retval != SCTP_XMIT_OK)
> +		goto finish;
> +
>  	/* Check to see if this chunk will fit into the packet */
>  	retval = sctp_packet_will_fit(packet, chunk, chunk_len);
>  	if (retval != SCTP_XMIT_OK)
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 782eeeb..2ff4c99 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -800,6 +800,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
>  			 */
>  			if (chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT &&
>  			    chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT_ACK &&
> +			    chunk->chunk_hdr->type != SCTP_CID_COOKIE_ACK &&
>  			    chunk->chunk_hdr->type != SCTP_CID_ASCONF_ACK)
>  				new_transport = asoc->peer.active_path;
>  		}
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 459ebff..7d270d6 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -602,8 +602,8 @@ struct sctp_chunk *sctp_make_cookie_ack(const struct sctp_association *asoc,
>  	 *
>  	 * [COOKIE ACK back to where the COOKIE ECHO came from.]
>  	 */
> -	if (retval && chunk)
> -		retval->transport = chunk->transport;
> +	if (retval)
> +		retval->dest = chunk->source;
>  
>  	return retval;
>  }
