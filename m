From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 02 Jun 2010 21:37:01 +0000
Subject: Re: [RFC PATCH v3] sctp: fix the sendmsg() flag SCTP_EOF to comply
Message-Id: <4C06CEFD.9060101@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C05C996.5060708@cn.fujitsu.com>
In-Reply-To: <4C05C996.5060708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Wei Yongjun wrote:
> It should be possible to send a message and set the SCTP_EOF flag
> at the same time, but we don't support it yet. This patch fix the
> sendmsg() flag SCTP_EOF to comply to spec.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
> V2 -> V3:
>   - return -EWOULDBLOCK in non-blocking limitation case
>   - allow SCTP_EOF in CLOSED state
> ---
>  net/sctp/socket.c |   39 +++++++++++++++++++++++++++++++--------
>  1 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 0af3a8c..fcd8128 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1555,13 +1555,11 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  		goto out_nounlock;
>  	}
>  
> -	/* If SCTP_EOF is set, no data can be sent. Disallow sending zero
> -	 * length messages when SCTP_EOF|SCTP_ABORT is not set.
> -	 * If SCTP_ABORT is set, the message length could be non zero with
> -	 * the msg_iov set to the user abort reason.
> +	/* Disallow sending zero length messages when SCTP_EOF|SCTP_ABORT
> +	 * is not set. If SCTP_ABORT is set, the message length could be
> +	 * non zero with the msg_iov set to the user abort reason.
>  	 */
> -	if (((sinfo_flags & SCTP_EOF) && (msg_len > 0)) ||
> -	    (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0))) {
> +	if (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0)) {
>  		err = -EINVAL;
>  		goto out_nounlock;
>  	}
> @@ -1618,13 +1616,24 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  			goto out_unlock;
>  		}
>  
> -		if (sinfo_flags & SCTP_EOF) {
> +		/* Forbid SCTP_EOF and send a message combination
> +		 * on non-blocking sockets.
> +		 */
> +		if ((sinfo_flags & SCTP_EOF) && msg_len != 0 &&
> +		    sk->sk_socket->file &&
> +		    (sk->sk_socket->file->f_flags & O_NONBLOCK)) {
> +			err = -EWOULDBLOCK;
> +			goto out_nounlock;
> +		}
> +
> +		if (sinfo_flags & SCTP_EOF && msg_len = 0) {
>  			SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
>  					  asoc);
>  			sctp_primitive_SHUTDOWN(asoc, NULL);
>  			err = 0;
>  			goto out_unlock;
>  		}
> +
>  		if (sinfo_flags & SCTP_ABORT) {
>  
>  			chunk = sctp_make_abort_user(asoc, msg, msg_len);
> @@ -1644,7 +1653,7 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	if (!asoc) {
>  		SCTP_DEBUG_PRINTK("There is no association yet.\n");
>  
> -		if (sinfo_flags & (SCTP_EOF | SCTP_ABORT)) {
> +		if (sinfo_flags & SCTP_ABORT) {
>  			err = -EINVAL;
>  			goto out_unlock;
>  		}
> @@ -1850,6 +1859,20 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	else
>  		err = msg_len;
>  
> +	if (sinfo_flags & SCTP_EOF) {
> +		if (sctp_state(asoc, ESTABLISHED)) {
> +			SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
> +					  asoc);
> +			sctp_primitive_SHUTDOWN(asoc, NULL);
> +		} else {
> +			/* Delay to shutdown association until assoc enter
> +			 * ESTABLISHED state
> +			 */
> +			asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] = HZ/20;
> +			asoc->autoclose = 1;
> +		}
> +	}
> +

Interesting approach and I applaud for creativity, but it doesn't work if there is
data loss.

I see only one way out of this mess and that's to remove the SHUTDOWN_PENDING
state and make that a modifier/flag that can be set on other states <= ESTABLISHED.

In other words, if the user has queued up data to the association, even if it is
not established, we should exhaust all retransmits before failing.

-vlad

>  	/* If we are already past ASSOCIATE, the lower
>  	 * layers are responsible for association cleanup.
>  	 */
