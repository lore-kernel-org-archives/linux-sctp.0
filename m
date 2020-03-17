From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 17 Mar 2020 04:15:23 +0000
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200317041523.GB3756@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
In-Reply-To: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiujun Huang <hqjagain@gmail.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Mar 16, 2020 at 11:53:24AM +0800, Qiujun Huang wrote:
> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk.

This is a too simple description.  Please elaborate how this can
happen in sctp_wfree. Especially considering the construct for
migrating the tx queue on sctp_sock_migrate(), as both sockets are
locked while moving the chunks around and the asoc itself is only
moved in between decrementing and incrementing the refcount:

        lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
        sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
        sctp_assoc_migrate(assoc, newsk);
        sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
	...

> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

I can't see a positive test result, though. If I didn't loose any
email, your last test with a patch similar to this one actually
failed.
I'm talking about syzbot test result at Message-ID: <000000000000e7736205a0e041f5@google.com>

> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
>  net/sctp/socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 1b56fc4..5f5c28b 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
>  {
>  	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
>  	struct sctp_association *asoc = chunk->asoc;
> -	struct sock *sk = asoc->base.sk;
> +	struct sock *sk = skb->sk;
>  
>  	sk_mem_uncharge(sk, skb->truesize);
>  	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
> @@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
>  	}
>  
>  	sock_wfree(skb);
> -	sctp_wake_up_waiters(sk, asoc);
> +	sctp_wake_up_waiters(asoc->base.sk, asoc);
>  
>  	sctp_association_put(asoc);
>  }
> -- 
> 1.8.3.1
> 
