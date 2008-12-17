From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 17 Dec 2008 21:24:57 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <49496E29.2050109@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Horacio Sanson wrote:
> From: Horacio Sanson <hsanson@skillupjapan.co.jp>
> 
> Modified all relevant structures in all header and source files to
> replace the deprecated sinfo_timetolive field with the newer
> sinfo_pr_policy and sinfo_pr_value.
> 
> Added a new sctp_sinfo_pr_policy enum that contains the different PR policy
> definitions: SCTP_PR_SCTP_NONE and SCTP_PR_SCTP_TTL. And modified the
> values of sctp_sinfo_flags so they use the higher byte only and leave the
> lower byte free for sctp_pr_policy values.

need you sign-off.

> ---
>  include/net/sctp/structs.h |   10 ++++++----
>  include/net/sctp/user.h    |   22 +++++++++++++++++-----
>  net/sctp/associola.c       |    3 ++-
>  net/sctp/chunk.c           |   30 +++++++++++++++++++-----------
>  net/sctp/output.c          |    2 +-
>  net/sctp/socket.c          |   27 ++++++++++++++-------------
>  net/sctp/ulpevent.c        |    3 ++-
>  7 files changed, 61 insertions(+), 36 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 9661d7b..2a86944 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -281,8 +281,9 @@ struct sctp_sock {
>  	__u16 default_stream;
>  	__u32 default_ppid;
>  	__u16 default_flags;
> +	__u16 default_pr_policy;
>  	__u32 default_context;
> -	__u32 default_timetolive;
> +	__u32 default_pr_value;
>  	__u32 default_rcv_context;
>  	int max_burst;
>  
> @@ -626,13 +627,13 @@ struct sctp_datamsg {
>  	struct list_head track;
>  	/* Reference counting. */
>  	atomic_t refcnt;
> +	/* Policy used to determine how expires_at is interpreted */
> +	unsigned long expires_policy;
>  	/* When is this message no longer interesting to the peer? */
>  	unsigned long expires_at;
>  	/* Did the messenge fail to send? */
>  	int send_error;
>  	char send_failed;
> -	/* Control whether chunks from this message can be abandoned. */
> -	char can_abandon;
>  };
>  
>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
> @@ -1759,9 +1760,10 @@ struct sctp_association {
>  	/* Default send parameters. */
>  	__u16 default_stream;
>  	__u16 default_flags;
> +	__u16 default_pr_policy;
>  	__u32 default_ppid;
>  	__u32 default_context;
> -	__u32 default_timetolive;
> +	__u32 default_pr_value;
>  
>  	/* Default receive parameters */
>  	__u32 default_rcv_context;
> diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
> index f205b10..55ecc4a 100644
> --- a/include/net/sctp/user.h
> +++ b/include/net/sctp/user.h
> @@ -183,9 +183,10 @@ struct sctp_sndrcvinfo {
>  	__u16 sinfo_stream;
>  	__u16 sinfo_ssn;
>  	__u16 sinfo_flags;
> +	__u16 sinfo_pr_policy;
>  	__u32 sinfo_ppid;
>  	__u32 sinfo_context;
> -	__u32 sinfo_timetolive;
> +	__u32 sinfo_pr_value;
>  	__u32 sinfo_tsn;
>  	__u32 sinfo_cumtsn;
>  	sctp_assoc_t sinfo_assoc_id;
> @@ -199,12 +200,23 @@ struct sctp_sndrcvinfo {
>   */
>  
>  enum sctp_sinfo_flags {
> -	SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
> -	SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
> -	SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
> -	SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */	
> +	SCTP_EOF       = MSG_FIN,    /* Initiate graceful shutdown process. (0x0200) */
> +	SCTP_UNORDERED = 0x0400,     /* Send/receive message unordered. */
> +	SCTP_ADDR_OVER = 0x0800,     /* Override the primary destination. */
> +	SCTP_ABORT     = 0x1000,     /* Send an ABORT message to the peer. */
>  };
>  

Why?

> +/*
> + *  sinfo_pr_policy: 16 bits (unsigned integer)
> + *
> + *   This field may contain the partial reliability used to
> + *   send the message.
> + */
> +
> +enum sctp_sinfo_pr_policy {
> +	SCTP_PR_SCTP_NONE = 0x0000,  /* Reliable transmission */
> +	SCTP_PR_SCTP_TTL  = 0x0001,  /* Timed partial reliability */
> +};
>  
>  typedef union {
>  	__u8   			raw;
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index f4b2304..c178139 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -302,7 +302,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
>  	asoc->default_ppid = sp->default_ppid;
>  	asoc->default_flags = sp->default_flags;
>  	asoc->default_context = sp->default_context;
> -	asoc->default_timetolive = sp->default_timetolive;
> +	asoc->default_pr_policy = sp->default_pr_policy;
> +	asoc->default_pr_value = sp->default_pr_value;
>  	asoc->default_rcv_context = sp->default_rcv_context;
>  
>  	/* AUTH related initializations */
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 1748ef9..d499962 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -56,7 +56,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
>  	atomic_set(&msg->refcnt, 1);
>  	msg->send_failed = 0;
>  	msg->send_error = 0;
> -	msg->can_abandon = 0;
> +	msg->expires_policy = SCTP_PR_SCTP_NONE;
>  	msg->expires_at = 0;
>  	INIT_LIST_HEAD(&msg->chunks);
>  }
> @@ -170,13 +170,17 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  	/* Note: Calculate this outside of the loop, so that all fragments
>  	 * have the same expiration.
>  	 */
> -	if (sinfo->sinfo_timetolive) {
> -		/* sinfo_timetolive is in milliseconds */
> -		msg->expires_at = jiffies +
> -				    msecs_to_jiffies(sinfo->sinfo_timetolive);
> -		msg->can_abandon = 1;
> -		SCTP_DEBUG_PRINTK("%s: msg:%p expires_at: %ld jiffies:%ld\n",
> -				  __func__, msg, msg->expires_at, jiffies);
> +
> +	msg->expires_policy = sinfo->sinfo_pr_policy;
> +
> +	if(msg->expires_policy) {
> +		switch(msg->expires_policy) {
> +			case SCTP_PR_SCTP_TTL:
> +				/* sinfo_timetolive is in milliseconds */
> +					msg->expires_at = jiffies +
> +						msecs_to_jiffies(sinfo->sinfo_pr_value);
> +				break;
> +		}

The one problem with this approach is if the user is still using the older structure that might have
value uninitialized.  I will most likely be 0, not 1, but also could be something entirely bogus if
the user didn't zero-out the structure.  So, I think the TTL policy should be a default assumption and
the sinfo_pr_value (equivalent to the old sinfo_timetoliv) needs to be checked to see if the TTL policy
applies.

Also, msg->expires_policy needs to be set only if sinfo_pr_policy is truly set correctly.

>  	}
>  
>  	max = asoc->frag_point;
> @@ -291,11 +295,15 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
>  {
>  	struct sctp_datamsg *msg = chunk->msg;
>  
> -	if (!msg->can_abandon)
> +	if (!msg->expires_policy)
>  		return 0;
>  
> -	if (time_after(jiffies, msg->expires_at))
> -		return 1;
> +	switch(msg->expires_policy) {
> +		case SCTP_PR_SCTP_TTL:
> +			if(time_after(jiffies, msg->expires_at))
> +				return 1;
> +			break;
> +	}
>  
>  	return 0;
>  }
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index c3f417f..b344a9d 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -745,7 +745,7 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
>  	asoc->peer.rwnd = rwnd;
>  	/* Has been accepted for transmission. */
>  	if (!asoc->peer.prsctp_capable)
> -		chunk->msg->can_abandon = 0;
> +		chunk->msg->expires_policy = SCTP_PR_SCTP_NONE;
>  
>  finish:
>  	return retval;
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index a1b9045..eef5842 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1698,7 +1698,8 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  		default_sinfo.sinfo_flags = asoc->default_flags;
>  		default_sinfo.sinfo_ppid = asoc->default_ppid;
>  		default_sinfo.sinfo_context = asoc->default_context;
> -		default_sinfo.sinfo_timetolive = asoc->default_timetolive;
> +		default_sinfo.sinfo_pr_policy = asoc->default_pr_policy;
> +		default_sinfo.sinfo_pr_value = asoc->default_pr_value;
>  		default_sinfo.sinfo_assoc_id = sctp_assoc2id(asoc);
>  		sinfo = &default_sinfo;
>  	}
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
>  

Need to do validation on the pr_policy value to make sure it's valid.

>  	return 0;
> @@ -3524,7 +3527,8 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
>  	sp->default_ppid = 0;
>  	sp->default_flags = 0;
>  	sp->default_context = 0;
> -	sp->default_timetolive = 0;
> +	sp->default_pr_policy = 0;

Initialize policy to the enum you defined.

> +	sp->default_pr_value = 0;
>  
>  	sp->default_rcv_context = 0;
>  	sp->max_burst = sctp_max_burst;
> @@ -4824,7 +4828,7 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>   *   5.2.2) The input parameters accepted by this call include
>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
> + *   sinfo_pr_value.  The user must provide the sinfo_assoc_id field in
>   *   to this call if the caller is using the UDP model.
>   *
>   *   For getsockopt, it get the default sctp_sndrcvinfo structure.
> @@ -4854,13 +4858,15 @@ static int sctp_getsockopt_default_send_param(struct sock *sk,
>  		info.sinfo_flags = asoc->default_flags;
>  		info.sinfo_ppid = asoc->default_ppid;
>  		info.sinfo_context = asoc->default_context;
> -		info.sinfo_timetolive = asoc->default_timetolive;
> +		info.sinfo_pr_policy = asoc->default_pr_policy;
> +		info.sinfo_pr_value = asoc->default_pr_value;
>  	} else {
>  		info.sinfo_stream = sp->default_stream;
>  		info.sinfo_flags = sp->default_flags;
>  		info.sinfo_ppid = sp->default_ppid;
>  		info.sinfo_context = sp->default_context;
> -		info.sinfo_timetolive = sp->default_timetolive;
> +		info.sinfo_pr_policy = sp->default_pr_policy;
> +		info.sinfo_pr_value = sp->default_pr_value;
>  	}
>  
>  	if (put_user(len, optlen))
> @@ -6106,11 +6112,6 @@ SCTP_STATIC int sctp_msghdr_parse(const struct msghdr *msg,
>  			cmsgs->info >  				(struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
>  
> -			/* Minimally, validate the sinfo_flags. */
> -			if (cmsgs->info->sinfo_flags &
> -			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> -			      SCTP_ABORT | SCTP_EOF))
> -				return -EINVAL;

Why?

>  			break;
>  
>  		default:
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index 5f186ca..2c6f111 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -948,7 +948,8 @@ void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
>  	sinfo.sinfo_context = event->asoc->default_rcv_context;
>  
>  	/* These fields are not used while receiving. */
> -	sinfo.sinfo_timetolive = 0;
> +	sinfo.sinfo_pr_policy = 0;
> +	sinfo.sinfo_pr_value = 0;
>  
>  	put_cmsg(msghdr, IPPROTO_SCTP, SCTP_SNDRCV,
>  		 sizeof(struct sctp_sndrcvinfo), (void *)&sinfo);


-vlad
