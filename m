From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 03 Feb 2013 16:55:07 +0000
Subject: Re: [PATCH 60/62] sctp: convert to idr_alloc()
Message-Id: <20130203165506.GA14054@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-61-git-send-email-tj@kernel.org>
In-Reply-To: <1359854463-2538-61-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

On Sat, Feb 02, 2013 at 05:21:01PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: linux-sctp@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
> 
Makes sense to me
Acked-by: Neil Horman <nhorman@tuxdriver.com>

>  net/sctp/associola.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index b45ed1f..a9962e4 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1592,32 +1592,27 @@ int sctp_assoc_lookup_laddr(struct sctp_association *asoc,
>  /* Set an association id for a given association */
>  int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
>  {
> -	int assoc_id;
> -	int error = 0;
> +	int ret;
>  
>  	/* If the id is already assigned, keep it. */
>  	if (asoc->assoc_id)
> -		return error;
> -retry:
> -	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
> -		return -ENOMEM;
> +		return 0;
>  
> +	idr_preload(gfp);
>  	spin_lock_bh(&sctp_assocs_id_lock);
> -	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,
> -				    idr_low, &assoc_id);
> -	if (!error) {
> -		idr_low = assoc_id + 1;
> +	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
> +	if (ret >= 0) {
> +		idr_low = ret + 1;
>  		if (idr_low = INT_MAX)
>  			idr_low = 1;
>  	}
>  	spin_unlock_bh(&sctp_assocs_id_lock);
> -	if (error = -EAGAIN)
> -		goto retry;
> -	else if (error)
> -		return error;
> +	idr_preload_end();
> +	if (ret < 0)
> +		return ret;
>  
> -	asoc->assoc_id = (sctp_assoc_t) assoc_id;
> -	return error;
> +	asoc->assoc_id = (sctp_assoc_t)ret;
> +	return 0;
>  }
>  
>  /* Free the ASCONF queue */
> -- 
> 1.8.1
> 
> 
