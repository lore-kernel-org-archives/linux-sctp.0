From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 16 Dec 2019 14:56:38 +0000
Subject: Re: memory leak in sctp_stream_init
Message-Id: <20191216145638.GB5058@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000f531080599c4073c@google.com>
 <20191216114828.GA20281@hmswarspite.think-freely.org>
In-Reply-To: <20191216114828.GA20281@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Neil Horman <nhorman@tuxdriver.com>
Cc: syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Mon, Dec 16, 2019 at 06:48:28AM -0500, Neil Horman wrote:
> On Sun, Dec 15, 2019 at 12:35:09PM -0800, syzbot wrote:
> > Hello,
> >=20
> > syzbot found the following crash on:
> >=20
> > HEAD commit:    e31736d9 Merge tag 'nios2-v5.5-rc2' of git://git.kernel=
.or..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=126a177ee00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=BBf3a35184a3e=
d64
> > dashboard link: https://syzkaller.appspot.com/bug?extidw2d9e36c490b18d5=
1d1
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15602ddee00=
000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12798251e00000
> >=20
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> >=20
> > BUG: memory leak
> > unreferenced object 0xffff8881080a3000 (size 4096):
> >   comm "syz-executor474", pid 7155, jiffies 4294942658 (age 15.870s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000df094087>] genradix_alloc_node lib/generic-radix-tree.c:90
> > [inline]
> >     [<00000000df094087>] __genradix_ptr_alloc+0xf5/0x250
> > lib/generic-radix-tree.c:122
> >     [<0000000057cfa7bb>] __genradix_prealloc+0x46/0x70
> > lib/generic-radix-tree.c:223
> >     [<0000000029d02dac>] sctp_stream_alloc_out.part.0+0x57/0x80
> > net/sctp/stream.c:86
> >     [<00000000bb930a04>] sctp_stream_alloc_out net/sctp/stream.c:151
> > [inline]
> >     [<00000000bb930a04>] sctp_stream_init+0x129/0x180 net/sctp/stream.c=
:129
> >     [<00000000ba13c246>] sctp_association_init net/sctp/associola.c:229
> > [inline]
> >     [<00000000ba13c246>] sctp_association_new+0x46e/0x700
> > net/sctp/associola.c:295
> >     [<000000008eb57b4d>] sctp_connect_new_asoc+0x90/0x220
> > net/sctp/socket.c:1070
> >     [<00000000ea24e048>] __sctp_connect+0x182/0x3b0 net/sctp/socket.c:1=
176
> >     [<00000000aa2c530a>] __sctp_setsockopt_connectx+0xa9/0xf0
> > net/sctp/socket.c:1322
> >     [<0000000018934bfd>] sctp_getsockopt_connectx3 net/sctp/socket.c:14=
07
> > [inline]
> >     [<0000000018934bfd>] sctp_getsockopt net/sctp/socket.c:8079 [inline]
> >     [<0000000018934bfd>] sctp_getsockopt+0x1394/0x32f6
> > net/sctp/socket.c:8010
> >     [<000000005fd7e3c8>] sock_common_getsockopt+0x38/0x50
> > net/core/sock.c:3108
> >     [<00000000333baf72>] __sys_getsockopt+0xa8/0x180 net/socket.c:2162
> >     [<00000000de0f98e4>] __do_sys_getsockopt net/socket.c:2177 [inline]
> >     [<00000000de0f98e4>] __se_sys_getsockopt net/socket.c:2174 [inline]
> >     [<00000000de0f98e4>] __x64_sys_getsockopt+0x26/0x30 net/socket.c:21=
74
> >     [<00000000cf1dfee9>] do_syscall_64+0x73/0x220
> > arch/x86/entry/common.c:294
> >     [<000000000f416860>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >=20
>=20
> Almost looks like we're processing a connectx socket option while the han=
dling
> of a cookie echo chunk is in flight through the state machine (i.e.
> sctp_stream_update is getting called on the association while we're setti=
ng it
> up in parallel), though I'm not sure how that can happen

I'm seeing something different. In the console output there were 2
fault injections and they hit the genradix preallocation. And our
handling of that error within genradix is the responsible for it:

sctp_stream_alloc_out()
{
...
        ret =3D genradix_prealloc(&stream->out, outcnt, gfp);
        if (ret)
                return ret;

        stream->outcnt =3D outcnt;
}

int __genradix_prealloc(struct __genradix *radix, size_t size,
                        gfp_t gfp_mask)
{
        size_t offset;

        for (offset =3D 0; offset < size; offset +=3D PAGE_SIZE)
                if (!__genradix_ptr_alloc(radix, offset, gfp_mask))
                        return -ENOMEM;

        return 0;
}

Note how it (and also __genradix_ptr_alloc()) doesn't clean up the
already, newly initialized, indexes.

Then it doesn't clean up the partially pre-allocated items on error
handling:

sctp_stream_init()
{
...
        ret =3D sctp_stream_alloc_out(stream, outcnt, gfp);
        if (ret)
                goto out;
...
        ret =3D sctp_stream_alloc_in(stream, incnt, gfp);
        if (ret) {
                sched->free(stream);
                genradix_free(&stream->out);   <--
                stream->outcnt =3D 0;
                goto out;
        }

out:
        return ret;
}

Considering that genradix_prealloc() failure is not fatal, seems the
fix here is to just ignore the failure in sctp_stream_alloc_out() and
let genradix try again later on.

  Marcelo
