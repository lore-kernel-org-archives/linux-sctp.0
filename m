From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 12 Dec 2017 16:08:00 +0000
Subject: Re: [PATCH 2/4] sctp: Add ip option support
Message-Id: <20171212160800.GE3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171127193121.2666-1-richard_c_haines@btinternet.com>
In-Reply-To: <20171127193121.2666-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

Hi Richard,

On Mon, Nov 27, 2017 at 07:31:21PM +0000, Richard Haines wrote:
...
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3123,8 +3123,10 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
>  
>  	if (asoc) {
>  		if (val = 0) {
> +			struct sctp_af *af = sp->pf->af;
>  			val = asoc->pathmtu;
> -			val -= sp->pf->af->net_header_len;
> +			val -= af->ip_options_len(asoc->base.sk);
> +			val -= af->net_header_len;
>  			val -= sizeof(struct sctphdr) +
>  					sizeof(struct sctp_data_chunk);
>  		}

Right below here there is a call to sctp_frag_point(). That function
also needs this tweak.

Yes, we should simplify all these calculations. I have a patch to use
sctp_frag_point on where it is currently recalculating it on
sctp_datamsg_from_user(), but probably should include other places as
well.

  Marcelo
