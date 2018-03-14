From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Mar 2018 13:53:09 +0000
Subject: Re: [PATCH net-next 2/5] sctp: add support for SCTP AUTH Information for sendmsg
Message-Id: <20180314135309.GW27351@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
 <68816b668678174bdd44abeef7ed63a8260268c2.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <68816b668678174bdd44abeef7ed63a8260268c2.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Wed, Mar 14, 2018 at 07:05:31PM +0800, Xin Long wrote:
> This patch is to add support for SCTP AUTH Information for sendmsg,
> as described in section 5.3.8 of RFC6458.
> 
> With this option, you can provide shared key identifier used for
> sending the user message.
> 
> It's also a necessary send info for sctp_sendv.
> 
> Note that it reuses sinfo->sinfo_tsn to indicate if this option is
> set and sinfo->sinfo_ssn to save the shkey ID which can be 0.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/structs.h |  1 +
>  include/uapi/linux/sctp.h  | 14 +++++++++++++-
>  net/sctp/chunk.c           | 11 ++++++++++-
>  net/sctp/socket.c          | 23 +++++++++++++++++++++++
>  4 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 49ad67b..012fb3e 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -2118,6 +2118,7 @@ struct sctp_cmsgs {
>  	struct sctp_sndrcvinfo *srinfo;
>  	struct sctp_sndinfo *sinfo;
>  	struct sctp_prinfo *prinfo;
> +	struct sctp_authinfo *authinfo;
>  	struct msghdr *addrs_msg;
>  };
>  
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index e94b6d2..47e781e 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -273,6 +273,18 @@ struct sctp_prinfo {
>  	__u32 pr_value;
>  };
>  
> +/* 5.3.8 SCTP AUTH Information Structure (SCTP_AUTHINFO)
> + *
> + *   This cmsghdr structure specifies SCTP options for sendmsg().
> + *
> + *   cmsg_level    cmsg_type      cmsg_data[]
> + *   ------------  ------------   -------------------
> + *   IPPROTO_SCTP  SCTP_AUTHINFO  struct sctp_authinfo
> + */
> +struct sctp_authinfo {
> +	__u16 auth_keynumber;
> +};
> +
>  /*
>   *  sinfo_flags: 16 bits (unsigned integer)
>   *
> @@ -310,7 +322,7 @@ typedef enum sctp_cmsg_type {
>  #define SCTP_NXTINFO	SCTP_NXTINFO
>  	SCTP_PRINFO,		/* 5.3.7 SCTP PR-SCTP Information Structure */
>  #define SCTP_PRINFO	SCTP_PRINFO
> -	SCTP_AUTHINFO,		/* 5.3.8 SCTP AUTH Information Structure (RESERVED) */
> +	SCTP_AUTHINFO,		/* 5.3.8 SCTP AUTH Information Structure */
>  #define SCTP_AUTHINFO	SCTP_AUTHINFO
>  	SCTP_DSTADDRV4,		/* 5.3.9 SCTP Destination IPv4 Address Structure */
>  #define SCTP_DSTADDRV4	SCTP_DSTADDRV4
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 9f28a9a..f889a84 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -206,7 +206,16 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  			max_data -= SCTP_PAD4(sizeof(struct sctp_auth_chunk) +
>  					      hmac_desc->hmac_len);
>  
> -		shkey = asoc->shkey;
> +		if (sinfo->sinfo_tsn &&
> +		    sinfo->sinfo_ssn != asoc->active_key_id) {
> +			shkey = sctp_auth_get_shkey(asoc, sinfo->sinfo_ssn);
> +			if (!shkey) {
> +				err = -EINVAL;
> +				goto errout;
> +			}
> +		} else {
> +			shkey = asoc->shkey;
> +		}
>  	}
>  
>  	/* Check what's our max considering the above */
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 003a4ad..9ffdecb 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1987,6 +1987,14 @@ static void sctp_sendmsg_update_sinfo(struct sctp_association *asoc,
>  
>  	if (!cmsgs->srinfo && !cmsgs->prinfo)
>  		sinfo->sinfo_timetolive = asoc->default_timetolive;
> +
> +	if (cmsgs->authinfo) {
> +		/* Reuse sinfo_tsn to indicate that authinfo was set and
> +		 * sinfo_ssn to save the keyid on tx path.
> +		 */
> +		sinfo->sinfo_tsn = 1;
> +		sinfo->sinfo_ssn = cmsgs->authinfo->auth_keynumber;
> +	}
>  }
>  
>  static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
> @@ -7874,6 +7882,21 @@ static int sctp_msghdr_parse(const struct msghdr *msg, struct sctp_cmsgs *cmsgs)
>  			if (cmsgs->prinfo->pr_policy = SCTP_PR_SCTP_NONE)
>  				cmsgs->prinfo->pr_value = 0;
>  			break;
> +		case SCTP_AUTHINFO:
> +			/* SCTP Socket API Extension
> +			 * 5.3.8 SCTP AUTH Information Structure (SCTP_AUTHINFO)
> +			 *
> +			 * This cmsghdr structure specifies SCTP options for sendmsg().
> +			 *
> +			 * cmsg_level    cmsg_type      cmsg_data[]
> +			 * ------------  ------------   ---------------------
> +			 * IPPROTO_SCTP  SCTP_AUTHINFO  struct sctp_authinfo
> +			 */
> +			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct sctp_authinfo)))
> +				return -EINVAL;
> +
> +			cmsgs->authinfo = CMSG_DATA(cmsg);
> +			break;
>  		case SCTP_DSTADDRV4:
>  		case SCTP_DSTADDRV6:
>  			/* SCTP Socket API Extension
> -- 
> 2.1.0
> 
