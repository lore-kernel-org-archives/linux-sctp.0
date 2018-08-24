From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 12:51:50 +0000
Subject: Re: KASAN: use-after-free Read in sctp_transport_get_next
Message-Id: <20180824125150.GL5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000ccaf1d0574297b6b@google.com>
In-Reply-To: <000000000000ccaf1d0574297b6b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com, lucien.xin@gmail.com

On Fri, Aug 24, 2018 at 12:40:03AM -0700, syzbot wrote:
> CPU: 1 PID: 12694 Comm: syz-executor0 Not tainted 4.18.0+ #107
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
>  print_address_description+0x6c/0x20b mm/kasan/report.c:256
>  kasan_report_error mm/kasan/report.c:354 [inline]
>  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>  sctp_transport_get_next+0x11c/0x140 net/sctp/socket.c:5008
>  sctp_transport_get_idx net/sctp/socket.c:5022 [inline]

It is iterating over transports but then also accessing the
association directly, without checking any refcnts before that.

struct sctp_transport *sctp_transport_get_next(struct net *net,
					       struct rhashtable_iter *iter)
{
	struct sctp_transport *t;

	t = rhashtable_walk_next(iter);
	for (; t; t = rhashtable_walk_next(iter)) {
		if (IS_ERR(t)) {
			if (PTR_ERR(t) = -EAGAIN)
				continue;
			break;
		}

		if (net_eq(sock_net(t->asoc->base.sk), net) &&
		    t->asoc->peer.primary_path = t)
			break;

and these t->asoc->  are risky because transport may be laying dead on
the water already, as transports are freed by RCU and associations are
not.
