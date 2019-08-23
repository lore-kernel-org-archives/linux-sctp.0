From: David Miller <davem@davemloft.net>
Date: Fri, 23 Aug 2019 21:42:50 +0000
Subject: Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Message-Id: <20190823.144250.2063544404229146484.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
In-Reply-To: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, brouer@redhat.com, ecree@solarflare.com, dvyukov@google.com, syzkaller-bugs@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 23 Aug 2019 19:33:03 +0800

> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
> listify ip_rcv_finish in case of forwarding") does for ipv4.
> 
> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
> trace was:
 ...
> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
