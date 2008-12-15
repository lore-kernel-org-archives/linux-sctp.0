From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 15 Dec 2008 15:55:33 +0000
Subject: Re: [PATCH] Replace timetolive with pr_policy and pr_value
Message-Id: <49467DF5.8070203@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <6156dd8b0812021759x65c49f98s2367e8493d4432b8@mail.gmail.com>
In-Reply-To: <6156dd8b0812021759x65c49f98s2367e8493d4432b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> I created a new patch set that fixes the SCTP_PR_SCTP_RTX partial
> reliability that was not working and added a test program to test it.
> Again all v4tests and v6tests pass including my own tests.
> 
> This includes the previous patches so the previous ones should be
> ignored. But no one seems to be looking at my patches so I think there
> should be no problems anyway  :( .
> 
> 

I am looking, I am just busy with other things as well.  Please be patient.

As a first step that will make review much easier, please get rid of the whitespace
changes that show up.  That will improve the readability of the patches.

Also, please separate the patches into separate e-mails.  Look at git-send-email
and git-format-patch for more information.

Thanks
-vlad

> 
> 
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 9661d7b..ffda4c5 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -208,7 +208,7 @@ extern struct sctp_globals {
>  
>  	/* Lock that protects the local_addr_list writers */
>  	spinlock_t addr_list_lock;
> -	
> +
>  	/* Flag to indicate if addip is enabled. */
>  	int addip_enable;
>  	int addip_noauth_enable;
> @@ -282,7 +282,8 @@ struct sctp_sock {
>  	__u32 default_ppid;
>  	__u16 default_flags;
>  	__u32 default_context;
> -	__u32 default_timetolive;
> +	__u16 default_pr_policy;
> +	__u32 default_pr_value;

Please don't add any memory holes when adding new entries to the structure.

>  	__u32 default_rcv_context;
>  	int max_burst;
>  
> @@ -390,7 +391,7 @@ struct sctp_cookie {
>  	/* This holds the originating address of the INIT packet.  */
>  	union sctp_addr peer_addr;
>  
> -	/* IG Section 2.35.3 
> +	/* IG Section 2.35.3
>  	 * Include the source port of the INIT-ACK
>  	 */
>  	__u16		my_port;
> @@ -398,7 +399,7 @@ struct sctp_cookie {
>  	__u8 prsctp_capable;
>  
>  	/* Padding for future use */
> -	__u8 padding;  		
> +	__u8 padding;

White space?  Please limit the scope of your patches.

>  
>  	__u32 adaptation_ind;
>  
> @@ -512,12 +513,12 @@ static inline __u16 sctp_ssn_next(struct sctp_stream *stream, __u16 id)
>  }
>  
>  /* Skip over this ssn and all below. */
> -static inline void sctp_ssn_skip(struct sctp_stream *stream, __u16 id, 
> +static inline void sctp_ssn_skip(struct sctp_stream *stream, __u16 id,
>  				 __u16 ssn)
>  {
>  	stream->ssn[id] = ssn+1;
>  }
> -              
> +

More whitespace?

>  /*
>   * Pointers to address related SCTP functions.
>   * (i.e. things that depend on the address family.)
> @@ -575,7 +576,7 @@ struct sctp_af {
>  					    union sctp_addr_param *,
>  					    __be16 port, int iif);
>  	int		(*to_addr_param) (const union sctp_addr *,
> -					  union sctp_addr_param *); 
> +					  union sctp_addr_param *);

Again?

>  	int		(*addr_valid)	(union sctp_addr *,
>  					 struct sctp_sock *,
>  					 const struct sk_buff *);
> @@ -626,13 +627,15 @@ struct sctp_datamsg {
>  	struct list_head track;
>  	/* Reference counting. */
>  	atomic_t refcnt;
> +
> +	/* Policy used to determine expired messages  */
> +	unsigned long expires_policy;
>  	/* When is this message no longer interesting to the peer? */
>  	unsigned long expires_at;
>  	/* Did the messenge fail to send? */
>  	int send_error;
>  	char send_failed;
>  	/* Control whether chunks from this message can be abandoned. */
> -	char can_abandon;
>  };
>  
>  struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
> @@ -1339,7 +1342,7 @@ struct sctp_endpoint {
>   	 * 	    on every receive.
>   	 */
>   	__u8 *digest;
> - 
> +

Again?  I am done at this point!!!

>  	/* sendbuf acct. policy.	*/
>  	__u32 sndbuf_policy;
>  
> @@ -1759,9 +1762,10 @@ struct sctp_association {
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
> index f205b10..74c0aba 100644
> --- a/include/net/sctp/user.h
> +++ b/include/net/sctp/user.h
> @@ -71,7 +71,7 @@ enum sctp_optname {
>  #define SCTP_NODELAY	SCTP_NODELAY
>  	SCTP_AUTOCLOSE,
>  #define SCTP_AUTOCLOSE SCTP_AUTOCLOSE
> -	SCTP_SET_PEER_PRIMARY_ADDR, 
> +	SCTP_SET_PEER_PRIMARY_ADDR,
>  #define SCTP_SET_PEER_PRIMARY_ADDR SCTP_SET_PEER_PRIMARY_ADDR
>  	SCTP_PRIMARY_ADDR,
>  #define SCTP_PRIMARY_ADDR SCTP_PRIMARY_ADDR
> @@ -120,7 +120,7 @@ enum sctp_optname {
>  #define SCTP_LOCAL_AUTH_CHUNKS SCTP_LOCAL_AUTH_CHUNKS
>  
>  
> -	/* Internal Socket Options. Some of the sctp library functions are 
> +	/* Internal Socket Options. Some of the sctp library functions are
>  	 * implemented using these socket options.
>  	 */
>  	SCTP_SOCKOPT_BINDX_ADD = 100,/* BINDX requests for adding addresses. */
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
> @@ -199,12 +200,25 @@ struct sctp_sndrcvinfo {
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
> +	SCTP_PR_SCTP_BUF  = 0x0002,  /* Buffer parital reliability (EXPERIMENTAL) */
> +	SCTP_PR_SCTP_RTX  = 0x0003,  /* Retransmis partial reliability (EXPERIMENTAL) */
> +};
>  
>  typedef union {
>  	__u8   			raw;
> @@ -479,7 +493,7 @@ typedef enum sctp_sn_error {
>   *
>   *   The protocol parameters used to initialize and bound retransmission
>   *   timeout (RTO) are tunable.  See [SCTP] for more information on how
> - *   these parameters are used in RTO calculation. 
> + *   these parameters are used in RTO calculation.
>   */
>  struct sctp_rtoinfo {
>  	sctp_assoc_t	srto_assoc_id;
> @@ -717,9 +731,9 @@ struct sctp_authchunks {
>  
>  /*
>   * 8.3, 8.5 get all peer/local addresses in an association.
> - * This parameter struct is used by SCTP_GET_PEER_ADDRS and 
> + * This parameter struct is used by SCTP_GET_PEER_ADDRS and
>   * SCTP_GET_LOCAL_ADDRS socket options used internally to implement
> - * sctp_getpaddrs() and sctp_getladdrs() API. 
> + * sctp_getpaddrs() and sctp_getladdrs() API.
>   */
>  struct sctp_getaddrs_old {
>  	sctp_assoc_t            assoc_id;
> 
> 
> 
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
> index 1748ef9..4cdfe49 100644
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
> @@ -170,13 +170,26 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
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
> +        msg->expires_policy = sinfo->sinfo_pr_policy;
> +
> +	if(msg->expires_policy) {
> +	    switch(msg->expires_policy) {
> +			case SCTP_PR_SCTP_TTL:
> +			    /* sinfo_timetolive is in milliseconds */
> +			    msg->expires_at = jiffies +
> +				msecs_to_jiffies(sinfo->sinfo_pr_value);
> +			    SCTP_DEBUG_PRINTK("%s: msg:%p expires_at: %ld jiffies:%ld\n",
> +				__func__, msg, msg->expires_at, jiffies);
> +			    break;
> +			case SCTP_PR_SCTP_BUF:
> +			    break;
> +			case SCTP_PR_SCTP_RTX:
> +			    msg->expires_at = sinfo->sinfo_pr_value;
> +			    SCTP_DEBUG_PRINTK("%s: msg:%p expires_after: %ld retransmissions \n",
> +				__func__, msg, msg->expires_at);
> +			    break;
> +	    }
>  	}
>  
>  	max = asoc->frag_point;
> @@ -291,11 +304,23 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
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
> +	    case SCTP_PR_SCTP_TTL:
> +		if (time_after(jiffies, msg->expires_at))
> +		    return 1;
> +	    case SCTP_PR_SCTP_BUF:
> +		/* TODO: Implement this */
> +	        return 0;
> +	    case SCTP_PR_SCTP_RTX:
> +		if(--msg->expires_at <= 0) {
> +		    SCTP_DEBUG_PRINTK("%s: msg:%p expires_at: %ld EXPIRED!!\n",
> +				__func__, msg, msg->expires_at);
> +		    return 1;
> +		}
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
> index a1b9045..0dfc137 100644
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
> + *   sinfo_pr_policy.  The user must provide the sinfo_assoc_id field in
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
>  	return 0;
> @@ -3524,7 +3527,8 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
>  	sp->default_ppid = 0;
>  	sp->default_flags = 0;
>  	sp->default_context = 0;
> -	sp->default_timetolive = 0;
> +	sp->default_pr_policy = 0;
> +	sp->default_pr_value = 0;
>  
>  	sp->default_rcv_context = 0;
>  	sp->max_burst = sctp_max_burst;
> @@ -4824,7 +4828,7 @@ static int sctp_getsockopt_adaptation_layer(struct sock *sk, int len,
>   *   in to this call the sctp_sndrcvinfo structure defined in Section
>   *   5.2.2) The input parameters accepted by this call include
>   *   sinfo_stream, sinfo_flags, sinfo_ppid, sinfo_context,
> - *   sinfo_timetolive.  The user must provide the sinfo_assoc_id field in
> + *   sinfo_pr_policy.  The user must provide the sinfo_assoc_id field in
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
> @@ -6107,10 +6113,17 @@ SCTP_STATIC int sctp_msghdr_parse(const struct msghdr *msg,
>  				(struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
>  
>  			/* Minimally, validate the sinfo_flags. */
> +
> +                        /* TODO this validation does not work with the new
> +                         * SCTP_PR_SCTP_XXX flags
> +                         */
> +
> +                        /*
>  			if (cmsgs->info->sinfo_flags &
>  			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
>  			      SCTP_ABORT | SCTP_EOF))
>  				return -EINVAL;
> +                        */
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
> 
> 
> 
> diff --git a/src/func_tests/Makefile.am b/src/func_tests/Makefile.am
> index b985685..a7167d5 100644
> --- a/src/func_tests/Makefile.am
> +++ b/src/func_tests/Makefile.am
> @@ -5,7 +5,7 @@ include $(top_srcdir)/Makefile.rules
>  include $(top_srcdir)/Makefile.dirs
>  
>  # General compilation flags
> -INCLUDES = -I. -I$(top_srcdir)/src/include -I$(top_srcdir)/src/testlib 
> +INCLUDES = -I. -I$(top_srcdir)/src/include -I$(top_srcdir)/src/testlib
>  AM_CFLAGS = -g -Wall -Wstrict-prototypes -Wimplicit-function-declaration
>  AM_LDFLAGS = -lpthread
>  LDADD = $(top_builddir)/src/lib/libsctp.la \
> @@ -27,6 +27,7 @@ PASSING_KERN_TESTS = \
>  	test_connectx \
>  	test_recvmsg \
>  	test_timetolive \
> +	test_rtxtolive \
>  	test_sctp_sendrecvmsg \
>  	test_getname \
>  	test_tcp_style\
> @@ -55,6 +56,7 @@ PASSING_V6_KERN_TESTS = \
>  	test_inaddr_any_v6 \
>  	test_peeloff_v6 \
>  	test_timetolive_v6 \
> +	test_rtxtolive_v6 \
>  	test_sctp_sendrecvmsg_v6 \
>  	test_getname_v6 \
>  	test_tcp_style_v6
> @@ -102,21 +104,22 @@ v6test: ${PASSING_V6_KERN_TESTS}
>  	@echo "Hoody hoo!"
>  
>  # Specifying the sources
> -test_assoc_abort_SOURCES = test_assoc_abort.c 
> -test_assoc_shutdown_SOURCES = test_assoc_shutdown.c 
> -test_autoclose_SOURCES = test_autoclose.c 
> -test_basic_SOURCES = test_basic.c 
> -test_fragments_SOURCES = test_fragments.c 
> -test_inaddr_any_SOURCES = test_inaddr_any.c 
> -test_peeloff_SOURCES = test_peeloff.c 
> -test_sockopt_SOURCES = test_sockopt.c 
> -test_connect_SOURCES = test_connect.c 
> -test_connectx_SOURCES = test_connectx.c 
> -test_recvmsg_SOURCES = test_recvmsg.c 
> +test_assoc_abort_SOURCES = test_assoc_abort.c
> +test_assoc_shutdown_SOURCES = test_assoc_shutdown.c
> +test_autoclose_SOURCES = test_autoclose.c
> +test_basic_SOURCES = test_basic.c
> +test_fragments_SOURCES = test_fragments.c
> +test_inaddr_any_SOURCES = test_inaddr_any.c
> +test_peeloff_SOURCES = test_peeloff.c
> +test_sockopt_SOURCES = test_sockopt.c
> +test_connect_SOURCES = test_connect.c
> +test_connectx_SOURCES = test_connectx.c
> +test_recvmsg_SOURCES = test_recvmsg.c
>  test_timetolive_SOURCES = test_timetolive.c
> +test_rtxtolive_SOURCES = test_rtxtolive.c
>  test_sctp_sendrecvmsg_SOURCES = test_sctp_sendrecvmsg.c
> -test_getname_SOURCES = test_getname.c 
> -test_tcp_style_SOURCES = test_tcp_style.c 
> +test_getname_SOURCES = test_getname.c
> +test_tcp_style_SOURCES = test_tcp_style.c
>  
>  test_1_to_1_socket_bind_listen_SOURCES = test_1_to_1_socket_bind_listen.c
>  test_1_to_1_accept_close_SOURCES = test_1_to_1_accept_close.c
> @@ -157,6 +160,9 @@ test_peeloff_v6_CFLAGS = ${V6FLAGS}
>  test_timetolive_v6_SOURCES = test_timetolive.c
>  test_timetolive_v6_CFLAGS = ${V6FLAGS}
>  
> +test_rtxtolive_v6_SOURCES = test_rtxtolive.c
> +test_rtxtolive_v6_CFLAGS = ${V6FLAGS}
> +
>  test_sctp_sendrecvmsg_v6_SOURCES = test_sctp_sendrecvmsg.c
>  test_sctp_sendrecvmsg_v6_CFLAGS = ${V6FLAGS}
>  
> diff --git a/src/func_tests/test_rtxtolive.c b/src/func_tests/test_rtxtolive.c
> new file mode 100644
> index 0000000..9aa03ad
> --- /dev/null
> +++ b/src/func_tests/test_rtxtolive.c
> @@ -0,0 +1,410 @@
> +/* SCTP kernel Implementation
> + * (C) Copyright IBM Corp. 2001, 2003
> + * Copyright (c) 1999-2000 Cisco, Inc.
> + * Copyright (c) 1999-2001 Motorola, Inc.
> + * Copyright (c) 2001 Intel Corp.
> + * Copyright (c) 2001 Nokia, Inc.
> + *
> + * The SCTP implementation is free software;
> + * you can redistribute it and/or modify it under the terms of
> + * the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * The SCTP implementation is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; without even the implied
> + *                 ************************
> + * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with GNU CC; see the file COPYING.  If not, write to
> + * the Free Software Foundation, 59 Temple Place - Suite 330,
> + * Boston, MA 02111-1307, USA.
> + *
> + * Please send any bug reports or fixes you make to the
> + * email address(es):
> + *    lksctp developers <lksctp-developers@lists.sourceforge.net>
> + *
> + * Or submit a bug report through the following website:
> + *    http://www.sf.net/projects/lksctp
> + *
> + * Any bugs reported to us we will try to fix... any fixes shared will
> + * be incorporated into the next SCTP release.
> + *
> + * Written or modified by:
> + *    Jon Grimm		 <jgrimm@us.ibm.com>
> + *    Sridhar Samudrala  <sri@us.ibm.com>
> + */
> +
> +/*
> + * This is a basic functional test for the SCTP kernel 
> + * implementation of sndrcvinfo.sinfo_pr_value.
> + *
> + * 1) Create two sockets, the listening socket sets its RECVBUF small
> + * 2) Create a connection.  Send enough data to the non-reading listener
> + * to fill the RCVBUF.
> + * 5) Set sinfo_pr_value with SCTP_PR_SCTP_TTL policy on a message and send.
> + * 6) Disable sinfo_pr_value on a message and send.
> + * 7) Wait sinfo_pr_value time.
> + * 8) Read out all the data at the receiver.
> + * 9) Make sure timed out message did not make it.
> + * 10) Make sure that the message with no timeout makes it to the receiver.
> + *
> + * Also test with SEND_FAILED notifications.  Also, use a fragmented
> + * message so as to also exercise the SEND_FAILED of fragmentation
> + * code.
> + */
> +
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <sys/uio.h>
> +#include <netinet/in.h>
> +#include <sys/errno.h>
> +#include <errno.h>
> +#include <netinet/sctp.h>
> +#include <sctputil.h>
> +
> +char *TCID = __FILE__;
> +int TST_TOTAL = 6;
> +int TST_CNT = 0;
> +
> +/* This is the size of our RCVBUF */
> +#define SMALL_RCVBUF 3000
> +
> +/* MAX segment size */
> +#define SMALL_MAXSEG 100
> +
> +/* RWND_SLOP is the extra data that fills up the rwnd */
> +#define RWND_SLOP 100
> +static char *fillmsg = NULL;
> +static char *ttlmsg = "This should time out!\n";
> +static char *nottlmsg = "This should NOT time out!\n";
> +static char ttlfrag[SMALL_MAXSEG*3] = {0};
> +static char *message = "Hello world\n";
> +
> +int main(int argc, char *argv[])
> +{
> +        int sk1, sk2;
> +        sockaddr_storage_t loop1;
> +        sockaddr_storage_t loop2;
> +        struct iovec iov;
> +        struct msghdr inmessage;
> +	struct msghdr outmessage;
> +	char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
> +	char outcmsg[CMSG_SPACE(sizeof(struct sctp_sndrcvinfo))];
> +	struct cmsghdr *cmsg;
> +	struct sctp_sndrcvinfo *sinfo;
> +        struct iovec out_iov;
> +        int error;
> +	int pf_class, af_family;
> +	uint32_t ppid;
> +	uint32_t stream;
> +	sctp_assoc_t associd1, associd2;
> +	struct sctp_assoc_change *sac;
> +	struct sctp_event_subscribe subscribe;
> +	char *big_buffer;
> +	int offset;
> +	struct sctp_send_failed *ssf;
> +	int len; /* Really becomes 2xlen when set. */
> +	int orig_len; 
> +	struct sctp_status gstatus;
> +
> +        /* Rather than fflush() throughout the code, set stdout to
> +	 * be unbuffered.
> +	 */
> +	setvbuf(stdout, NULL, _IONBF, 0);
> +
> +	/* Set some basic values which depend on the address family. */
> +#if TEST_V6
> +	pf_class = PF_INET6;
> +	af_family = AF_INET6;
> +
> +        loop1.v6.sin6_family = AF_INET6;
> +        loop1.v6.sin6_addr = in6addr_loopback;
> +        loop1.v6.sin6_port = htons(SCTP_TESTPORT_1);
> +
> +        loop2.v6.sin6_family = AF_INET6;
> +        loop2.v6.sin6_addr = in6addr_loopback;
> +        loop2.v6.sin6_port = htons(SCTP_TESTPORT_2);
> +#else
> +	pf_class = PF_INET;
> +	af_family = AF_INET;
> +
> +        loop1.v4.sin_family = AF_INET;
> +        loop1.v4.sin_addr.s_addr = SCTP_IP_LOOPBACK;
> +        loop1.v4.sin_port = htons(SCTP_TESTPORT_1);
> +
> +        loop2.v4.sin_family = AF_INET;
> +        loop2.v4.sin_addr.s_addr = SCTP_IP_LOOPBACK;
> +        loop2.v4.sin_port = htons(SCTP_TESTPORT_2);
> +#endif /* TEST_V6 */
> +
> +        /* Create the two endpoints which will talk to each other.  */
> +        sk1 = test_socket(pf_class, SOCK_SEQPACKET, IPPROTO_SCTP);
> +        sk2 = test_socket(pf_class, SOCK_SEQPACKET, IPPROTO_SCTP);
> +
> +	len = sizeof(int);
> +	error = getsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &orig_len,
> +			   &len);
> +	if (error)
> +		tst_brkm(TBROK, tst_exit, "can't get rcvbuf size: %s",
> +			strerror(errno));
> +	/* Set the MAXSEG to something smallish. */
> +	{
> +		int val = SMALL_MAXSEG;
> +		test_setsockopt(sk1, SCTP_MAXSEG, &val, sizeof(val));
> +	}
> +
> +	memset(&subscribe, 0, sizeof(subscribe));
> +	subscribe.sctp_data_io_event = 1;
> +	subscribe.sctp_association_event = 1;
> +	subscribe.sctp_send_failure_event = 1;
> +	test_setsockopt(sk1, SCTP_EVENTS, &subscribe, sizeof(subscribe));
> +	test_setsockopt(sk2, SCTP_EVENTS, &subscribe, sizeof(subscribe));
> +
> +        /* Bind these sockets to the test ports.  */
> +        test_bind(sk1, &loop1.sa, sizeof(loop1));
> +        test_bind(sk2, &loop2.sa, sizeof(loop2));
> +
> +	/*
> +	 * This code sets the associations RWND very small so we can
> +	 * fill it.  It does this by manipulating the rcvbuf as follows:
> +	 * 1) Reduce the rcvbuf size on the socket
> +	 * 2) create an association so that we advertize rcvbuf/2 as
> +	 *    our initial rwnd
> +	 * 3) raise the rcvbuf value so that we don't drop data wile 
> +	 *    receiving later data
> +	 */
> +	len = SMALL_RCVBUF;
> +	error = setsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &len,
> +			   sizeof(len));
> +	if (error)
> +		tst_brkm(TBROK, tst_exit, "setsockopt(SO_RCVBUF): %s",
> +			 strerror(errno));
> +
> +       /* Mark sk2 as being able to accept new associations.  */
> +	test_listen(sk2, 1);
> +
> +        /* Send the first message.  This will create the association.  */
> +        outmessage.msg_name = &loop2;
> +        outmessage.msg_namelen = sizeof(loop2);
> +        outmessage.msg_iov = &out_iov;
> +        outmessage.msg_iovlen = 1;
> +        outmessage.msg_control = outcmsg;
> +        outmessage.msg_controllen = sizeof(outcmsg);
> +        outmessage.msg_flags = 0;
> +	cmsg = CMSG_FIRSTHDR(&outmessage);
> +	cmsg->cmsg_level = IPPROTO_SCTP;
> +	cmsg->cmsg_type = SCTP_SNDRCV;
> +	cmsg->cmsg_len = CMSG_LEN(sizeof(struct sctp_sndrcvinfo));
> +	outmessage.msg_controllen = cmsg->cmsg_len;
> +	sinfo = (struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
> +	memset(sinfo, 0x00, sizeof(struct sctp_sndrcvinfo));
> +	ppid = rand(); /* Choose an arbitrary value. */
> +	stream = 1;
> +	sinfo->sinfo_ppid = ppid;
> +	sinfo->sinfo_stream = stream;
> +        outmessage.msg_iov->iov_base = message;
> +        outmessage.msg_iov->iov_len = strlen(message) + 1;
> +        test_sendmsg(sk1, &outmessage, 0, strlen(message)+1);
> +
> +	/* Initialize inmessage for all receives. */
> +	big_buffer = test_malloc(REALLY_BIG);
> +        memset(&inmessage, 0, sizeof(inmessage));
> +        iov.iov_base = big_buffer;
> +        iov.iov_len = REALLY_BIG;
> +        inmessage.msg_iov = &iov;
> +        inmessage.msg_iovlen = 1;
> +        inmessage.msg_control = incmsg;
> +
> +        /* Get the communication up message on sk2.  */
> +        inmessage.msg_controllen = sizeof(incmsg);
> +        error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
> +	test_check_msg_notification(&inmessage, error,
> +				    sizeof(struct sctp_assoc_change),
> +				    SCTP_ASSOC_CHANGE, SCTP_COMM_UP);
> +	sac = (struct sctp_assoc_change *)iov.iov_base;
> +	associd2 = sac->sac_assoc_id;
> +
> +        /* Get the communication up message on sk1.  */
> +        inmessage.msg_controllen = sizeof(incmsg);
> +        error = test_recvmsg(sk1, &inmessage, MSG_WAITALL);
> +	test_check_msg_notification(&inmessage, error,
> +				    sizeof(struct sctp_assoc_change),
> +				    SCTP_ASSOC_CHANGE, SCTP_COMM_UP);
> +	sac = (struct sctp_assoc_change *)iov.iov_base;
> +	associd1 = sac->sac_assoc_id;
> +
> +	/* restore the rcvbuffer size for the receiving socket */
> +	error = setsockopt(sk2, SOL_SOCKET, SO_RCVBUF, &orig_len,
> +			   sizeof(orig_len));
> +
> +	if (error)
> +		tst_brkm(TBROK, tst_exit, "setsockopt(SO_RCVBUF): %s",
> +			strerror(errno));
> +
> +        /* Get the first data message which was sent.  */
> +        inmessage.msg_controllen = sizeof(incmsg);
> +        error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
> +        test_check_msg_data(&inmessage, error, strlen(message) + 1,
> +			    MSG_EOR, stream, ppid);
> +
> +	/* Figure out how big to make our fillmsg */
> +	len = sizeof(struct sctp_status);
> +	memset(&gstatus,0,sizeof(struct sctp_status));
> +	gstatus.sstat_assoc_id = associd1;
> +	error = getsockopt(sk1, IPPROTO_SCTP, SCTP_STATUS, &gstatus, &len);
> +	
> +	if (error)
> +		tst_brkm(TBROK, tst_exit, "can't get rwnd size: %s",
> +			strerror(errno));
> +	tst_resm(TINFO, "Creating fillmsg of size %d",
> +		 gstatus.sstat_rwnd+RWND_SLOP);
> +	fillmsg = malloc(gstatus.sstat_rwnd+RWND_SLOP);	
> +
> +	/* Send a fillmsg */
> +        outmessage.msg_controllen = sizeof(outcmsg);
> +        outmessage.msg_flags = 0;
> +	cmsg = CMSG_FIRSTHDR(&outmessage);
> +	cmsg->cmsg_level = IPPROTO_SCTP;
> +	cmsg->cmsg_type = SCTP_SNDRCV;
> +	cmsg->cmsg_len = CMSG_LEN(sizeof(struct sctp_sndrcvinfo));
> +	outmessage.msg_controllen = cmsg->cmsg_len;
> +	sinfo = (struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
> +	memset(sinfo, 0x00, sizeof(struct sctp_sndrcvinfo));
> +	ppid++;
> +	stream++;
> +	sinfo->sinfo_ppid = ppid;
> +	sinfo->sinfo_stream = stream;
> +	memset(fillmsg, 'X', gstatus.sstat_rwnd+RWND_SLOP);
> +	fillmsg[gstatus.sstat_rwnd+RWND_SLOP-1] = '\0';
> +	outmessage.msg_iov->iov_base = fillmsg;
> +	outmessage.msg_iov->iov_len = gstatus.sstat_rwnd+RWND_SLOP;
> +	outmessage.msg_name = NULL;
> +	outmessage.msg_namelen = 0;
> +	sinfo->sinfo_assoc_id = associd1;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
> +	sinfo->sinfo_pr_value = 0;
> +	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL,
> +			 gstatus.sstat_rwnd+RWND_SLOP);
> +
> +	/* Now send the message with timeout. */
> +	sinfo->sinfo_ppid = ppid;
> +	sinfo->sinfo_stream = stream;
> +	outmessage.msg_iov->iov_base = ttlmsg;
> +        outmessage.msg_iov->iov_len = strlen(ttlmsg) + 1;
> +	outmessage.msg_name = NULL;
> +	outmessage.msg_namelen = 0;
> +	sinfo->sinfo_assoc_id = associd1;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_RTX;
> +	sinfo->sinfo_pr_value = 2;
> +	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(ttlmsg) + 1);
> +
> +	tst_resm(TPASS, "Send a message with timeout");
> +
> +	/* Next send a message with no timeout. */
> +	sinfo->sinfo_ppid = ppid;
> +	sinfo->sinfo_stream = stream;
> +	outmessage.msg_iov->iov_base = nottlmsg;
> +        outmessage.msg_iov->iov_len = strlen(nottlmsg) + 1;
> +	outmessage.msg_name = NULL;
> +	outmessage.msg_namelen = 0;
> +	sinfo->sinfo_assoc_id = associd1;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
> +	sinfo->sinfo_pr_value = 0;
> +	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(nottlmsg)+1);
> +
> +	tst_resm(TPASS, "Send a message with no timeout");
> +
> +	/* And finally a fragmented message that will time out. */
> +	sinfo->sinfo_ppid = ppid;
> +	sinfo->sinfo_stream = stream;
> +	memset(ttlfrag, '0', sizeof(ttlfrag));
> +	ttlfrag[sizeof(ttlfrag)-1] = '\0';
> +	outmessage.msg_iov->iov_base = ttlfrag;
> +        outmessage.msg_iov->iov_len = sizeof(ttlfrag);
> +	outmessage.msg_name = NULL;
> +	outmessage.msg_namelen = 0;
> +	sinfo->sinfo_assoc_id = associd1;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_RTX;
> +	sinfo->sinfo_pr_value = 2;
> +	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, sizeof(ttlfrag));
> +
> +	tst_resm(TPASS, "Send a fragmented message with timeout");
> +
> +	/* Sleep waiting for the message to time out. */
> +	tst_resm(TINFO, " **  SLEEPING for 3 seconds **");
> +	sleep(3);
> +
> +	/* Read the fillmsg snuck in between the ttl'd messages. */
> +	do {
> +		inmessage.msg_controllen = sizeof(incmsg);
> +		error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
> +	} while (!(inmessage.msg_flags & MSG_EOR));
> +
> +	/* Now get the message that did NOT time out. */
> +	inmessage.msg_controllen = sizeof(incmsg);
> +	error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
> +	test_check_msg_data(&inmessage, error, strlen(nottlmsg) + 1,
> +			    MSG_EOR, stream, ppid);
> +	if (0 != strncmp(iov.iov_base, nottlmsg, strlen(nottlmsg)+1))
> +		tst_brkm(TBROK, tst_exit, "Received Wrong Message !!!");
> +
> +	tst_resm(TPASS, "Receive message with no timeout");
> +
> +	/* Get the SEND_FAILED notification for the message that DID
> +	 * time out.
> +	 */
> +	inmessage.msg_controllen = sizeof(incmsg);
> +	error = test_recvmsg(sk1, &inmessage, MSG_WAITALL);
> +	test_check_msg_notification(&inmessage, error,
> +				    sizeof(struct sctp_send_failed) +
> +							strlen(ttlmsg) + 1,
> +				    SCTP_SEND_FAILED, 0);
> +	ssf = (struct sctp_send_failed *)iov.iov_base;
> +	if (0 != strncmp(ttlmsg, (char *)ssf->ssf_data, strlen(ttlmsg) + 1))
> +		tst_brkm(TBROK, tst_exit, "SEND_FAILED data mismatch");
> +
> +	tst_resm(TPASS, "Receive SEND_FAILED for message with timeout");
> +
> +	/* Get the SEND_FAILED notification for the fragmented message that
> +	 * DID time out.
> +	 */
> +	offset = 0;
> +	do {
> +		inmessage.msg_controllen = sizeof(incmsg);
> +		error = test_recvmsg(sk1, &inmessage, MSG_WAITALL);
> +		test_check_msg_notification(&inmessage, error,
> +					    sizeof(struct sctp_send_failed) +
> +								  SMALL_MAXSEG,
> +					    SCTP_SEND_FAILED, 0);
> +		ssf = (struct sctp_send_failed *)iov.iov_base;
> +		if (0 != strncmp(&ttlfrag[offset], (char *)ssf->ssf_data,
> +				 SMALL_MAXSEG))
> +			tst_brkm(TBROK, tst_exit, "SEND_FAILED data mismatch");
> +		offset += SMALL_MAXSEG;
> +	} while (!(ssf->ssf_info.sinfo_flags & 0x01)); /* LAST_FRAG */
> +
> +	tst_resm(TPASS, "Receive SEND_FAILED for fragmented message with "
> +		 "timeout");
> +
> +        /* Shut down the link.  */
> +        close(sk1);
> +
> +        /* Get the shutdown complete notification. */
> +	inmessage.msg_controllen = sizeof(incmsg);
> +        error = test_recvmsg(sk2, &inmessage, MSG_WAITALL);
> +	test_check_msg_notification(&inmessage, error,
> +				    sizeof(struct sctp_assoc_change),
> +				    SCTP_ASSOC_CHANGE, SCTP_SHUTDOWN_COMP);
> +
> +        close(sk2);
> +
> +        /* Indicate successful completion.  */
> +        return 0;
> +}
> diff --git a/src/func_tests/test_sctp_sendrecvmsg.c b/src/func_tests/test_sctp_sendrecvmsg.c
> index c275e45..aaa56e9 100644
> --- a/src/func_tests/test_sctp_sendrecvmsg.c
> +++ b/src/func_tests/test_sctp_sendrecvmsg.c
> @@ -243,7 +243,7 @@ int main(int argc, char *argv[])
>  	/* Now send a message that will timeout. */
>  	test_sctp_sendmsg(sk1, ttlmsg, strlen(ttlmsg) + 1,
>  			  (struct sockaddr *)&loop2, sizeof(loop2),
> -			  ppid, 0, stream, 2000, 0);
> +			  ppid, SCTP_PR_SCTP_TTL, stream, 2000, 0);
>  
>  	tst_resm(TPASS, "sctp_sendmsg with ttl");
>  
> @@ -259,7 +259,7 @@ int main(int argc, char *argv[])
>  	ttlfrag[sizeof(ttlfrag)-1] = '\0';
>  	test_sctp_sendmsg(sk1, ttlfrag, sizeof(ttlfrag),
>  			  (struct sockaddr *)&loop2, sizeof(loop2),
> -			  ppid, 0, stream, 2000, 0);
> +			  ppid, SCTP_PR_SCTP_TTL, stream, 2000, 0);
>  
>  	tst_resm(TPASS, "sctp_sendmsg fragmented msg with ttl");
>  
> @@ -335,7 +335,8 @@ int main(int argc, char *argv[])
>  	snd_sinfo.sinfo_ppid = rand();
>  	snd_sinfo.sinfo_flags = 0; 
>  	snd_sinfo.sinfo_stream = 2; 
> -	snd_sinfo.sinfo_timetolive = 0; 
> +	snd_sinfo.sinfo_pr_policy = SCTP_PR_SCTP_NONE; 
> +	snd_sinfo.sinfo_pr_value = 0; 
>  	snd_sinfo.sinfo_assoc_id = associd1; 
>  	test_sctp_send(sk1, message, strlen(message) + 1, &snd_sinfo,
>  		       MSG_NOSIGNAL);
> diff --git a/src/func_tests/test_timetolive.c b/src/func_tests/test_timetolive.c
> index d9bdf1b..dc66722 100644
> --- a/src/func_tests/test_timetolive.c
> +++ b/src/func_tests/test_timetolive.c
> @@ -39,14 +39,14 @@
>  
>  /*
>   * This is a basic functional test for the SCTP kernel 
> - * implementation of sndrcvinfo.sinfo_timetolive.
> + * implementation of sndrcvinfo.sinfo_pr_value.
>   *
>   * 1) Create two sockets, the listening socket sets its RECVBUF small
>   * 2) Create a connection.  Send enough data to the non-reading listener
>   * to fill the RCVBUF.
> - * 5) Set sinfo_timetolive on a message and send.
> - * 6) Disable sinfo_timetolive on a message and send.
> - * 7) Wait sinfo_timetolive.
> + * 5) Set sinfo_pr_value with SCTP_PR_SCTP_TTL policy on a message and send.
> + * 6) Disable sinfo_pr_value on a message and send.
> + * 7) Wait sinfo_pr_value time.
>   * 8) Read out all the data at the receiver.
>   * 9) Make sure timed out message did not make it.
>   * 10) Make sure that the message with no timeout makes it to the receiver.
> @@ -288,7 +288,8 @@ int main(int argc, char *argv[])
>  	outmessage.msg_name = NULL;
>  	outmessage.msg_namelen = 0;
>  	sinfo->sinfo_assoc_id = associd1;
> -	sinfo->sinfo_timetolive = 0;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
> +	sinfo->sinfo_pr_value = 0;
>  	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL,
>  			 gstatus.sstat_rwnd+RWND_SLOP);
>  
> @@ -300,7 +301,8 @@ int main(int argc, char *argv[])
>  	outmessage.msg_name = NULL;
>  	outmessage.msg_namelen = 0;
>  	sinfo->sinfo_assoc_id = associd1;
> -	sinfo->sinfo_timetolive = 2000;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_TTL;
> +	sinfo->sinfo_pr_value = 2000;
>  	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(ttlmsg) + 1);
>  
>  	tst_resm(TPASS, "Send a message with timeout");
> @@ -313,7 +315,8 @@ int main(int argc, char *argv[])
>  	outmessage.msg_name = NULL;
>  	outmessage.msg_namelen = 0;
>  	sinfo->sinfo_assoc_id = associd1;
> -	sinfo->sinfo_timetolive = 0;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
> +	sinfo->sinfo_pr_value = 0;
>  	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(nottlmsg)+1);
>  
>  	tst_resm(TPASS, "Send a message with no timeout");
> @@ -328,7 +331,8 @@ int main(int argc, char *argv[])
>  	outmessage.msg_name = NULL;
>  	outmessage.msg_namelen = 0;
>  	sinfo->sinfo_assoc_id = associd1;
> -	sinfo->sinfo_timetolive = 2000;
> +	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_TTL;
> +	sinfo->sinfo_pr_value = 2000;
>  	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, sizeof(ttlfrag));
>  
>  	tst_resm(TPASS, "Send a fragmented message with timeout");
> diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h
> index ae557a5..5a6cea2 100644
> --- a/src/include/netinet/sctp.h
> +++ b/src/include/netinet/sctp.h
> @@ -184,9 +184,10 @@ struct sctp_sndrcvinfo {
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
> @@ -200,12 +201,25 @@ struct sctp_sndrcvinfo {
>   */
>  
>  enum sctp_sinfo_flags {
> -	SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
> -	SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
> -	SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
> -	SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
> +	SCTP_EOF       = MSG_FIN,    /* Initiate graceful shutdown process. */
> +	SCTP_UNORDERED = 0x0400,     /* Send/receive message unordered. */
> +	SCTP_ADDR_OVER = 0x0800,     /* Override the primary destination. */
> +	SCTP_ABORT     = 0x1000,     /* Send an ABORT message to the peer. */
>  };
>  
> +/*
> + *  sinfo_pr_policy: 16 bits (unsigned integer)
> + *
> + *   This field may contain the partial reliability used to
> + *   send the message.
> + */
> +
> +enum sctp_sinfo_pr_policy {
> +	SCTP_PR_SCTP_NONE = 0x0000,  /* Reliable transmission */
> +	SCTP_PR_SCTP_TTL  = 0x0001,  /* Timed partial reliable */
> +	SCTP_PR_SCTP_BUF  = 0x0002,  /* Buffer parital reliable */
> +	SCTP_PR_SCTP_RTX  = 0x0003,  /* Retransmist partial reliable */
> +};
>  
>  typedef union {
>  	__u8   			raw;
> @@ -816,7 +830,7 @@ int sctp_freeladdrs(struct sockaddr *addrs);
>   */
>  int sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
>  		 socklen_t tolen, uint32_t ppid, uint32_t flags,
> -		 uint16_t stream_no, uint32_t timetolive, uint32_t context);
> +		 uint16_t stream_no, uint32_t pr_value, uint32_t context);
>  
>  /* This library function assist the user with sending a message without
>   * dealing directly with the CMSG header.
> diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
> index 1de592d..a674646 100644
> --- a/src/lib/sendmsg.c
> +++ b/src/lib/sendmsg.c
> @@ -31,7 +31,7 @@
>  int
>  sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
>  	     socklen_t tolen, uint32_t ppid, uint32_t flags,
> -	     uint16_t stream_no, uint32_t timetolive, uint32_t context)
> +	     uint16_t stream_no, uint32_t pr_value, uint32_t context)
>  {
>  	struct msghdr outmsg;
>  	struct iovec iov;
> @@ -61,9 +61,22 @@ sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
>  	sinfo->sinfo_ppid = ppid;
>  	sinfo->sinfo_flags = flags;
>  	sinfo->sinfo_stream = stream_no;
> -	sinfo->sinfo_timetolive = timetolive;
>  	sinfo->sinfo_context = context;
>  
> +	sinfo->sinfo_pr_policy = sinfo->sinfo_flags & 0xff;
> +	sinfo->sinfo_pr_value = pr_value;
> +
> +	printf("sinfo_flags: %x   sinfo_pr_policy: %d  sinfo_pr_value: %d\n",
> +             sinfo->sinfo_flags, sinfo->sinfo_pr_policy, sinfo->sinfo_pr_value); 
> +
> +	/* If we get an invalid sinfo_pr_policy force it to
> +         * SCTP_PR_SCTP_NONE or shall we better fail and set a
> +         * EINVAL error??
> +         */
> +  
> +    	if(sinfo->sinfo_pr_policy > SCTP_PR_SCTP_RTX)	
> +            sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
> +
>  	return sendmsg(s, &outmsg, 0);
>  }
>  
> diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
> index 347c91b..0afbc36 100644
> --- a/src/testlib/sctputil.h
> +++ b/src/testlib/sctputil.h
> @@ -270,11 +270,11 @@ static inline int test_sctp_peeloff(int sk, sctp_assoc_t assoc_id)
>  static inline int test_sctp_sendmsg(int s, const void *msg, size_t len,
>  				    struct sockaddr *to, socklen_t tolen,
>  				    uint32_t ppid, uint32_t flags,
> -				    uint16_t stream_no, uint32_t timetolive,
> +				    uint16_t stream_no, uint32_t pr_value,
>  				    uint32_t context)
>  {
>  	int error = sctp_sendmsg(s, msg, len, to, tolen, ppid, flags, stream_no,
> -	  		         timetolive, context);
> +	  		         pr_value, context);
>  	if (len != error)
>  		tst_brkm(TBROK, tst_exit, "sctp_sendmsg: error:%d errno:%d",
>  			 error, errno);

