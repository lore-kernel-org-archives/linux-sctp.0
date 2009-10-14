From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 Oct 2009 19:51:51 +0000
Subject: Re: [PATCH] sctp: allow setting path_maxrxt independent of SPP_PMTUD_ENABLE
Message-Id: <4AD62BD7.6030609@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20091013203522.GT1700@shell.iptel.org>
In-Reply-To: <20091013203522.GT1700@shell.iptel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Andrei Pelinescu-Onciul wrote:
> Since draft-ietf-tsvwg-sctpsocket-15.txt, setting the
> SPP_MTUD_ENABLE flag when changing pathmaxrxt via the
> SCTP_PEER_ADDR_PARAMS setsockopt is not required any
> longer.
> 

applied, thanks

-vlad

> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
> ---
>  net/sctp/socket.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 2a21d50..1b04ade 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2300,11 +2300,10 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
>  		}
>  	}
>  
> -	/* Note that unless the spp_flag is set to SPP_PMTUD_ENABLE the value
> -	 * of this field is ignored.  Note also that a value of zero
> -	 * indicates the current setting should be left unchanged.
> +	/* Note that a value of zero indicates the current setting should be
> +	   left unchanged.
>  	 */
> -	if ((params->spp_flags & SPP_PMTUD_ENABLE) && params->spp_pathmaxrxt) {
> +	if (params->spp_pathmaxrxt) {
>  		if (trans) {
>  			trans->pathmaxrxt = params->spp_pathmaxrxt;
>  		} else if (asoc) {
