From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 28 May 2019 01:36:00 +0000
Subject: Re: memory leak in sctp_process_init
Message-Id: <20190528013600.GM5506@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000097abb90589e804fd@google.com>
In-Reply-To: <00000000000097abb90589e804fd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Mon, May 27, 2019 at 05:48:06PM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    9c7db500 Merge tag 'selinux-pr-20190521' of git://git.ker=
n..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10388530a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?xadd9e15a761691d
> dashboard link: https://syzkaller.appspot.com/bug?extid=F7e9153b037eac9b1=
df8
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e32f8ca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177fa530a00000
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
>=20
>  0 to HW filter on device batadv0
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810ef68400 (size 1024):
>   comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
>   hex dump (first 32 bytes):
>     1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000a02cebbd>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
>     [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c:3675
>     [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
>     [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
>     [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
> net/sctp/sm_make_chunk.c:2437
>     [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect.c:6=
82
> [inline]
>     [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.c:13=
84
> [inline]
>     [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1194
> [inline]
>     [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60
> net/sctp/sm_sideeffect.c:1165

Note that this is on the client side. It was handling the INIT_ACK
chunk, from sctp_sf_do_5_1C_ack().

I'm not seeing anything else other than sctp_association_free()
releasing this memory. This means 2 things:
- Every time the cookie is retransmitted, it leaks. As shown by the
  repetitive leaks here.
- The cookie remains allocated throughout the association, which is
  also not good as that's a 1k that we could have released back to the
  system right after the handshake.

  Marcelo
