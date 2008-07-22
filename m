From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 22 Jul 2008 18:05:10 +0000
Subject: Re: [2.6 patch] remove sctp_assoc_proc_exit()
Message-Id: <20080722180510.GC6887@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080722172057.GU14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080722172057.GU14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, "David S. Miller" <davem@davemloft.net>, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Tue, Jul 22, 2008 at 08:20:57PM +0300, Adrian Bunk wrote:
> Commit 20c2c1fd6c842caf70dcb1d94b9d58861949fd3d
> (sctp: add sctp/remaddr table to complete RFC remote address table OID)
> added an unused sctp_assoc_proc_exit() function that seems to have been 
> unintentionally created when copying the assocs code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 3020dff4c136f6e7f98e0c02f8b5e1cedfa75d2f 
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 5dd8983..f268910 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -519,8 +519,3 @@ int __init sctp_remaddr_proc_init(void)
>  
>  	return 0;
>  }
> -
> -void sctp_assoc_proc_exit(void)
> -{
> -	remove_proc_entry("remaddr", proc_net_sctp);
> -}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Adrian!

Acked-by: Neil Horman <nhorman@tuxdriver.com>
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
