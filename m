From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 Nov 2016 10:32:40 +0000
Subject: Re: [PATCH net] sctp: change sk state only when it has assocs in sctp_shutdown
Message-Id: <20161114103240.GA24936@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <d260f8b59f52d7ef00b83a554fc19d4aa91766a2.1479044677.git.lucien.xin@gmail.com>
In-Reply-To: <d260f8b59f52d7ef00b83a554fc19d4aa91766a2.1479044677.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, andreyknvl@google.com

On Sun, Nov 13, 2016 at 09:44:37PM +0800, Xin Long wrote:
> Now when users shutdown a sock with SEND_SHUTDOWN in sctp, even if
> this sock has no connection (assoc), sk state would be changed to
> SCTP_SS_CLOSING, which is not as we expect.
> 
> Besides, after that if users try to listen on this sock, kernel
> could even panic when it dereference sctp_sk(sk)->bind_hash in
> sctp_inet_listen, as bind_hash is null when sock has no assoc.
> 
> This patch is to move sk state change after checking sk assocs
> is not empty, and also merge these two if() conditions and reduce
> indent level.
> 
> Fixes: d46e416c11c8 ("sctp: sctp should change socket state when shutdown is received")
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index faa48ff..f23ad91 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4285,19 +4285,18 @@ static void sctp_shutdown(struct sock *sk, int how)
>  {
>  	struct net *net = sock_net(sk);
>  	struct sctp_endpoint *ep;
> -	struct sctp_association *asoc;
>  
>  	if (!sctp_style(sk, TCP))
>  		return;
>  
> -	if (how & SEND_SHUTDOWN) {
> +	ep = sctp_sk(sk)->ep;
> +	if (how & SEND_SHUTDOWN && !list_empty(&ep->asocs)) {
> +		struct sctp_association *asoc;
> +
>  		sk->sk_state = SCTP_SS_CLOSING;
> -		ep = sctp_sk(sk)->ep;
> -		if (!list_empty(&ep->asocs)) {
> -			asoc = list_entry(ep->asocs.next,
> -					  struct sctp_association, asocs);
> -			sctp_primitive_SHUTDOWN(net, asoc, NULL);
> -		}
> +		asoc = list_entry(ep->asocs.next,
> +				  struct sctp_association, asocs);
> +		sctp_primitive_SHUTDOWN(net, asoc, NULL);
>  	}
>  }
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
