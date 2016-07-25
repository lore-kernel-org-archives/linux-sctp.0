From: David Miller <davem@davemloft.net>
Date: Mon, 25 Jul 2016 17:46:38 +0000
Subject: Re: [PATCH net-next] sctp: support ipv6 nonlocal bind
Message-Id: <20160725.104638.747513236812194365.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3a6fd04f36bcfc5557d70ba79cddfc9c5d33b3c.1469180331.git.lucien.xin@gmail.com>
In-Reply-To: <b3a6fd04f36bcfc5557d70ba79cddfc9c5d33b3c.1469180331.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 22 Jul 2016 17:38:51 +0800

> This patch makes sctp support ipv6 nonlocal bind by adding
> sp->inet.freebind and net->ipv6.sysctl.ip_nonlocal_bind
> check in sctp_v6_available as what sctp did to support
> ipv4 nonlocal bind (commit cdac4e077489).
> 
> Reported-by: Shijoe George <spanjikk@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
