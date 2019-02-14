From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Feb 2019 14:52:00 +0000
Subject: Re: KASAN: use-after-free Read in sctp_outq_tail
Message-Id: <CADvbK_ctRtcV3Fz6CwAoiTtVH3h5u7gj=6BsiZSR3Qdq+2rDMA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000002015db0581b71858@google.com> <CADvbK_dndFMxyUZk=k8qEy9=PNbLc81F++2L0fbdtUdbupq4Xg@mail.gmail.com>
 <20190213135157.GJ10665@localhost.localdomain> <CADvbK_fwUdU3_CWBFYfw+ZeOLvEF9p6koP2FUdo+m0SCqGN+Ug@mail.gmail.com>
 <20190214141745.GL13621@localhost.localdomain> <20190214143911.GL10665@localhost.localdomain>
In-Reply-To: <20190214143911.GL10665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Feb 14, 2019 at 10:39 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Feb 14, 2019 at 12:17:45PM -0200, Marcelo Ricardo Leitner wrote:
> > On Thu, Feb 14, 2019 at 10:03:30PM +0800, Xin Long wrote:
> > > On Wed, Feb 13, 2019 at 9:52 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, Feb 13, 2019 at 12:35:56PM +0800, Xin Long wrote:
> > > > > On Wed, Feb 13, 2019 at 4:00 AM syzbot
> > > > > <syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > syzbot found the following crash on:
> > > > > >
> > > > > > HEAD commit:    d4104460aec1 Add linux-next specific files for =
20190211
> > > > > > git tree:       linux-next
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=14140=
124c00000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=C8a11=
2d3b0d6719b
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extidx23fa3f3=
e2d69341ea8
> > > > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > > >
> > > > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > > > >
> > > > > > IMPORTANT: if you fix the bug, please add the following tag to =
the commit:
> > > > > > Reported-by: syzbot+7823fa3f3e2d69341ea8@syzkaller.appspotmail.=
com
> > > > > >
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > BUG: KASAN: use-after-free in list_add_tail include/linux/list.=
h:93 [inline]
> > > > > > BUG: KASAN: use-after-free in sctp_outq_tail_data net/sctp/outq=
ueue.c:105
> > > > > > [inline]
> > > > > > BUG: KASAN: use-after-free in sctp_outq_tail+0x816/0x930
> > > > > > net/sctp/outqueue.c:313
> > > > > > Read of size 8 at addr ffff88807b19a7b8 by task syz-executor.0/=
30745
> > > > > I think https://patchwork.ozlabs.org/patch/1040500/ will fix this.
> > > >
> > > > I don't think so. Seems it will switch from use-after-free to NULL =
deref
> > > > instead with that patch.
> > > It will allocate ext for the stream if its ext is NULL in
> > > sctp_sendmsg_to_asoc(), the new data will work fine. As for
> >
> > Ehh, right!
> >
> > > the old data on the surplus streams, it has been dropped in
> > > sctp_stream_outq_migrate().
> >
> > Yep.
> >
> > >
> > > >
> > > > > > CPU: 1 PID: 30745 Comm: syz-executor.0 Not tainted 5.0.0-rc5-ne=
xt-20190211
> > > > > > #32
> > > > > > Hardware name: Google Google Compute Engine/Google Compute Engi=
ne, BIOS
> > > > > > Google 01/01/2011
> > > > > > Call Trace:
> > > > > >   __dump_stack lib/dump_stack.c:77 [inline]
> > > > > >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > > > > >   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:1=
87
> > > > > >   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
> > > > > >   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report=
.c:132
> > > > > >   list_add_tail include/linux/list.h:93 [inline]
> > > > > >   sctp_outq_tail_data net/sctp/outqueue.c:105 [inline]
> > > > > >   sctp_outq_tail+0x816/0x930 net/sctp/outqueue.c:313
> > > > > >   sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1109 [inline]
> > > > > >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1784 [inline]
> > > > > >   sctp_side_effects net/sctp/sm_sideeffect.c:1220 [inline]
> > > > > >   sctp_do_sm+0x68e/0x5380 net/sctp/sm_sideeffect.c:1191
> > > > > >   sctp_primitive_SEND+0xa0/0xd0 net/sctp/primitive.c:178
> > > > > >   sctp_sendmsg_to_asoc+0xa63/0x17b0 net/sctp/socket.c:1955
> > > >
> > > > sctp_sendmsg_to_asoc()
> > > > ...
> > > >         if (sinfo->sinfo_stream >=3D asoc->stream.outcnt) {
> > > >                 err =3D -EINVAL;
> > > >                 goto err;
> > > >         }
> > > >
> > > >         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->=
ext)) {
> > > > ...
> > > >
> > > > It should have aborted even if an old ->ext was still there because
> > > > outcnt is correctly updated. So somehow outcnt was wrong here.
> > > >
> > > > sctp_stream_init()
> > > > ...
> > > >         /* Filter out chunks queued on streams that won't exist any=
more */
> > > >         sched->unsched_all(stream);
> > > >         sctp_stream_outq_migrate(stream, NULL, outcnt);   <--- [A]
> > > >         sched->sched_all(stream);
> > > >
> > > >         ret =3D sctp_stream_alloc_out(stream, outcnt, gfp); <--- [B]
> > > >         if (ret)
> > > >                 goto out;
> > > >
> > > >         stream->outcnt =3D outcnt;                          <--- [C]
> > > > ...
> > > >
> > > > We have a problem here because [A] is freeing ->ext, but [B] can fa=
il (ENOMEM),
> > > > which would lead it to not update outcnt in [C] even after the
> > > > changes already performed in [A].
> > > >
> > > > It should handle the freeing of ->ext in sctp_stream_alloc_out()
> > > > instead, or allocate the flexarray earlier (so it can bail out befo=
re
> > > > freeing stuff).
> > > Agree that it's better to do:
> > >         sched->unsched_all(stream);
> > >         sctp_stream_outq_migrate(stream, NULL, outcnt);
> > >         sched->sched_all(stream);
> > > after the flexarray allocation.
> > >
> > > Just sctp_stream_alloc_out() can not be used here anymore, as
> > > stream->out will be set in it.
> >
> > What about carving out a sctp_stream_init_out() ? Like
> >
> >        struct flex_array *new_out;
> >
> >       /* just allocate it, nothing more */
> >          new_out =3D sctp_stream_alloc_out(outcnt, gfp);
> >          if (!new_out)
> >               goto out;
> >
> >          /* Filter out chunks queued on streams that won't exist anymor=
e */
> >          sched->unsched_all(stream);
> >          sctp_stream_outq_migrate(stream, NULL, outcnt);
> >          sched->sched_all(stream);
> >
> >       /* initialization stuff, and it can't fail anymore */
> >          sctp_stream_init_out(stream, outcnt, new_out);
> >
> > This may hurt a bit more with the genradix migration, but then we
> > don't end up dropping data for nothing.
>
> Reviewing calls to this function, if this allocation fails it will
> either cause the asoc to be terminated or sendmsg error.  So data loss
> is not really an issue here.
>
  sctp_stream_init+0xbc/0x410 net/sctp/stream.c:139
  sctp_process_init+0x21c3/0x2b20 net/sctp/sm_make_chunk.c:2466
  sctp_cmd_process_init net/sctp/sm_sideeffect.c:682 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1410 [inline]

on this path, seems that it won't terminate the asoc nor report a sending e=
rror.
