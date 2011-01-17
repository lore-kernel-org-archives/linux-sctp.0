From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 17 Jan 2011 02:07:22 +0000
Subject: Re: [PATCH 2/2] sctp: Remove store to ret as it is not used
Message-Id: <4D33A45A.2080109@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1294657090-2789-3-git-send-email-holger@freyther.de>
In-Reply-To: <1294657090-2789-3-git-send-email-holger@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> From: Holger Hans Peter Freyther <zecke@selfish.org>
>
> The store to ret is not needed. In case it is 0 the method
> will be exited directly, if not ret will be assigned again
> and then returned to the caller.
>
> Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
> ---
>  net/sctp/socket.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index e47e39e..b8dad82 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -393,7 +393,7 @@ SCTP_STATIC int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>  	 * detection.
>  	 */
>  	addr->v4.sin_port = htons(snum);
> -	if ((ret = sctp_get_port_local(sk, addr))) {
> +	if (sctp_get_port_local(sk, addr)) {
>  		return -EADDRINUSE;
>  	}

shoud be change to:

-	if ((ret = sctp_get_port_local(sk, addr))) {
+	if (sctp_get_port_local(sk, addr))
  		return -EADDRINUSE;
-  	}

{} is not need.

Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>

You may need fix your patch and cc to David Miller <davem@davemloft.net>
with my ACK.


>  
