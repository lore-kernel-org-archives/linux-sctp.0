From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 09 Oct 2019 15:27:46 +0000
Subject: Re: [PATCH net] sctp: add chunks to sk_backlog when the newsk sk_socket is not set
Message-Id: <20191009152746.GA25555@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
In-Reply-To: <d8dd0065232e5c3629bf55e54e3a998110ec1aef.1570532963.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, omosnace@redhat.com

On Tue, Oct 08, 2019 at 07:09:23PM +0800, Xin Long wrote:
> This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:
> 
>   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
>   [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
>   [...] Call Trace:
>   [...]  selinux_sctp_bind_connect+0x16a/0x1d0
>   [...]  security_sctp_bind_connect+0x58/0x90
>   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
>   [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
>   [...]  sctp_do_sm+0x175/0x5a0 [sctp]
>   [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
>   [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
>   [...]  __release_sock+0x11e/0x310
>   [...]  release_sock+0x4f/0x180
>   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
>   [...]  inet_accept+0xe7/0x720
> 
> It was caused by that the 'newsk' sk_socket was not set before going to
> security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
> or SCTP_PARAM_SET_PRIMARY:
> 
>   inet_accept()->
>     sctp_accept():
>       lock_sock():
>           lock listening 'sk'
>                                           do_softirq():
>                                             sctp_rcv():  <-- [1]
>                                                 asconf chunk arrives and
>                                                 enqueued in 'sk' backlog
>       sctp_sock_migrate():
>           set asoc's sk to 'newsk'
>       release_sock():
>           sctp_backlog_rcv():
>             lock 'newsk'
>             sctp_process_asconf()  <-- [2]
>             unlock 'newsk'
>     sock_graft():
>         set sk_socket  <-- [3]
> 
> As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> backlog, as accept() was holding its sock lock. Then at [2] asconf would
> get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> would deref it, then kernel crashed.
> 
> Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
> set when .accept() is done.
> 
> Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
> flag is also needed to check in sctp_newsk_ready().
> 
> Thanks to Ondrej for reviewing the code.
> 
> Fixes: d452930fd3b9 ("selinux: Add SCTP support")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/sctp.h |  5 +++++
>  net/sctp/input.c        | 12 +++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 5d60f13..3ab5c6b 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -610,4 +610,9 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
>  	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
>  }
>  
> +static inline bool sctp_newsk_ready(const struct sock *sk)
> +{
> +	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
> +}
> +
>  #endif /* __net_sctp_h__ */
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 5a070fb..f277137 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -243,7 +243,7 @@ int sctp_rcv(struct sk_buff *skb)
>  		bh_lock_sock(sk);
>  	}
>  
> -	if (sock_owned_by_user(sk)) {
> +	if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
>  		if (sctp_add_backlog(sk, skb)) {
>  			bh_unlock_sock(sk);
>  			sctp_chunk_free(chunk);
> @@ -321,7 +321,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
>  		local_bh_disable();
>  		bh_lock_sock(sk);
>  
> -		if (sock_owned_by_user(sk)) {
> +		if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
>  			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
>  				sctp_chunk_free(chunk);
>  			else
> @@ -336,7 +336,13 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
>  		if (backloged)
>  			return 0;
>  	} else {
> -		sctp_inq_push(inqueue, chunk);
> +		if (!sctp_newsk_ready(sk)) {
> +			if (!sk_add_backlog(sk, skb, sk->sk_rcvbuf))
> +				return 0;
> +			sctp_chunk_free(chunk);
> +		} else {
> +			sctp_inq_push(inqueue, chunk);
> +		}
>  	}
>  
>  done:
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
