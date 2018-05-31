From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 31 May 2018 12:34:27 +0000
Subject: Re: [PATCH] sctp: use non-archaic spelling of failes
Message-Id: <20180531123427.GF3788@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180531121800.9035-1-cascardo@canonical.com>
In-Reply-To: <20180531121800.9035-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, May 31, 2018 at 09:18:00AM -0300, Thadeu Lima de Souza Cascardo wrote:

Non-archaic.. :-)
I would have thought it was just a typo.

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index c9ae3404b1bb..b71d8e211f50 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3482,7 +3482,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
>  		goto nomem_chunk;
>  
>  	/* Do all the commands now (after allocation), so that we
> -	 * have consistent state if memory allocation failes
> +	 * have consistent state if memory allocation fails
>  	 */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
