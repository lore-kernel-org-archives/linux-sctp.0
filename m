From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 29 Jan 2017 19:27:36 +0000
Subject: Re: [PATCHv2 RFC net-next 4/7] tcp: replace dst_confirm with sk_dst_confirm
Message-Id: <1485718056.6360.93.camel@edumazet-glaptop3.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1485613578-19973-1-git-send-email-ja@ssi.bg>
         <1485613578-19973-5-git-send-email-ja@ssi.bg>
In-Reply-To: <1485613578-19973-5-git-send-email-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

On Sat, 2017-01-28 at 16:26 +0200, Julian Anastasov wrote:
> When same struct dst_entry can be used for many different
> neighbours we can not use it for pending confirmations.
> Use the new sk_dst_confirm() helper to propagate the
> indication from received packets to sock_confirm_neigh().
> 
> Reported-by: YueHaibing <yuehaibing@huawei.com>
> Fixes: 5110effee8fd ("net: Do delayed neigh confirmation.")
> Fixes: f2bb4bedf35d ("ipv4: Cache output routes in fib_info nexthops.")
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---

For the whole series,

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !

