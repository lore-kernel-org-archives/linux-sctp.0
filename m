From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 16 Jan 2017 13:13:47 +0000
Subject: Re: [PATCH net-next] sctp: remove unused var from sctp_process_asconf
Message-Id: <20170116131347.GA30105@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <5da2cda90a7489b22ae98703d7543c5316bae375.1484336552.git.marcelo.leitner@gmail.com>
In-Reply-To: <5da2cda90a7489b22ae98703d7543c5316bae375.1484336552.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On Fri, Jan 13, 2017 at 06:27:33PM -0200, Marcelo Ricardo Leitner wrote:
> Assigned but not used.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index a15d824a313d310ed03ba77055d22b1c7c9d0662..80a9088084ac0d1116bf983fad9a0cdfddeefe44 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3210,7 +3210,6 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
>  	union sctp_params param;
>  	sctp_addiphdr_t		*hdr;
>  	union sctp_addr_param	*addr_param;
> -	sctp_addip_param_t	*asconf_param;
>  	struct sctp_chunk	*asconf_ack;
>  	__be16	err_code;
>  	int	length = 0;
> @@ -3230,7 +3229,6 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
>  	 * asconf parameter.
>  	 */
>  	length = ntohs(addr_param->p.length);
> -	asconf_param = (void *)addr_param + length;
>  	chunk_len -= length;
>  
>  	/* create an ASCONF_ACK chunk.
> -- 
> 2.9.3
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

