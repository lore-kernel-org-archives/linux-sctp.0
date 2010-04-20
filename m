From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 20 Apr 2010 13:43:36 +0000
Subject: Re: [PATCH v2] sctp: fix the sendmsg() flag SCTP_EOF to comply to
Message-Id: <4BCDAF88.3080701@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BCC148C.20606@cn.fujitsu.com>
In-Reply-To: <4BCC148C.20606@cn.fujitsu.com>
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
> V1 -> V2:
>   - SCTP_EOF cannot be set in CLOSED state
>   - Forbid SCTP_EOF and send a message combination on non-blocking sockets

Hmm... I am going to have to think about this.  I was hoping to resolve
the CLOSED state issue.

For non-blocking limitation, we should probably return EWOULDBLOCK since
there is really no way we can do this if the app decides to run this
in a loop, especially if the decide to do to the same destination.

The thing that's standing in our way of fixing the CLOSED state is the
SHUTDOWN_PENDING state.  That's really not so much of a state as a modification
to any existing state that an association can be in.

I have a few ideas of how to solve that, but if you want to take a crack at
it, be my guest.

-vlad

> ---
>  net/sctp/socket.c |   36 ++++++++++++++++++++++++++++++------
>  1 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 007e8ba..783d865 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1551,13 +1551,11 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  		goto out_nounlock;
>  	}
>  
> -	/* If SCTP_EOF is set, no data can be sent. Disallow sending zero
> -	 * length messages when SCTP_EOF|SCTP_ABORT is not set.
> -	 * If SCTP_ABORT is set, the message length could be non zero with
> -	 * the msg_iov set to the user abort reason.
> +	/* Disallow sending zero length messages when SCTP_EOF|SCTP_ABORT
> +	 * is not set. If SCTP_ABORT is set, the message length could be non
> +	 * zero with the msg_iov set to the user abort reason.
>  	 */
> -	if (((sinfo_flags & SCTP_EOF) && (msg_len > 0)) ||
> -	    (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0))) {
> +	if (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0)) {
>  		err = -EINVAL;
>  		goto out_nounlock;
>  	}
> @@ -1615,6 +1613,26 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  		}
>  
>  		if (sinfo_flags & SCTP_EOF) {
> +			/* SCTP_EOF cannot be set on an association
> +			 * in CLOSED state.
> +			 */
> +			if (sctp_state(asoc, CLOSED)) {
> +				err = -EINVAL;
> +				goto out_nounlock;
> +			}
> +
> +			/*
> +			 * Forbid SCTP_EOF and send a message combination
> +			 * on non-blocking sockets.
> +			 */
> +			if (msg_len != 0 && sk->sk_socket->file &&
> +			    sk->sk_socket->file->f_flags & O_NONBLOCK) {
> +				err = -EINVAL;
> +				goto out_nounlock;
> +			}
> +		}
> +
> +		if (sinfo_flags & SCTP_EOF && msg_len = 0) {
>  			SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
>  					  asoc);
>  			sctp_primitive_SHUTDOWN(asoc, NULL);
> @@ -1846,6 +1864,12 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>  	else
>  		err = msg_len;
>  
> +	if (sinfo_flags & SCTP_EOF) {
> +		SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
> +				  asoc);
> +		sctp_primitive_SHUTDOWN(asoc, NULL);
> +	}
> +
>  	/* If we are already past ASSOCIATE, the lower
>  	 * layers are responsible for association cleanup.
>  	 */
