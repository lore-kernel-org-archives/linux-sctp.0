From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 14 Dec 2017 18:26:49 +0000
Subject: Re: [PATCHv2 net-next 8/8] sctp: support sysctl to allow users to use stream interleave
Message-Id: <20171214182649.GP3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <2613f085c987063fba3bc7a45cadedd99cae19e3.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <2613f085c987063fba3bc7a45cadedd99cae19e3.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Fri, Dec 15, 2017 at 12:41:32AM +0800, Xin Long wrote:
> This is the last patch for support of stream interleave, after this patch,
> users could enable stream interleave by systcl -w net.sctp.intl_enable=1.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo R. Leitner <marcelo.leitner@gmail.com>

Thanks Xin!

> ---
>  net/sctp/sysctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index ef7ca44..33ca5b7 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -289,6 +289,13 @@ static struct ctl_table sctp_net_table[] = {
>  		.proc_handler	= proc_sctp_do_auth,
>  	},
>  	{
> +		.procname	= "intl_enable",
> +		.data		= &init_net.sctp.intl_enable,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
>  		.procname	= "addr_scope_policy",
>  		.data		= &init_net.sctp.scope_policy,
>  		.maxlen		= sizeof(int),
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
