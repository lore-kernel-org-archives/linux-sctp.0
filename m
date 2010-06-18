From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 18 Jun 2010 18:33:39 +0000
Subject: Re: [PATCH v4] sctp: fix the sendmsg() flag SCTP_EOF to comply to
Message-Id: <4C1BBC03.4050502@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C087060.8030807@cn.fujitsu.com>
In-Reply-To: <4C087060.8030807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Wei

You got rid of the autoclose timer in the version and we went back
to not being able to send SCTP_EOF in closed state.

Additionally, now we need to check the eof_pending bit when
performing close(), since now it it's possible to send an EOF
and then call close() on the socket.  The close() could trigger
a state transition before the transmit happens.

Really, we need to remove the SHUTDOWN_PENDING from the state table.
I've almost got that working.  Once I do, I'll take your v1 patch
that didn't try to work around all these issues, as they would be
resolved.

-vlad

Wei Yongjun wrote:
> It should be possible to send a message and set the SCTP_EOF flag
> at the same time, but we don't support it yet. This patch fix the
> sendmsg() flag SCTP_EOF to comply to spec.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  include/net/sctp/structs.h |    3 ++-
>  net/sctp/socket.c          |   40 ++++++++++++++++++++++++++++++++--------
>  2 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 828185c..dc894e0 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1924,7 +1924,8 @@ struct sctp_association {
>  	__u16 active_key_id;
>  
>  	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
> -	     temp:1;		/* Is it a temporary association? */
> +	     temp:1,		/* Is it a temporary association? */
> +	     eof_pending:1;	/* SCTP_EOF flag is indicated in send() */
>  };
>  
>  
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 0af3a8c..44c1773 100644
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
> @@ -1608,6 +1606,12 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	if (asoc) {
>  		SCTP_DEBUG_PRINTK("Just looked up association: %p.\n", asoc);
>  
> +		/* Previous send() is called with SCTP_EOF flag */
> +		if (asoc->eof_pending) {
> +			err = -ESHUTDOWN;
> +			goto out_unlock;
> +		}
> +
>  		/* We cannot send a message on a TCP-style SCTP_SS_ESTABLISHED
>  		 * socket that has an association in CLOSED state. This can
>  		 * happen when an accepted socket has an association that is
> @@ -1618,13 +1622,24 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
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
> @@ -1644,7 +1659,7 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	if (!asoc) {
>  		SCTP_DEBUG_PRINTK("There is no association yet.\n");
>  
> -		if (sinfo_flags & (SCTP_EOF | SCTP_ABORT)) {
> +		if (sinfo_flags & SCTP_ABORT) {
>  			err = -EINVAL;
>  			goto out_unlock;
>  		}
> @@ -1850,6 +1865,15 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	else
>  		err = msg_len;
>  
> +	if (sinfo_flags & SCTP_EOF) {
> +		SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
> +				  asoc);
> +		if (sctp_state(asoc, ESTABLISHED))
> +			sctp_primitive_SHUTDOWN(asoc, NULL);
> +		else
> +			asoc->eof_pending = 1;
> +	}
> +
>  	/* If we are already past ASSOCIATE, the lower
>  	 * layers are responsible for association cleanup.
>  	 */
