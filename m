From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 04 Oct 2012 17:04:16 +0000
Subject: Re: [RFC PATCH 1/2] sctp: fix a typo in prototype of __sctp_rcv_lookup()
Message-Id: <506DC190.6050407@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1349279002-4008-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1349279002-4008-1-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 10/03/2012 11:43 AM, Nicolas Dichtel wrote:
> Just to avoid confusion when people only reads this prototype.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>   net/sctp/input.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 25dfe73..8bd3c27 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -68,8 +68,8 @@
>   static int sctp_rcv_ootb(struct sk_buff *);
>   static struct sctp_association *__sctp_rcv_lookup(struct net *net,
>   				      struct sk_buff *skb,
> -				      const union sctp_addr *laddr,
>   				      const union sctp_addr *paddr,
> +				      const union sctp_addr *laddr,
>   				      struct sctp_transport **transportp);
>   static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
>   						const union sctp_addr *laddr);
>

Wow,  this must have been very old...

Acked-by: Vlad Yasevich <vyasevich@gmail.com>
