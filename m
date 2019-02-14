From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Feb 2019 14:03:30 +0000
Subject: Re: KASAN: use-after-free Read in sctp_outq_tail
Message-Id: <CADvbK_fwUdU3_CWBFYfw+ZeOLvEF9p6koP2FUdo+m0SCqGN+Ug@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000002015db0581b71858@google.com> <CADvbK_dndFMxyUZk=k8qEy9=PNbLc81F++2L0fbdtUdbupq4Xg@mail.gmail.com>
 <20190213135157.GJ10665@localhost.localdomain>
In-Reply-To: <20190213135157.GJ10665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Wed, Feb 13, 2019 at 9:52 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Feb 13, 2019 at 12:35:56PM +0800, Xin Long wrote:
> > On Wed, Feb 13, 2019 at 4:00 AM syzbot
> > <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    d4104460aec1 Add linux-next specific files for 201902=
11
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14140124c00=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=C8a112d3b0d=
6719b
> > > dashboard link: https://syzkaller.appspot.com/bug?extidx23fa3f3e2d693=
41ea8
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the co=
mmit:
> > > Reported-by: syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: use-after-free in list_add_tail include/linux/list.h:93 [=
inline]
> > > BUG: KASAN: use-after-free in sctp_outq_tail_data net/sctp/outqueue.c=
:105
> > > [inline]
> > > BUG: KASAN: use-after-free in sctp_outq_tail+0x816/0x930
> > > net/sctp/outqueue.c:313
> > > Read of size 8 at addr ffff88807b19a7b8 by task syz-executor.0/30745
> > I think https://patchwork.ozlabs.org/patch/1040500/ will fix this.
>
> I don't think so. Seems it will switch from use-after-free to NULL deref
> instead with that patch.
It will allocate ext for the stream if its ext is NULL in
sctp_sendmsg_to_asoc(), the new data will work fine. As for
the old data on the surplus streams, it has been dropped in
sctp_stream_outq_migrate().

>
> > > CPU: 1 PID: 30745 Comm: syz-executor.0 Not tainted 5.0.0-rc5-next-201=
90211
> > > #32
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS
> > > Google 01/01/2011
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > >   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
> > >   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
> > >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> > >   list_add_tail include/linux/list.h:93 [inline]
> > >   sctp_outq_tail_data net/sctp/outqueue.c:105 [inline]
> > >   sctp_outq_tail+0x816/0x930 net/sctp/outqueue.c:313
> > >   sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1109 [inline]
> > >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1784 [inline]
> > >   sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > >   sctp_do_sm+0x68e/0x5380 net/sctp/sm_sideeffect.c:1191
> > >   sctp_primitive_SEND+0xa0/0xd0 net/sctp/primitive.c:178
> > >   sctp_sendmsg_to_asoc+0xa63/0x17b0 net/sctp/socket.c:1955
>
> sctp_sendmsg_to_asoc()
> ...
>         if (sinfo->sinfo_stream >=3D asoc->stream.outcnt) {
>                 err =3D -EINVAL;
>                 goto err;
>         }
>
>         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
> ...
>
> It should have aborted even if an old ->ext was still there because
> outcnt is correctly updated. So somehow outcnt was wrong here.
>
> sctp_stream_init()
> ...
>         /* Filter out chunks queued on streams that won't exist anymore */
>         sched->unsched_all(stream);
>         sctp_stream_outq_migrate(stream, NULL, outcnt);   <--- [A]
>         sched->sched_all(stream);
>
>         ret =3D sctp_stream_alloc_out(stream, outcnt, gfp); <--- [B]
>         if (ret)
>                 goto out;
>
>         stream->outcnt =3D outcnt;                          <--- [C]
> ...
>
> We have a problem here because [A] is freeing ->ext, but [B] can fail (EN=
OMEM),
> which would lead it to not update outcnt in [C] even after the
> changes already performed in [A].
>
> It should handle the freeing of ->ext in sctp_stream_alloc_out()
> instead, or allocate the flexarray earlier (so it can bail out before
> freeing stuff).
Agree that it's better to do:
        sched->unsched_all(stream);
        sctp_stream_outq_migrate(stream, NULL, outcnt);
        sched->sched_all(stream);
after the flexarray allocation.

Just sctp_stream_alloc_out() can not be used here anymore, as
stream->out will be set in it.
