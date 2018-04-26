From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 26 Apr 2018 11:25:56 +0000
Subject: Re: [PATCH net] sctp: handle two v4 addrs comparison in sctp_inet6_cmp_addr
Message-Id: <20180426112556.GB18656@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <17bfe46d7b9941f2283043f45ea5644c166c32c3.1524723237.git.lucien.xin@gmail.com>
In-Reply-To: <17bfe46d7b9941f2283043f45ea5644c166c32c3.1524723237.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller@googlegroups.com

On Thu, Apr 26, 2018 at 02:13:57PM +0800, Xin Long wrote:
> Since sctp ipv6 socket also supports v4 addrs, it's possible to
> compare two v4 addrs in pf v6 .cmp_addr, sctp_inet6_cmp_addr.
> 
> However after Commit 1071ec9d453a ("sctp: do not check port in
> sctp_inet6_cmp_addr"), it no longer calls af1->cmp_addr, which
> in this case is sctp_v4_cmp_addr, but calls __sctp_v6_cmp_addr
> where it handles them as two v6 addrs. It would cause a out of
> bounds crash.
> 
> syzbot found this crash when trying to bind two v4 addrs to a
> v6 socket.
> 
> This patch fixes it by adding the process for two v4 addrs in
> sctp_inet6_cmp_addr.
> 
> Fixes: 1071ec9d453a ("sctp: do not check port in sctp_inet6_cmp_addr")
> Reported-by: syzbot+cd494c1dd681d4d93ebb@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/ipv6.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 2e3f7b7..4224711 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -895,6 +895,9 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
>  	if (sctp_is_any(sk, addr1) || sctp_is_any(sk, addr2))
>  		return 1;
>  
> +	if (addr1->sa.sa_family = AF_INET && addr2->sa.sa_family = AF_INET)
> +		return addr1->v4.sin_addr.s_addr = addr2->v4.sin_addr.s_addr;
> +
>  	return __sctp_v6_cmp_addr(addr1, addr2);
>  }
>  
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
