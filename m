From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 06 Jan 2009 18:20:18 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <4963A0E2.3010306@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Horacio

Few small issues:

> @@ -2539,7 +2540,7 @@ static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, int opt
>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>   *   5.2.2) The input parameters accepted by this call include
>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
> + *   sinfo_pr_value.  The user must provide the sinfo_assoc_id field in
>   *   to this call if the caller is using the UDP model.
>   */
>  static int sctp_setsockopt_default_send_param(struct sock *sk,
> @@ -2563,13 +2564,15 @@ static int sctp_setsockopt_default_send_param(struct sock *sk,
>  		asoc->default_flags = info.sinfo_flags;
>  		asoc->default_ppid = info.sinfo_ppid;
>  		asoc->default_context = info.sinfo_context;
> -		asoc->default_timetolive = info.sinfo_timetolive;
> +		asoc->default_pr_policy = info.sinfo_pr_policy;
> +		asoc->default_pr_value = info.sinfo_pr_value;
>  	} else {
>  		sp->default_stream = info.sinfo_stream;
>  		sp->default_flags = info.sinfo_flags;
>  		sp->default_ppid = info.sinfo_ppid;
>  		sp->default_context = info.sinfo_context;
> -		sp->default_timetolive = info.sinfo_timetolive;
> +		sp->default_pr_policy = info.sinfo_pr_policy;
> +		sp->default_pr_value = info.sinfo_pr_value;
>  	}

The policy value needs to be verified since we don't want to set to a garbage value.

> @@ -6107,10 +6113,13 @@ SCTP_STATIC int sctp_msghdr_parse(const struct msghdr *msg,
>  				(struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
>  
>  			/* Minimally, validate the sinfo_flags. */
> -			if (cmsgs->info->sinfo_flags &
> +/*
> +if (cmsgs->info->sinfo_flags &
>  			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> -			      SCTP_ABORT | SCTP_EOF))
> +			      SCTP_ABORT | SCTP_EOF | SCTP_PR_SCTP_NONE |
> +			      SCTP_PR_SCTP_TTL))
>  				return -EINVAL;
> +*/
>  			break;
>  
>  		default:


Commented out block above.  The sinfo_flags probably shouldn't contain _PR_
flags as it should be filled into the sinfo_pr_policy.  Remember that the flags
are really needed only for interaction with sctp_sendmsg() library call.

-vlad
