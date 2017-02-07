From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 07 Feb 2017 12:58:55 +0000
Subject: Re: [PATCH net] sctp: check af before verify address in sctp_addr_id2transport
Message-Id: <20170207125855.GB3414@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <d4c232a9f69f9eae6537f74078dc0d2a0574e8eb.1486472168.git.lucien.xin@gmail.com>
In-Reply-To: <d4c232a9f69f9eae6537f74078dc0d2a0574e8eb.1486472168.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On Tue, Feb 07, 2017 at 08:56:08PM +0800, Xin Long wrote:
> Commit 6f29a1306131 ("sctp: sctp_addr_id2transport should verify the
> addr before looking up assoc") invoked sctp_verify_addr to verify the
> addr.
> 
> But it didn't check af variable beforehand, once users pass an address
> with family = 0 through sockopt, sctp_get_af_specific will return NULL
> and NULL pointer dereference will be caused by af->sockaddr_len.
> 
> This patch is to fix it by returning NULL if af variable is NULL.
> 
> Fixes: 6f29a1306131 ("sctp: sctp_addr_id2transport should verify the addr before looking up assoc")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 37eeab7..f354375 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -239,7 +239,7 @@ static struct sctp_transport *sctp_addr_id2transport(struct sock *sk,
>  	union sctp_addr *laddr = (union sctp_addr *)addr;
>  	struct sctp_transport *transport;
>  
> -	if (sctp_verify_addr(sk, laddr, af->sockaddr_len))
> +	if (!af || sctp_verify_addr(sk, laddr, af->sockaddr_len))
>  		return NULL;
>  
>  	addr_asoc = sctp_endpoint_lookup_assoc(sctp_sk(sk)->ep,
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
