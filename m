From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Feb 2018 20:30:46 +0000
Subject: Re: [PATCH V6 2/4] sctp: Add ip option support
Message-Id: <20180214203046.GB4625@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180213205444.4559-1-richard_c_haines@btinternet.com>
In-Reply-To: <20180213205444.4559-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

Hi,

On Tue, Feb 13, 2018 at 08:54:44PM +0000, Richard Haines wrote:
...
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index bf271f8..8307968 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3138,6 +3138,7 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
>  static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
> +	struct sctp_af *af = sp->pf->af;
>  	struct sctp_assoc_value params;
>  	struct sctp_association *asoc;
>  	int val;
> @@ -3159,10 +3160,13 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
>  		return -EINVAL;
>  	}
>  
> +	asoc = sctp_id2assoc(sk, params.assoc_id);
> +
>  	if (val) {
>  		int min_len, max_len;
>  
> -		min_len = SCTP_DEFAULT_MINSEGMENT - sp->pf->af->net_header_len;
> +		min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
> +		min_len -= af->ip_options_len(asoc->base.sk);

We have an issue here. asoc may be NULL, in case the user supplied
asoc id is invalid. Then if it also specified the maxseg 'val', it
would trigger a NULL deref here.

You don't need to find the asoc, to then get to the socket. You can
use the sk function parameter, it's the same value here. Then you
don't need to move the sctp_id2assoc() call.

>  		min_len -= sizeof(struct sctphdr) +
>  			   sizeof(struct sctp_data_chunk);
>  
> @@ -3172,10 +3176,10 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
>  			return -EINVAL;
>  	}
>  
> -	asoc = sctp_id2assoc(sk, params.assoc_id);
>  	if (asoc) {
>  		if (val = 0) {
> -			val = asoc->pathmtu - sp->pf->af->net_header_len;
> +			val = asoc->pathmtu - af->net_header_len;
> +			val -= af->ip_options_len(asoc->base.sk);

You may use sk directly here too.

Other than these, LGTM.

>  			val -= sizeof(struct sctphdr) +
>  			       sctp_datachk_len(&asoc->stream);
>  		}
> @@ -5087,9 +5091,11 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
>  	sctp_copy_sock(sock->sk, sk, asoc);
>  
>  	/* Make peeled-off sockets more like 1-1 accepted sockets.
> -	 * Set the daddr and initialize id to something more random
> +	 * Set the daddr and initialize id to something more random and also
> +	 * copy over any ip options.
>  	 */
>  	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
> +	sp->pf->copy_ip_options(sk, sock->sk);
>  
>  	/* Populate the fields of the newsk from the oldsk and migrate the
>  	 * asoc to the newsk.
> -- 
> 2.14.3
> 
