From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 12 Jan 2018 20:16:00 +0000
Subject: Re: [PATCH net] sctp: removed unused var from sctp_make_auth
Message-Id: <20180112201600.GG20015@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <a3ff9e23cd1c4c040c76b80196d1c3b99fe22bb6.1515687693.git.marcelo.leitner@gmail.com>
In-Reply-To: <a3ff9e23cd1c4c040c76b80196d1c3b99fe22bb6.1515687693.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Jan 11, 2018 at 02:22:07PM -0200, Marcelo Ricardo Leitner wrote:
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 9bf575f2e8ed0888e0219a872e84018ada5064e0..f08531de5682256064ce35e3d44200caa71c3db8 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1273,7 +1273,6 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
>  	struct sctp_authhdr auth_hdr;
>  	struct sctp_hmac *hmac_desc;
>  	struct sctp_chunk *retval;
> -	__u8 *hmac;
>  
>  	/* Get the first hmac that the peer told us to use */
>  	hmac_desc = sctp_auth_asoc_get_hmac(asoc);
> @@ -1292,7 +1291,7 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc)
>  	retval->subh.auth_hdr = sctp_addto_chunk(retval, sizeof(auth_hdr),
>  						 &auth_hdr);
>  
> -	hmac = skb_put_zero(retval->skb, hmac_desc->hmac_len);
> +	skb_put_zero(retval->skb, hmac_desc->hmac_len);
>  
>  	/* Adjust the chunk header to include the empty MAC */
>  	retval->chunk_hdr->length > -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
