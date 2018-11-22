From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 22 Nov 2018 14:37:43 +0000
Subject: Re: KASAN: use-after-free Read in __lock_sock
Message-Id: <20181122143743.GE31918@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000b98a67057ad7158a@google.com>
 <CADvbK_f3CpK=qJFngBGmO3VXFLsJm9=qqZVtxYOeBS8rwE=9Ew@mail.gmail.com>
 <20181122131344.GD31918@localhost.localdomain>
 <CADvbK_f0n64K==prdcM0KzU0S3pbo1oMW3HhE8zMngCUZp3-iQ@mail.gmail.com>
In-Reply-To: <CADvbK_f0n64K==prdcM0KzU0S3pbo1oMW3HhE8zMngCUZp3-iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Nov 22, 2018 at 10:44:16PM +0900, Xin Long wrote:
> On Thu, Nov 22, 2018 at 10:13 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Nov 19, 2018 at 05:57:33PM +0900, Xin Long wrote:
> > > On Sat, Nov 17, 2018 at 4:18 PM syzbot
> > > <syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=156cd5334=
00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?xJ0a89f12ca=
9b0f5
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9276d76e83e=
3bcde6c99
> > > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the =
commit:
> > > > Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> > > >
> > > > netlink: 5 bytes leftover after parsing attributes in process
> > > > `syz-executor5'.
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
> > > > kernel/locking/lockdep.c:3218
> > > > Read of size 8 at addr ffff8881d26d60e0 by task syz-executor1/13725
> > > >
> > > > CPU: 0 PID: 13725 Comm: syz-executor1 Not tainted 4.20.0-rc2+ #333
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS
> > > > Google 01/01/2011
> > > > Call Trace:
> > > >   __dump_stack lib/dump_stack.c:77 [inline]
> > > >   dump_stack+0x244/0x39d lib/dump_stack.c:113
> > > >   print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
> > > >   kasan_report_error mm/kasan/report.c:354 [inline]
> > > >   kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
> > > >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
> > > >   __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
> > > >   lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
> > > >   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
> > > >   _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
> > > >   spin_lock_bh include/linux/spinlock.h:334 [inline]
> > > >   __lock_sock+0x203/0x350 net/core/sock.c:2253
> > > >   lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
> > > >   lock_sock include/net/sock.h:1492 [inline]
> > > >   sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
> > >
> > > static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > > {
> > >         struct sctp_endpoint *ep =3D tsp->asoc->ep;
> > >         struct sctp_comm_param *commp =3D p;
> > >         struct sock *sk =3D ep->base.sk; <--- [1]
> > > ...
> > >         int err =3D 0;
> > >
> > >         lock_sock(sk);  <--- [2]
> > >
> > > Between [1] and [2], an asoc peeloff may happen, still thinking
> > > how to avoid this.
> >
> > This race cannot happen more than once for an asoc, so something
> > like this may be doable:
> >
> >         struct sctp_comm_param *commp =3D p;
> >         struct sctp_endpoint *ep;
> >         struct sock *sk;
> > ...
> >         int err =3D 0;
> >
> > again:
> >         ep =3D tsp->asoc->ep;
> >         sk =3D ep->base.sk; <---[3]
> >         lock_sock(sk);  <--- [2]
> if peel-off happens between [3] and [2], and sk is freed
> somewhere, it will panic on [2] when trying to get the
> sk->lock, no?

Not sure what protects it, but this construct is also used in BH processing=
 at
sctp_rcv():
...
        bh_lock_sock(sk); [4]

        if (sk !=3D rcvr->sk) {
                /* Our cached sk is different from the rcvr->sk.  This is
                 * because migrate()/accept() may have moved the association
                 * to a new socket and released all the sockets.  So now we
                 * are holding a lock on the old socket while the user may
                 * be doing something with the new socket.  Switch our veiw
                 * of the current sk.
                 */
                bh_unlock_sock(sk);
                sk =3D rcvr->sk;
                bh_lock_sock(sk);
        }
...

If it is not safe, then we have an issue there too.
And by [4] that copy on sk is pretty old already.

>=20
> >         if (sk !=3D tsp->asoc->ep->base.sk) {
> >                 /* Asoc was peeloff'd */
> >                 unlock_sock(sk);
> >                 goto again;
> >         }
> >
> > Similarly to what we did on cea0cc80a677 ("sctp: use the right sk
> > after waking up from wait_buf sleep").
