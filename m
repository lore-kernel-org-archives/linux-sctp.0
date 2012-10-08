From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 08 Oct 2012 12:38:43 +0000
Subject: Re: [PATCH] net: sctp: Fix typo in socket.c
Message-Id: <5072C953.9080207@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Masanari Iida <standby24x7@gmail.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/05/2012 10:50 AM, Masanari Iida wrote:
> Correct spelling typo in net/sctp/socket.c
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/socket.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index d37d24f..aaeff63 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -973,7 +973,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
>   	void *addr_buf;
>   	struct sctp_af *af;
>
> -	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
> +	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
>   			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
>
>   	if (unlikely(addrs_size <= 0))
>

