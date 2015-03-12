From: Danny Smit <danny.smit.0@gmail.com>
Date: Thu, 12 Mar 2015 11:00:04 +0000
Subject: Re: Memory issue with kernel sctp_connectx
Message-Id: <CACoz=-wt=s6ZqrP9pRuCOZjs2YJ_aAQEKHu96V_Ypy9TvV73pQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
In-Reply-To: <CACoz=-y7yC27C7_jopeJy=55J_Og9czP9fVY_xVE6Zmoo7apTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Mar 10, 2015 at 8:28 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>
> Can you try this patch.
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 2625ecc..14fc29d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2077,7 +2077,8 @@ static int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
>
>       lock_sock(sk);
>
> -     if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED)) {
> +     if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
> +         skb_queue_empty(&sk->sk_receive_queue)) {
>                 err = -ENOTCONN;
>                 goto out;
>       }


Thanks a lot, this patch seems to work! With this patch sctp_recvmsg()
results in a notification of type SCTP_CANT_STR_ASSOC and the memory
consumption does not increase anymore. Exactly as expected.

Just to be sure, in my previous implementation I didn't even call
sctp_recvmsg(), but repeatedly called sctp_connectx() until it
returned EISCON. We can now conclude that it is just incorrect usage
of the API? And therefore it is correct that with this specific
scenario the sk_recieve_queue keeps piling up (and consuming memory),
even though initialization of the connection fails immediately?
