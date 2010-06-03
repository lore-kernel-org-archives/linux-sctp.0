From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 08:16:55 +0000
Subject: Re: [PATCH 4/6] sctp multistream scheduling: extend socket API
Message-Id: <4C0764F7.7030300@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>
In-Reply-To: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yaogong Wang <ywang15@ncsu.edu>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org


> Augment SCTP socket API with a new socket option to choose and
> configure scheduling algorithm.
>
> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
> ---
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p3/include/net/sctp/structs.h p4/include/net/sctp/structs.h
> --- p3/include/net/sctp/structs.h	2010-06-02 12:57:24.000000000 -0700
> +++ p4/include/net/sctp/structs.h	2010-06-02 12:58:11.000000000 -0700
> @@ -326,6 +326,8 @@ struct sctp_sock {
>
>  	/* Multistream scheduling  */
>  	const struct sctp_sched_ops *sched_ops;
> +	__u32 sched_priv_len;
> +	__u16 *sched_priv;
>   
>  	struct sctp_initmsg initmsg;
>  	struct sctp_rtoinfo rtoinfo;
> @@ -1691,6 +1693,8 @@ struct sctp_association {
>
>  	/* Multistream scheduling  */
>  	const struct sctp_sched_ops *sched_ops;
> +	__u32 sched_priv_len;
> +	__u16 *sched_priv;
>   

I also see you add "__u16 *sched_internal;" to asoc, those are
the sche base values, and are different between sche.
The socket and assoc may not want to know the detail, raw data
is enough for them, and if we want to add a new sche, we do
not change the struct sctp_sock or struct sctp_association every
time.

>  	/* Heartbeat interval: The endpoint sends out a Heartbeat chunk to
>  	 * the destination address every heartbeat interval. This value
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p3/include/net/sctp/user.h p4/include/net/sctp/user.h
> --- p3/include/net/sctp/user.h	2010-05-28 10:59:23.000000000 -0700
> +++ p4/include/net/sctp/user.h	2010-05-28 11:54:47.000000000 -0700
> @@ -67,6 +67,8 @@ enum sctp_optname {
>  #define SCTP_ASSOCINFO SCTP_ASSOCINFO
>  	SCTP_INITMSG,
>  #define SCTP_INITMSG SCTP_INITMSG
> +	SCTP_SCHED,
> +#define SCTP_SCHED SCTP_SCHED
>  	SCTP_NODELAY, 	/* Get/set nodelay option. */
>  #define SCTP_NODELAY	SCTP_NODELAY
>  	SCTP_AUTOCLOSE,
> @@ -171,8 +173,22 @@ struct sctp_initmsg {
>  	__u16 sinit_max_init_timeo;
>  };
>
> +/*
> + * SCTP Scheduling Structure (SCTP_SCHED)
> + *
> + *   cmsg_level    cmsg_type      cmsg_data[]
> + *   ------------  ------------   ----------------------
> + *   IPPROTO_SCTP  SCTP_SCHED     struct sctp_sched
> + *
> + */
>  #define SCTP_SCHED_NAME_MAX	16
>
> +struct sctp_sched {
> +	char  ssched_name[SCTP_SCHED_NAME_MAX];
> +	__u32 ssched_priv_len;
> +	__u16 ssched_priv[0];
> +};
> +
>  /*
>   * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>   *
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p3/net/sctp/associola.c p4/net/sctp/associola.c
> --- p3/net/sctp/associola.c	2010-06-02 12:57:06.000000000 -0700
> +++ p4/net/sctp/associola.c	2010-06-02 12:57:57.000000000 -0700
> @@ -187,6 +187,14 @@ static struct sctp_association *sctp_ass
>
>  	/* Multistream scheduling  */
>  	asoc->sched_ops = sp->sched_ops;
> +	asoc->sched_priv_len = sp->sched_priv_len;
> +	if (asoc->sched_priv_len) {
> +		asoc->sched_priv = kmalloc(asoc->sched_priv_len, gfp);
> +		if (!asoc->sched_priv)
> +			goto fail_init;
> +		memcpy(asoc->sched_priv, sp->sched_priv, asoc->sched_priv_len);
> +	} else
> +		asoc->sched_priv = NULL;
>
>  	/* Allocate storage for the ssnmap after the inbound and outbound
>  	 * streams have been negotiated during Init.
> @@ -464,6 +472,8 @@ static void sctp_association_destroy(str
>  {
>  	SCTP_ASSERT(asoc->base.dead, "Assoc is not dead", return);
>
> +	kfree(asoc->sched_priv);
> +
>  	sctp_endpoint_put(asoc->ep);
>  	sock_put(asoc->base.sk);
>
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p3/net/sctp/socket.c p4/net/sctp/socket.c
> --- p3/net/sctp/socket.c	2010-05-28 12:38:09.000000000 -0700
> +++ p4/net/sctp/socket.c	2010-05-28 12:36:37.000000000 -0700
> @@ -2580,6 +2580,50 @@ static int sctp_setsockopt_initmsg(struc
>  	return 0;
>  }
>
> +/* Set the multistream scheduling algorithm*/
> +static int sctp_setsockopt_sched(struct sock *sk, char __user *optval,
> +						unsigned int optlen)
> +{
> +	struct sctp_sched *ssched = NULL;
> +	struct sctp_sock *sp = sctp_sk(sk);
> +	int ret = 0;
> +
> +	if (optlen < sizeof(struct sctp_sched))
> +		return -EINVAL;
> +
> +	ssched = kmalloc(optlen, GFP_KERNEL);
> +	if (!ssched)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(ssched, optval, optlen)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (optlen != sizeof(struct sctp_sched) + ssched->ssched_priv_len) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = sctp_set_sched(sk, ssched->ssched_name);
> +	if (ret)
> +		goto out;
> +	sp->sched_priv_len = ssched->ssched_priv_len;
> +	kfree(sp->sched_priv);
> +	if (sp->sched_priv_len) {
> +		sp->sched_priv = kmalloc(sp->sched_priv_len, GFP_KERNEL);
> +		if (!sp->sched_priv) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		memcpy(sp->sched_priv, ssched->ssched_priv, sp->sched_priv_len);
> +	}
> +
> +out:
> +	kfree(ssched);
> +	return ret;
> +}
> +
>  /*
>   * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
>   *
> @@ -3417,6 +3461,9 @@ SCTP_STATIC int sctp_setsockopt(struct s
>  		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
>  		break;
>
> +	case SCTP_SCHED:
> +		retval = sctp_setsockopt_sched(sk, optval, optlen);
> +		break;
>  	case SCTP_INITMSG:
>  		retval = sctp_setsockopt_initmsg(sk, optval, optlen);
>  		break;
> @@ -3642,7 +3689,10 @@ SCTP_STATIC int sctp_init_sock(struct so
>  	sp->initmsg.sinit_max_attempts   = sctp_max_retrans_init;
>  	sp->initmsg.sinit_max_init_timeo = sctp_rto_max;
>
> +	/* Initialize default scheduling algorithm  */
>  	sp->sched_ops = sctp_default_sched_ops;
> +	sp->sched_priv_len = 0;
> +	sp->sched_priv = NULL;
>
>  	/* Initialize default RTO related parameters.  These parameters can
>  	 * be modified for with the SCTP_RTOINFO socket option.
> @@ -3735,6 +3785,9 @@ SCTP_STATIC void sctp_destroy_sock(struc
>
>  	SCTP_DEBUG_PRINTK("sctp_destroy_sock(sk: %p)\n", sk);
>
> +	sctp_cleanup_sched(sk);
> +	kfree(sctp_sk(sk)->sched_priv);
> +
>  	/* Release our hold on the endpoint. */
>  	ep = sctp_sk(sk)->ep;
>  	sctp_endpoint_free(ep);
> @@ -4351,6 +4404,35 @@ static int sctp_getsockopt_initmsg(struc
>  	return 0;
>  }
>
> +/* Get the multistream scheduling algorithm*/
> +static int sctp_getsockopt_sched(struct sock *sk, int len, char __user *optval,
> +							int __user *optlen)
> +{
> +	struct sctp_sched *ssched;
> +	int sz = sizeof(struct sctp_sched) + sctp_sk(sk)->sched_priv_len;
> +	int ret = 0;
> +
> +	if (len < sz)
> +		return -EINVAL;
> +	if (put_user(sz, optlen))
> +		return -EFAULT;
> +
> +	ssched = kmalloc(sz, GFP_KERNEL);
> +	if (!ssched)
> +		return -EFAULT;
> +	memcpy(ssched->ssched_name, sctp_sk(sk)->sched_ops->name,
> +					SCTP_SCHED_NAME_MAX);
> +	ssched->ssched_priv_len = sctp_sk(sk)->sched_priv_len;
> +	memcpy(ssched->ssched_priv, sctp_sk(sk)->sched_priv,
> +					ssched->ssched_priv_len);
> +
> +	if (copy_to_user(optval, ssched, sz))
> +		ret = -EFAULT;
> +
> +	kfree(ssched);
> +	return ret;
> +}
> +
>  static int sctp_getsockopt_peer_addrs_num_old(struct sock *sk, int len,
>  					      char __user *optval,
>  					      int __user *optlen)
> @@ -5605,6 +5687,9 @@ SCTP_STATIC int sctp_getsockopt(struct s
>  	case SCTP_INITMSG:
>  		retval = sctp_getsockopt_initmsg(sk, len, optval, optlen);
>  		break;
> +	case SCTP_SCHED:
> +		retval = sctp_getsockopt_sched(sk, len, optval, optlen);
> +		break;
>  	case SCTP_GET_PEER_ADDRS_NUM_OLD:
>  		retval = sctp_getsockopt_peer_addrs_num_old(sk, len, optval,
>  							    optlen);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
