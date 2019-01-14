From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 Jan 2019 13:10:24 +0000
Subject: Re: [PATCH net] sctp: allocate sctp_sockaddr_entry with kzalloc
Message-Id: <20190114131023.GP23855@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <b1033e296052216772051e87ba5aa61bfc222076.1547462042.git.lucien.xin@gmail.com>
In-Reply-To: <b1033e296052216772051e87ba5aa61bfc222076.1547462042.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, Alexander Potapenko <glider@google.com>

On Mon, Jan 14, 2019 at 06:34:02PM +0800, Xin Long wrote:
> The similar issue as fixed in Commit 4a2eb0c37b47 ("sctp: initialize
> sin6_flowinfo for ipv6 addrs in sctp_inet6addr_event") also exists
> in sctp_inetaddr_event, as Alexander noticed.
> 
> To fix it, allocate sctp_sockaddr_entry with kzalloc for both sctp
> ipv4 and ipv6 addresses, as does in sctp_v4/6_copy_addrlist().
> 
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Seems you were faster than syzkaller, but we could still use:
Reported-by: syzbot+ae0c70c0c2d40c51bb92@syzkaller.appspotmail.com

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/ipv6.c     | 5 +----
>  net/sctp/protocol.c | 4 +---
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index b9ed271..ed8e006 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -97,11 +97,9 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
>  
>  	switch (ev) {
>  	case NETDEV_UP:
> -		addr = kmalloc(sizeof(struct sctp_sockaddr_entry), GFP_ATOMIC);
> +		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
>  		if (addr) {
>  			addr->a.v6.sin6_family = AF_INET6;
> -			addr->a.v6.sin6_port = 0;
> -			addr->a.v6.sin6_flowinfo = 0;
>  			addr->a.v6.sin6_addr = ifa->addr;
>  			addr->a.v6.sin6_scope_id = ifa->idev->dev->ifindex;
>  			addr->valid = 1;
> @@ -434,7 +432,6 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
>  		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
>  		if (addr) {
>  			addr->a.v6.sin6_family = AF_INET6;
> -			addr->a.v6.sin6_port = 0;
>  			addr->a.v6.sin6_addr = ifp->addr;
>  			addr->a.v6.sin6_scope_id = dev->ifindex;
>  			addr->valid = 1;
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index d5878ae..4e0eeb1 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -101,7 +101,6 @@ static void sctp_v4_copy_addrlist(struct list_head *addrlist,
>  		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
>  		if (addr) {
>  			addr->a.v4.sin_family = AF_INET;
> -			addr->a.v4.sin_port = 0;
>  			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
>  			addr->valid = 1;
>  			INIT_LIST_HEAD(&addr->list);
> @@ -776,10 +775,9 @@ static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
>  
>  	switch (ev) {
>  	case NETDEV_UP:
> -		addr = kmalloc(sizeof(struct sctp_sockaddr_entry), GFP_ATOMIC);
> +		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
>  		if (addr) {
>  			addr->a.v4.sin_family = AF_INET;
> -			addr->a.v4.sin_port = 0;
>  			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
>  			addr->valid = 1;
>  			spin_lock_bh(&net->sctp.local_addr_lock);
> -- 
> 2.1.0
> 
