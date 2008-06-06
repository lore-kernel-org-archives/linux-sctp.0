From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 06 Jun 2008 11:06:03 +0000
Subject: Re: [PATCH] SCTP: Remove the proc fs entry if fail to set up proc
Message-Id: <20080606110603.GB2349@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4848E9AF.4010204@cn.fujitsu.com>
In-Reply-To: <4848E9AF.4010204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jun 06, 2008 at 03:39:27PM +0800, Wei Yongjun wrote:
> This patch remove the proc fs entry which has been created if fail to
> set up proc fs entry for the SCTP protocol.
>
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>
> --- a/net/sctp/protocol.c	2008-05-31 23:49:24.000000000 -0400
> +++ b/net/sctp/protocol.c	2008-06-01 04:35:40.000000000 -0400
> @@ -108,14 +108,23 @@ static __init int sctp_proc_init(void)
> 	}
>
> 	if (sctp_snmp_proc_init())
> -		goto out_nomem;
> +		goto err_snmp_proc_init;
> 	if (sctp_eps_proc_init())
> -		goto out_nomem;
> +		goto err_eps_proc_init;
> 	if (sctp_assocs_proc_init())
> -		goto out_nomem;
> +		goto err_assocs_proc_init;
>
> 	return 0;
>
> +err_assocs_proc_init:
> +	sctp_eps_proc_exit();
> +err_eps_proc_init:
> +	sctp_snmp_proc_exit();
> +err_snmp_proc_init:
> +	if (proc_net_sctp) {
> +		proc_net_sctp = NULL;
> +		remove_proc_entry("sctp", init_net.proc_net);
> +	}
> out_nomem:
> 	return -ENOMEM;
> }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Neil Horman <nhorman@tuxdriver.com>

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
