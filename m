From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Apr 2018 14:51:08 +0000
Subject: Re: [PATCH net] sctp: do not check port in sctp_inet6_cmp_addr
Message-Id: <20180411145108.GB3711@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <340aad3be762046ca9d02e54edba5bfefa2f4e71.1523451485.git.lucien.xin@gmail.com>
 <20180411144241.GA3711@localhost.localdomain>
In-Reply-To: <20180411144241.GA3711@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, Apr 11, 2018 at 11:42:41AM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Apr 11, 2018 at 08:58:05PM +0800, Xin Long wrote:
> > pf->cmp_addr() is called before binding a v6 address to the sock. It
> > should not check ports, like in sctp_inet_cmp_addr.
> >
> > But sctp_inet6_cmp_addr checks the addr by invoking af(6)->cmp_addr,
> > sctp_v6_cmp_addr where it also compares the ports.
> >
> > This would cause that setsockopt(SCTP_SOCKOPT_BINDX_ADD) could bind
> > multiple duplicated IPv6 addresses after Commit 40b4f0fd74e4 ("sctp:
> > lack the check for ports in sctp_v6_cmp_addr").
> >
> > This patch is to remove af->cmp_addr called in sctp_inet6_cmp_addr,
> > but do the proper check for both v6 addrs and v4mapped addrs.
> >
> > Fixes: 40b4f0fd74e4 ("sctp: lack the check for ports in sctp_v6_cmp_addr")
> > Reported-by: Jianwen Ji <jiji@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Sorry, I take this back.
