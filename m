From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 06 Jun 2008 14:22:31 +0000
Subject: Re: [PATCH] SCTP: Validate initiate tag and chunk type if
Message-Id: <20080606111055.GC2349@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4848E5FE.7080309@cn.fujitsu.com>
In-Reply-To: <4848E5FE.7080309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jun 06, 2008 at 03:23:42PM +0800, Wei Yongjun wrote:
> This patch add to validate initiate tag and chunk type if verification tag 
> is 0 when handling ICMP message.
>
> RFC 4960, Appendix C. ICMP Handling
>
> ICMP6) An implementation MUST validate that the Verification Tag contained 
> in the ICMP message matches the Verification Tag of the peer.  If the 
> Verification Tag is not 0 and does NOT match, discard the ICMP message.  If 
> it is 0 and the ICMP message contains enough bytes to verify that the chunk 
> type is an INIT chunk and that the Initiate Tag matches the tag of the 
> peer, continue with ICMP7.  If the ICMP message is too short or the chunk 
> type or the Initiate Tag does not match, silently discard the packet.
>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>
> --- a/net/sctp/input.c	2008-05-31 23:49:24.000000000 -0400
> +++ b/net/sctp/input.c	2008-06-01 04:23:27.000000000 -0400
> @@ -430,6 +430,9 @@ struct sock *sctp_err_lookup(int family,
> 	struct sock *sk = NULL;
> 	struct sctp_association *asoc;
> 	struct sctp_transport *transport = NULL;
> +	struct sctp_init_chunk *chunkhdr;
> +	__u32 vtag = ntohl(sctphdr->vtag);
> +	int len = skb->len - ((void *)sctphdr - (void *)skb->data);
>
> 	*app = NULL; *tpp = NULL;
>
> @@ -451,7 +454,29 @@ struct sock *sctp_err_lookup(int family,
>
> 	sk = asoc->base.sk;
>
> -	if (ntohl(sctphdr->vtag) != asoc->c.peer_vtag) {
> +	/* RFC 4960, Appendix C. ICMP Handling
> +	 *
> +	 * ICMP6) An implementation MUST validate that the Verification Tag
> +	 * contained in the ICMP message matches the Verification Tag of
> +	 * the peer.  If the Verification Tag is not 0 and does NOT
> +	 * match, discard the ICMP message.  If it is 0 and the ICMP
> +	 * message contains enough bytes to verify that the chunk type is
> +	 * an INIT chunk and that the Initiate Tag matches the tag of the
> +	 * peer, continue with ICMP7.  If the ICMP message is too short
> +	 * or the chunk type or the Initiate Tag does not match, silently
> +	 * discard the packet.
> +	 */
> +	if (vtag = 0) {
> +		chunkhdr = (struct sctp_init_chunk *)((void *)sctphdr
> +				+ sizeof(struct sctphdr));
> +		if (len < sizeof(struct sctphdr) + sizeof(sctp_chunkhdr_t)
> +			  + sizeof(__be32)
> +		    || chunkhdr->chunk_hdr.type != SCTP_CID_INIT
> +		    || ntohl(chunkhdr->init_hdr.init_tag) != asoc->c.my_vtag) {
> +			ICMP_INC_STATS_BH(ICMP_MIB_INERRORS);
> +			goto out;
> +		}
> +	} else if (vtag != asoc->c.peer_vtag) {
> 		ICMP_INC_STATS_BH(ICMP_MIB_INERRORS);
> 		goto out;
> 	}
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I see that the the above comments relate specifically to ICMP6, but
sctp_err_lookup is common between ipv4 and ipv6 sctp.  I assume the same
verification requirement is common to v4 and v6 as well (despite the comment).
I don't see how it can hurt to check in both cases, but I wanted to be certain.

Regards
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
