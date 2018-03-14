From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Mar 2018 13:53:13 +0000
Subject: Re: [PATCH net-next 3/5] sctp: add sockopt SCTP_AUTH_DEACTIVATE_KEY
Message-Id: <20180314135313.GX27351@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
 <e958480a6da52ad0947e319a2890fb034a473570.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <e958480a6da52ad0947e319a2890fb034a473570.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Wed, Mar 14, 2018 at 07:05:32PM +0800, Xin Long wrote:
> This patch is to add sockopt SCTP_AUTH_DEACTIVATE_KEY, as described in
> section 8.3.4 of RFC6458.
> 
> This set option indicates that the application will no longer send user
> messages using the indicated key identifier.
> 
> Note that RFC requires that only deactivated keys that are no longer used
> by an association can be deleted, but for the backward compatibility, it
> is not to check deactivated when deleting or replacing one sh_key.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/auth.h   | 12 ++++++------
>  include/uapi/linux/sctp.h |  1 +
>  net/sctp/auth.c           | 46 +++++++++++++++++++++++++++++++++++++++++++---
>  net/sctp/socket.c         | 31 +++++++++++++++++++++++++++++++
>  4 files changed, 81 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
> index 017c1aa..687e7f8 100644
> --- a/include/net/sctp/auth.h
> +++ b/include/net/sctp/auth.h
> @@ -65,6 +65,7 @@ struct sctp_shared_key {
>  	struct sctp_auth_bytes *key;
>  	refcount_t refcnt;
>  	__u16 key_id;
> +	__u8 deactivated;
>  };
>  
>  #define key_for_each(__key, __list_head) \
> @@ -113,14 +114,13 @@ void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
>  int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id);
>  int sctp_auth_ep_set_hmacs(struct sctp_endpoint *ep,
>  			    struct sctp_hmacalgo *hmacs);
> -int sctp_auth_set_key(struct sctp_endpoint *ep,
> -		      struct sctp_association *asoc,
> +int sctp_auth_set_key(struct sctp_endpoint *ep, struct sctp_association *asoc,
>  		      struct sctp_authkey *auth_key);
>  int sctp_auth_set_active_key(struct sctp_endpoint *ep,
> -		      struct sctp_association *asoc,
> -		      __u16 key_id);
> +			     struct sctp_association *asoc, __u16 key_id);
>  int sctp_auth_del_key_id(struct sctp_endpoint *ep,
> -		      struct sctp_association *asoc,
> -		      __u16 key_id);
> +			 struct sctp_association *asoc, __u16 key_id);
> +int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
> +			   struct sctp_association *asoc, __u16 key_id);
>  
>  #endif
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index 47e781e..08fc313 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -99,6 +99,7 @@ typedef __s32 sctp_assoc_t;
>  #define SCTP_RECVRCVINFO	32
>  #define SCTP_RECVNXTINFO	33
>  #define SCTP_DEFAULT_SNDINFO	34
> +#define SCTP_AUTH_DEACTIVATE_KEY	35
>  
>  /* Internal Socket Options. Some of the sctp library functions are
>   * implemented using these socket options.
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index e5214fd..a073123 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -449,8 +449,11 @@ struct sctp_shared_key *sctp_auth_get_shkey(
>  
>  	/* First search associations set of endpoint pair shared keys */
>  	key_for_each(key, &asoc->endpoint_shared_keys) {
> -		if (key->key_id = key_id)
> -			return key;
> +		if (key->key_id = key_id) {
> +			if (!key->deactivated)
> +				return key;
> +			break;
> +		}
>  	}
>  
>  	return NULL;
> @@ -905,7 +908,7 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
>  		}
>  	}
>  
> -	if (!found)
> +	if (!found || key->deactivated)
>  		return -EINVAL;
>  
>  	if (asoc) {
> @@ -956,3 +959,40 @@ int sctp_auth_del_key_id(struct sctp_endpoint *ep,
>  
>  	return 0;
>  }
> +
> +int sctp_auth_deact_key_id(struct sctp_endpoint *ep,
> +			   struct sctp_association *asoc, __u16  key_id)
> +{
> +	struct sctp_shared_key *key;
> +	struct list_head *sh_keys;
> +	int found = 0;
> +
> +	/* The key identifier MUST NOT be the current active key
> +	 * The key identifier MUST correst to an existing key
> +	 */
> +	if (asoc) {
> +		if (asoc->active_key_id = key_id)
> +			return -EINVAL;
> +
> +		sh_keys = &asoc->endpoint_shared_keys;
> +	} else {
> +		if (ep->active_key_id = key_id)
> +			return -EINVAL;
> +
> +		sh_keys = &ep->endpoint_shared_keys;
> +	}
> +
> +	key_for_each(key, sh_keys) {
> +		if (key->key_id = key_id) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		return -EINVAL;
> +
> +	key->deactivated = 1;
> +
> +	return 0;
> +}
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9ffdecb..65cc354 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3647,6 +3647,33 @@ static int sctp_setsockopt_del_key(struct sock *sk,
>  }
>  
>  /*
> + * 8.3.4  Deactivate a Shared Key (SCTP_AUTH_DEACTIVATE_KEY)
> + *
> + * This set option will deactivate a shared secret key.
> + */
> +static int sctp_setsockopt_deactivate_key(struct sock *sk, char __user *optval,
> +					  unsigned int optlen)
> +{
> +	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
> +	struct sctp_authkeyid val;
> +	struct sctp_association *asoc;
> +
> +	if (!ep->auth_enable)
> +		return -EACCES;
> +
> +	if (optlen != sizeof(struct sctp_authkeyid))
> +		return -EINVAL;
> +	if (copy_from_user(&val, optval, optlen))
> +		return -EFAULT;
> +
> +	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
> +	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
> +		return -EINVAL;
> +
> +	return sctp_auth_deact_key_id(ep, asoc, val.scact_keynumber);
> +}
> +
> +/*
>   * 8.1.23 SCTP_AUTO_ASCONF
>   *
>   * This option will enable or disable the use of the automatic generation of
> @@ -4238,6 +4265,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
>  	case SCTP_AUTH_DELETE_KEY:
>  		retval = sctp_setsockopt_del_key(sk, optval, optlen);
>  		break;
> +	case SCTP_AUTH_DEACTIVATE_KEY:
> +		retval = sctp_setsockopt_deactivate_key(sk, optval, optlen);
> +		break;
>  	case SCTP_AUTO_ASCONF:
>  		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
>  		break;
> @@ -7212,6 +7242,7 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
>  	case SCTP_AUTH_KEY:
>  	case SCTP_AUTH_CHUNK:
>  	case SCTP_AUTH_DELETE_KEY:
> +	case SCTP_AUTH_DEACTIVATE_KEY:
>  		retval = -EOPNOTSUPP;
>  		break;
>  	case SCTP_HMAC_IDENT:
> -- 
> 2.1.0
> 
