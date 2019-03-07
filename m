From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 07 Mar 2019 17:50:01 +0000
Subject: Re: general protection fault in sctp_sched_rr_dequeue
Message-Id: <20190307175001.GA13515@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000cc734405836318dc@google.com>
 <CADvbK_fJ8R0WmQaFcz0sOhL_AXH3AdO2zLeqMD38X22izEAMNg@mail.gmail.com>
 <20190306120310.GA6711@hmswarspite.think-freely.org>
In-Reply-To: <20190306120310.GA6711@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, syzbot <syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, Mar 06, 2019 at 07:03:10AM -0500, Neil Horman wrote:
> On Wed, Mar 06, 2019 at 06:43:48PM +0800, Xin Long wrote:
> > On Wed, Mar 6, 2019 at 9:42 AM syzbot
> > <syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    63bdf4284c38 Merge branch 'linus' of git://git.kernel=
.org/..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=100347cb200=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=872be057074=
64aaa
> > > dashboard link: https://syzkaller.appspot.com/bug?extidL9934f20522c0e=
fd657
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cd9b032=
00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127de8e7200=
000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the co=
mmit:
> > > Reported-by: syzbot+4c9934f20522c0efd657@syzkaller.appspotmail.com
> > >
> > > kauditd_printk_skb: 2 callbacks suppressed
> > > audit: type=1400 audit(1551833288.424:35): avc:  denied  { map } for
> > > pid=8035 comm=3D"bash" path=3D"/bin/bash" dev=3D"sda1" ino=1457
> > > scontext=3Dunconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> > > tcontext=3Dsystem_u:object_r:file_t:s0 tclass=3Dfile permissive=3D1
> > > audit: type=1400 audit(1551833294.934:36): avc:  denied  { map } for
> > > pid=8047 comm=3D"syz-executor778" path=3D"/root/syz-executor778173561"
> > > dev=3D"sda1" ino=16484 scontext=3Dunconfined_u:system_r:insmod_t:s0-s=
0:c0.c1023
> > > tcontext=3Dunconfined_u:object_r:user_home_t:s0 tclass=3Dfile permiss=
ive=3D1
> > > kasan: CONFIG_KASAN_INLINE enabled
> > > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 1 PID: 8047 Comm: syz-executor778 Not tainted 5.0.0+ #7
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS
> > > Google 01/01/2011
> > > RIP: 0010:sctp_sched_rr_dequeue+0xd3/0x170 net/sctp/stream_sched_rr.c=
:141
> > The panic was caused by sched->init() reset stream->rr_next =3D NULL, e=
ven
> > if outq->out_chunk_list is not empty.
> >=20
> > We should remove the sched->init() from sctp_stream_init(), since
> > all sched info was moved into sout->ext and sctp_stream_alloc_out()
> > will not afffect it.
> >=20
> I think what you're saying is we can just let sctp_outq_init handle the s=
tream
> scheduler initalization, correct?  If so, ACK to that approach
> Neil

+1

  Marcelo
