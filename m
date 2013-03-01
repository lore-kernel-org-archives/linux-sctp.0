From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 01 Mar 2013 14:35:17 +0000
Subject: Re: [patch] sctp: use the passed in gfp flags instead GFP_KERNEL
Message-Id: <20130301143517.GA1523@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20130301052743.GD2669@longonot.mountain>
In-Reply-To: <20130301052743.GD2669@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Mar 01, 2013 at 08:27:43AM +0300, Dan Carpenter wrote:
> This patch doesn't change how the code works because in the current
> kernel gfp is always GFP_KERNEL.  But gfp was obviously intended
> instead of GFP_KERNEL.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index 2b3ef03..12ed45d 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -155,7 +155,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
>  
>  	/* SCTP-AUTH extensions*/
>  	INIT_LIST_HEAD(&ep->endpoint_shared_keys);
> -	null_key = sctp_auth_shkey_create(0, GFP_KERNEL);
> +	null_key = sctp_auth_shkey_create(0, gfp);
>  	if (!null_key)
>  		goto nomem;
>  
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
