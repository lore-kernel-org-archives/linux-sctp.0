From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 24 Aug 2018 15:27:39 +0000
Subject: Re: KASAN: use-after-free Read in sctp_transport_get_next
Message-Id: <CADvbK_dWirKTx7rwhuYqbBfwS32YqOaHab8fra0RFVg6+9e+4g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000ccaf1d0574297b6b@google.com> <20180824125150.GL5311@localhost.localdomain>
In-Reply-To: <20180824125150.GL5311@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Fri, Aug 24, 2018 at 8:51 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Aug 24, 2018 at 12:40:03AM -0700, syzbot wrote:
> > CPU: 1 PID: 12694 Comm: syz-executor0 Not tainted 4.18.0+ #107
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x1c9/0x2b4 lib/dump_stack.c:113
> >  print_address_description+0x6c/0x20b mm/kasan/report.c:256
> >  kasan_report_error mm/kasan/report.c:354 [inline]
> >  kasan_report.cold.7+0x242/0x30d mm/kasan/report.c:412
> >  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> >  sctp_transport_get_next+0x11c/0x140 net/sctp/socket.c:5008
> >  sctp_transport_get_idx net/sctp/socket.c:5022 [inline]
>
> It is iterating over transports but then also accessing the
> association directly, without checking any refcnts before that.
>
> struct sctp_transport *sctp_transport_get_next(struct net *net,
>                                                struct rhashtable_iter *iter)
> {
>         struct sctp_transport *t;
>
>         t = rhashtable_walk_next(iter);
>         for (; t; t = rhashtable_walk_next(iter)) {
>                 if (IS_ERR(t)) {
>                         if (PTR_ERR(t) = -EAGAIN)
>                                 continue;
>                         break;
>                 }
>
>                 if (net_eq(sock_net(t->asoc->base.sk), net) &&
>                     t->asoc->peer.primary_path = t)
>                         break;
>
> and these t->asoc->  are risky because transport may be laying dead on
> the water already, as transports are freed by RCU and associations are
> not.
Thanks,
I will move sctp_transport_hold into sctp_transport_get_next():
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ce620e8..4bd5c2d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4881,9 +4881,14 @@ struct sctp_transport
*sctp_transport_get_next(struct net *net,
                        break;
                }

+               if (!sctp_transport_hold(t))
+                       continue;
+
                if (net_eq(sock_net(t->asoc->base.sk), net) &&
                    t->asoc->peer.primary_path = t)
                        break;
+
+               sctp_transport_put(t);
        }

        return t;
@@ -4896,8 +4901,10 @@ struct sctp_transport
*sctp_transport_get_idx(struct net *net,
        void *obj = SEQ_START_TOKEN;

        while (pos && (obj = sctp_transport_get_next(net, iter)) &&
-              !IS_ERR(obj))
+              !IS_ERR(obj)) {
                pos--;
+               sctp_transport_put(obj);
+       }

        return obj;
 }
@@ -4958,8 +4965,6 @@ int sctp_for_each_transport(int (*cb)(struct
sctp_transport *, void *),

        tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
        for (; !IS_ERR_OR_NULL(tsp); tsp = sctp_transport_get_next(net, &hti)) {
-               if (!sctp_transport_hold(tsp))
-                       continue;
                ret = cb(tsp, p);
                if (ret)
                        break;
