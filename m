From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 06 Mar 2018 12:22:36 +0000
Subject: Re: [PATCH net-next 3/3] sctp: add support for snd flag SCTP_SENDALL process in sendmsg
Message-Id: <20180306122236.GF27351@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1520253539.git.lucien.xin@gmail.com>
 <5abf7d1eafab86acebcfab55f2cf4a081f5b1088.1520253539.git.lucien.xin@gmail.com>
In-Reply-To: <5abf7d1eafab86acebcfab55f2cf4a081f5b1088.1520253539.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Mon, Mar 05, 2018 at 08:44:20PM +0800, Xin Long wrote:
> This patch is to add support for snd flag SCTP_SENDALL process
> in sendmsg, as described in section 5.3.4 of RFC6458.
> 
> With this flag, you can send the same data to all the asocs of
> this sk once.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/uapi/linux/sctp.h |  2 ++
>  net/sctp/socket.c         | 35 +++++++++++++++++++++++++++++++----
>  2 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index a1bc350..e94b6d2 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -284,6 +284,8 @@ enum sctp_sinfo_flags {
>  	SCTP_ADDR_OVER		= (1 << 1), /* Override the primary destination. */
>  	SCTP_ABORT		= (1 << 2), /* Send an ABORT message to the peer. */
>  	SCTP_SACK_IMMEDIATELY	= (1 << 3), /* SACK should be sent without delay. */
> +	/* 2 bits here have been used by SCTP_PR_SCTP_MASK */
> +	SCTP_SENDALL		= (1 << 6),
>  	SCTP_NOTIFICATION	= MSG_NOTIFICATION, /* Next message is not user msg but notification. */
>  	SCTP_EOF		= MSG_FIN,  /* Initiate graceful shutdown process. */
>  };
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 067b57a..7d3476a 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1820,6 +1820,10 @@ static int sctp_sendmsg_check_sflags(struct sctp_association *asoc,
>  	if (sctp_state(asoc, CLOSED) && sctp_style(sk, TCP))
>  		return -EPIPE;
>  
> +	if ((sflags & SCTP_SENDALL) && sctp_style(sk, UDP) &&
> +	    !sctp_state(asoc, ESTABLISHED))
> +		return 0;
> +
>  	if (sflags & SCTP_EOF) {
>  		pr_debug("%s: shutting down association:%p\n", __func__, asoc);
>  		sctp_primitive_SHUTDOWN(net, asoc, NULL);
> @@ -2007,6 +2011,29 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
>  
>  	lock_sock(sk);
>  
> +	/* SCTP_SENDALL process */
> +	if ((sflags & SCTP_SENDALL) && sctp_style(sk, UDP)) {
> +		list_for_each_entry(asoc, &ep->asocs, asocs) {
> +			err = sctp_sendmsg_check_sflags(asoc, sflags, msg,
> +							msg_len);
> +			if (err = 0)
> +				continue;
> +			if (err < 0)
> +				goto out_unlock;
> +
> +			sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
> +
> +			err = sctp_sendmsg_to_asoc(asoc, msg, msg_len,
> +						   NULL, sinfo);
> +			if (err < 0)
> +				goto out_unlock;
> +
> +			iov_iter_revert(&msg->msg_iter, err);
> +		}
> +
> +		goto out_unlock;
> +	}
> +
>  	/* Get and check or create asoc */
>  	if (daddr) {
>  		asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
> @@ -7792,8 +7819,8 @@ static int sctp_msghdr_parse(const struct msghdr *msg, struct sctp_cmsgs *cmsgs)
>  
>  			if (cmsgs->srinfo->sinfo_flags &
>  			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> -			      SCTP_SACK_IMMEDIATELY | SCTP_PR_SCTP_MASK |
> -			      SCTP_ABORT | SCTP_EOF))
> +			      SCTP_SACK_IMMEDIATELY | SCTP_SENDALL |
> +			      SCTP_PR_SCTP_MASK | SCTP_ABORT | SCTP_EOF))
>  				return -EINVAL;
>  			break;
>  
> @@ -7816,8 +7843,8 @@ static int sctp_msghdr_parse(const struct msghdr *msg, struct sctp_cmsgs *cmsgs)
>  
>  			if (cmsgs->sinfo->snd_flags &
>  			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> -			      SCTP_SACK_IMMEDIATELY | SCTP_PR_SCTP_MASK |
> -			      SCTP_ABORT | SCTP_EOF))
> +			      SCTP_SACK_IMMEDIATELY | SCTP_SENDALL |
> +			      SCTP_PR_SCTP_MASK | SCTP_ABORT | SCTP_EOF))
>  				return -EINVAL;
>  			break;
>  		case SCTP_PRINFO:
> -- 
> 2.1.0
> 
