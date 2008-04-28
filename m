From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 28 Apr 2008 00:45:00 +0000
Subject: Re: [Lksctp-developers] [PATCH] SCTP: Bring SCTP_DELAYED_ACK socket
Message-Id: <48151E0C.2080404@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Wei

One comment.

Wei Yongjun wrote:
>   */
> -static int sctp_getsockopt_delayed_ack_time(struct sock *sk, int len,
> +static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
>  					    char __user *optval,
>  					    int __user *optlen)
>  {
> -	struct sctp_assoc_value  params;
> +	struct sctp_sack_info    params;
>  	struct sctp_association *asoc = NULL;
>  	struct sctp_sock        *sp = sctp_sk(sk);
>  
> -	if (len < sizeof(struct sctp_assoc_value))
> +	if (len = sizeof(struct sctp_sack_info)) {
> +		if (copy_from_user(&params, optval, len))
> +			return -EFAULT;
> +	} else if (len = sizeof(struct sctp_assoc_value)) {
> +		printk(KERN_WARNING "SCTP: Use of struct sctp_sack_info "
> +		       "in delayed_ack socket option deprecated\n");
> +		printk(KERN_WARNING "SCTP: struct sctp_sack_info instead\n");
> +		if (copy_from_user(&params, optval, len))
> +			return -EFAULT;
> +	} else 
>  		return - EINVAL;
>  
> -	len = sizeof(struct sctp_assoc_value);

This was here to allow the app to retrieve the option using a buffer larger
then the needed structure.  However, the new code removed that function.

I believe it's safe to return the new structure when the length passed in
is larger then sctp_sack_info.  If the app is using the old api, it would still
access the correct information.

We'll also need to set 'len' to the size of the structure we are about to return,
otherwise putuser() at the end of the call writes the wrong data.

-vlad

> -
> -	if (copy_from_user(&params, optval, len))
> -		return -EFAULT;
> -
> -	/* Get association, if assoc_id != 0 and the socket is a one
> +	/* Get association, if sack_assoc_id != 0 and the socket is a one
>  	 * to many style socket, and an association was not found, then
>  	 * the id was invalid.
>  	 */
> -	asoc = sctp_id2assoc(sk, params.assoc_id);
> -	if (!asoc && params.assoc_id && sctp_style(sk, UDP))
> +	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
> +	if (!asoc && params.sack_assoc_id && sctp_style(sk, UDP))
>  		return -EINVAL;
>  
>  	if (asoc) {
>  		/* Fetch association values. */
> -		if (asoc->param_flags & SPP_SACKDELAY_ENABLE)
> -			params.assoc_value = jiffies_to_msecs(
> +		if (asoc->param_flags & SPP_SACKDELAY_ENABLE) {
> +			params.sack_delay = jiffies_to_msecs(
>  				asoc->sackdelay);
> -		else
> -			params.assoc_value = 0;
> +			params.sack_freq = asoc->sackfreq;
> +			
> +		} else {
> +			params.sack_delay = 0;
> +			params.sack_freq = 1;
> +		}
>  	} else {
>  		/* Fetch socket values. */
> -		if (sp->param_flags & SPP_SACKDELAY_ENABLE)
> -			params.assoc_value  = sp->sackdelay;
> -		else
> -			params.assoc_value  = 0;
> +		if (sp->param_flags & SPP_SACKDELAY_ENABLE) {
> +			params.sack_delay  = sp->sackdelay;
> +			params.sack_freq = sp->sackfreq;
> +		} else {
> +			params.sack_delay  = 0;
> +			params.sack_freq = 1;
> +		}
>  	}
>  
>  	if (copy_to_user(optval, &params, len))
> @@ -5238,8 +5303,8 @@ SCTP_STATIC int sctp_getsockopt(struct sock *sk, int level, int optname,
>  		retval = sctp_getsockopt_peer_addr_params(sk, len, optval,
>  							  optlen);
>  		break;
> -	case SCTP_DELAYED_ACK_TIME:
> -		retval = sctp_getsockopt_delayed_ack_time(sk, len, optval,
> +	case SCTP_DELAYED_ACK:
> +		retval = sctp_getsockopt_delayed_ack(sk, len, optval,
>  							  optlen);
>  		break;
>  	case SCTP_INITMSG:
> 
> 
> 
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> Don't miss this year's exciting event. There's still time to save $100. 
> Use priority code J8TL2D2. 
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
> 

