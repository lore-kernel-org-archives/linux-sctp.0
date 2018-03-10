From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 10 Mar 2018 19:04:27 +0000
Subject: Re: KASAN: use-after-free Read in sctp_association_free (2)
Message-Id: <20180310190427.GA2484@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000017dfe905670110cf@google.com>
 <20180309220823.GA24848@neilslaptop.think-freely.org>
 <CADvbK_fGkhJeirYwiu9ORmmPPBpqamgO2+vi9Osyd92cUWJBVA@mail.gmail.com>
 <20180310131355.GA8798@hmswarspite.think-freely.org>
 <CADvbK_cFjeC-eGdKzYnJxySBY6emVVC8KXQtzLDUZLJzBLb-UA@mail.gmail.com>
In-Reply-To: <CADvbK_cFjeC-eGdKzYnJxySBY6emVVC8KXQtzLDUZLJzBLb-UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+a4e4112c3aff00c8cfd8@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sun, Mar 11, 2018 at 12:22:32AM +0800, Xin Long wrote:
> On Sat, Mar 10, 2018 at 9:13 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Sat, Mar 10, 2018 at 03:58:04PM +0800, Xin Long wrote:
> >> On Sat, Mar 10, 2018 at 6:08 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > On Fri, Mar 09, 2018 at 12:59:06PM -0800, syzbot wrote:
> >> >> Hello,
> >> >>
> >> >> syzbot hit the following crash on net-next commit
> >> >> fd372a7a9e5e9d8011a0222d10edd3523abcd3b1 (Thu Mar 8 19:43:48 2018 +0000)
> >> >> Merge tag 'mlx5-updates-2018-02-28-2' of
> >> >> git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
> >> >>
> >> >> So far this crash happened 2 times on net-next.
> >> >> C reproducer is attached.
> >> >> syzkaller reproducer is attached.
> >> >> Raw console output is attached.
> >> >> compiler: gcc (GCC) 7.1.1 20170620
> >> >> .config is attached.
> >> >>
> >> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> >> Reported-by: syzbot+a4e4112c3aff00c8cfd8@syzkaller.appspotmail.com
> >> >> It will help syzbot understand when the bug is fixed. See footer for
> >> >> details.
> >> >> If you forward the report, please keep this part and the footer.
> >> >>
> >> >> IPVS: ftp: loaded support on port[0] = 21
> >> >> IPVS: ftp: loaded support on port[0] = 21
> >> >> IPVS: ftp: loaded support on port[0] = 21
> >> >> IPVS: ftp: loaded support on port[0] = 21
> >> >> =================================
> >> >> BUG: KASAN: use-after-free in sctp_association_free+0x7b7/0x930
> >> >> net/sctp/associola.c:332
> >> >> Read of size 8 at addr ffff8801d8006ae0 by task syzkaller914861/4202
> >> >>
> >> >> CPU: 1 PID: 4202 Comm: syzkaller914861 Not tainted 4.16.0-rc4+ #258
> >> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> >> >> Google 01/01/2011
> >> >> Call Trace:
> >> >>  __dump_stack lib/dump_stack.c:17 [inline]
> >> >>  dump_stack+0x194/0x24d lib/dump_stack.c:53
> >> >>  print_address_description+0x73/0x250 mm/kasan/report.c:256
> >> >>  kasan_report_error mm/kasan/report.c:354 [inline]
> >> >>  kasan_report+0x23c/0x360 mm/kasan/report.c:412
> >> >>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> >> >>  sctp_association_free+0x7b7/0x930 net/sctp/associola.c:332
> >> >>  sctp_sendmsg+0xc67/0x1a80 net/sctp/socket.c:2075
> >> >>  inet_sendmsg+0x11f/0x5e0 net/ipv4/af_inet.c:763
> >> >>  sock_sendmsg_nosec net/socket.c:629 [inline]
> >> >>  sock_sendmsg+0xca/0x110 net/socket.c:639
> >> >>  SYSC_sendto+0x361/0x5c0 net/socket.c:1748
> >> >>  SyS_sendto+0x40/0x50 net/socket.c:1716
> >> >>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
> >> >>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> >> >> RIP: 0033:0x446d09
> >> >> RSP: 002b:00007f5dbac21da8 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
> >> >> RAX: ffffffffffffffda RBX: 00000000006e29fc RCX: 0000000000446d09
> >> >> RDX: 0000000000000001 RSI: 0000000020000340 RDI: 0000000000000003
> >> >> RBP: 00000000006e29f8 R08: 00000000204d9000 R09: 000000000000001c
> >> >> R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000000
> >> >> R13: 00007fff7b26fb1f R14: 00007f5dbac229c0 R15: 00000000006e2b60
> >> >>
> >> > I think we have a corner case with a0ff660058b88d12625a783ce9e5c1371c87951f
> >> > here.  If a peeloff event happens during a wait for sendbuf space, EPIPE will be
> >> > returned, and the code path appears to call sctp_association_put twice, leading
> >> > to the use after free situation.  I'll write a patch this weekend
> >> Hi, Neil, you're right.
> >>
> >> I didn't expect peeloff can be done on a NEW asoc, as peeloff needs
> >> assoc_id, which can only be set when connecting has started.
> >>
> >> But I realized that:
> >> f84af33 sctp: factor out sctp_sendmsg_to_asoc from sctp_sendmsg
> >>
> >> moved sctp_primitive_ASSOCIATE(connecting) before sctp_wait_for_sndbuf
> >> (snd buffer waiting). It means peeloff can be done on a NEW asoc.
> >> So you may want to move it back.
> >>
> > I agree with the root cause, but I'm not sure I agree with just moving the
> > wait_for_sndbuf call back above the call to associate.  I'm not sure I like
> > relying on placing a call in a spcific order solely to avoid an error condition
> > that might legitimately occur.  I think would rather check the return code at
> > the call site for the complete set of conditions for which we should not free
> > the association.  Something like this:
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 7d3476a4860d..a68846d2b0ef 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -2071,8 +2071,9 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
> >
> >         /* Send msg to the asoc */
> >         err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
> > -       if (err < 0 && err != -ESRCH && new)
> > -               sctp_association_free(asoc);
> > +       if ((err != -ESRCH) && (err != -EPIPE))
> > +               if (err < 0 && new)
> > +                       sctp_association_free(asoc);
> >
> >  out_unlock:
> >         release_sock(sk);
> >
> > Which I think also avoids the noted conflict.
> >
> > Thoughts?
> If sctp_association_free is called for general asoc, yes, I agree with you.
> But it's actually only for NEW asoc, a special case, not worth a extra check.
> 'err != -ESRCH' is already kind of ugly there (I couldn't find a nicer way :D),
> I don't hope there will be more like that.
> 
I agree with you on the uglyness aspect of the return code check, but I really
don't like the idea of placing the call to wait_for_sndbuf to guarantee a given
error code isn't returned, It just feels rickety to me.

> And also, I think I moved sctp_primitive_ASSOCIATE before
> sctp_wait_for_sndbuf by accident in that patch(Sorry), which may
> already change some behavior. We have to move it back.
> 
It seemed to me you did that specifically to enable the check for peeloff
events.  That is to say, if you check the socket write space first on a new
association, and then  get a peeloff event, the write space might have changed
(though I suppose in fairness, we will always be operating the old socket, so
the write space will only grow larger).  Either way there should be nothing
really wrong with checking write space after we preform the association.

But I suppose that moving it back is the safer approach.  It would be nice to
eliminate that odd error check as well if we can, but I'll start with just
returning the positioning to the way it was, and look to improve it later.  I'll
post the patch once I confirm the build works

Neil

