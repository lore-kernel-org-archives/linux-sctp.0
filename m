From: David Miller <davem@davemloft.net>
Date: Fri, 13 Apr 2018 02:01:46 +0000
Subject: Re: [PATCHv2 net] sctp: do not check port in sctp_inet6_cmp_addr
Message-Id: <20180412.220146.1333515003918278237.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7220f314b70726ba4afee91df11e9ae8d1962e01.1523514271.git.lucien.xin@gmail.com>
In-Reply-To: <7220f314b70726ba4afee91df11e9ae8d1962e01.1523514271.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Apr 2018 14:24:31 +0800

> pf->cmp_addr() is called before binding a v6 address to the sock. It
> should not check ports, like in sctp_inet_cmp_addr.
> 
> But sctp_inet6_cmp_addr checks the addr by invoking af(6)->cmp_addr,
> sctp_v6_cmp_addr where it also compares the ports.
> 
> This would cause that setsockopt(SCTP_SOCKOPT_BINDX_ADD) could bind
> multiple duplicated IPv6 addresses after Commit 40b4f0fd74e4 ("sctp:
> lack the check for ports in sctp_v6_cmp_addr").
> 
> This patch is to remove af->cmp_addr called in sctp_inet6_cmp_addr,
> but do the proper check for both v6 addrs and v4mapped addrs.
> 
> v1->v2:
>   - define __sctp_v6_cmp_addr to do the common address comparison
>     used for both pf and af v6 cmp_addr.
> 
> Fixes: 40b4f0fd74e4 ("sctp: lack the check for ports in sctp_v6_cmp_addr")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
