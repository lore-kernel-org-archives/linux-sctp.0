From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 01 Mar 2018 18:09:19 +0000
Subject: Re: [PATCH net-next 0/9] sctp: clean up sctp_sendmsg
Message-Id: <20180301180919.GA11450@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Thu, Mar 01, 2018 at 11:05:09PM +0800, Xin Long wrote:
> This cleanup mostly does three things:
> 
>  - extract some codes into functions to make sendmsg more readable.
> 
>  - tidy up some codes to avoid the unnecessary checks.
> 
>  - adjust some logic so that it will be easier to add the send flags
>    and cmsgs features that I will post after this.
> 
> To make it easy to review and to check if the code is compatible with
> before, this patchset is to do it step by step in 9 patches.
> 
> NOTE:
> There will be a conflict when merging
> Commit 2277c7cd75e3 ("sctp: Add LSM hooks") from selinux tree,
> the solution is to:
> 
> 1. remove all the lines in [B]:
> 
>     <<<<<<< HEAD
>     [A]
>     ===>     [B]
>     >>>>>>> 2277c7c... sctp: Add LSM hooks
> 
> 2. and apply the following diff-output:
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 980621e..d6803c8 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1686,6 +1686,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
>  	struct net *net = sock_net(sk);
>  	struct sctp_association *asoc;
>  	enum sctp_scope scope;
> +	struct sctp_af *af;
>  	int err = -EINVAL;
> 
>  	*tp = NULL;
> @@ -1711,6 +1712,22 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
> 
>  	scope = sctp_scope(daddr);
> 
> +	/* Label connection socket for first association 1-to-many
> +	 * style for client sequence socket()->sendmsg(). This
> +	 * needs to be done before sctp_assoc_add_peer() as that will
> +	 * set up the initial packet that needs to account for any
> +	 * security ip options (CIPSO/CALIPSO) added to the packet.
> +	 */
> +	af = sctp_get_af_specific(daddr->sa.sa_family);
> +	if (!af)
> +		return -EINVAL;
> +
> +	err = security_sctp_bind_connect(sk, SCTP_SENDMSG_CONNECT,
> +					 (struct sockaddr *)daddr,
> +					 af->sockaddr_len);
> +	if (err < 0)
> +		return err;
> +
>  	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
>  	if (!asoc)
>  		return -ENOMEM;
> 
> Xin Long (9):
>   sctp: factor out sctp_sendmsg_to_asoc from sctp_sendmsg
>   sctp: factor out sctp_sendmsg_new_asoc from sctp_sendmsg
>   sctp: factor out sctp_sendmsg_check_sflags from sctp_sendmsg
>   sctp: factor out sctp_sendmsg_get_daddr from sctp_sendmsg
>   sctp: factor out sctp_sendmsg_parse from sctp_sendmsg
>   sctp: factor out sctp_sendmsg_update_sinfo from sctp_sendmsg
>   sctp: remove the unnecessary transport looking up from sctp_sendmsg
>   sctp: improve some variables in sctp_sendmsg
>   sctp: adjust some codes in a better order in sctp_sendmsg
> 
>  net/sctp/socket.c | 638 +++++++++++++++++++++++-------------------------------
>  1 file changed, 274 insertions(+), 364 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

