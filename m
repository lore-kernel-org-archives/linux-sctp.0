From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 17 Apr 2020 13:31:10 +0000
Subject: Re: memory leak in sctp_stream_init_ext (2)
Message-Id: <20200417133110.GA2688@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000004373bc05a37460df@google.com>
 <20200417083224.13400-1-hdanton@sina.com>
In-Reply-To: <20200417083224.13400-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+96e916d6f6f7617bc9fc@syzkaller.appspotmail.com>, davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Fri, Apr 17, 2020 at 04:32:24PM +0800, Hillf Danton wrote:
>=20
> On Thu, 16 Apr 2020 20:45:10 -0700
> > syzbot found the following crash on:
> >=20
> > HEAD commit:    00086336 Merge tag 'efi-urgent-2020-04-15' of git://git=
.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12996107e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=EFff978b972fb=
2c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=96e916d6f6f7617=
bc9fc
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137ddf3fe00=
000
> >=20
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+96e916d6f6f7617bc9fc@syzkaller.appspotmail.com
> >=20
> > BUG: memory leak
> > unreferenced object 0xffff888103ba4580 (size 96):
> >   comm "syz-executor.1", pid 8335, jiffies 4294953411 (age 14.410s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000b06f3e80>] kmalloc include/linux/slab.h:555 [inline]
> >     [<00000000b06f3e80>] kzalloc include/linux/slab.h:669 [inline]
> >     [<00000000b06f3e80>] sctp_stream_init_ext+0x28/0xe0 net/sctp/stream=
.c:162
> >     [<00000000aff2ecba>] sctp_sendmsg_to_asoc+0x9af/0xab0 net/sctp/sock=
et.c:1811
> >     [<00000000d5d5eb76>] sctp_sendmsg+0x2a6/0xc60 net/sctp/socket.c:2031
> >     [<0000000023cdbfa3>] inet_sendmsg+0x39/0x60 net/ipv4/af_inet.c:807
> >     [<00000000885878ef>] sock_sendmsg_nosec net/socket.c:652 [inline]
> >     [<00000000885878ef>] sock_sendmsg+0x4c/0x60 net/socket.c:672
> >     [<0000000009d727e5>] __sys_sendto+0x11d/0x1c0 net/socket.c:2000
> >     [<0000000066974477>] __do_sys_sendto net/socket.c:2012 [inline]
> >     [<0000000066974477>] __se_sys_sendto net/socket.c:2008 [inline]
> >     [<0000000066974477>] __x64_sys_sendto+0x26/0x30 net/socket.c:2008
> >     [<00000000ecc1fea9>] do_syscall_64+0x6e/0x220 arch/x86/entry/common=
.c:295
> >     [<00000000605d798b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Release ext in case of failure of initializing stream.
>=20
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -145,9 +145,10 @@ in:
>  	ret =3D sctp_stream_alloc_in(stream, incnt, gfp);
>  	if (ret) {

Are you working on the right code? Seems you're missing
61d5d4062876 ("sctp: fix err handling of stream initialization")

Anyhow, the patch intention looks right.

>  		sched->free(stream);
> +		for (i =3D 0; i < stream->outcnt; i++)
> +			kfree(SCTP_SO(stream, i)->ext);
>  		genradix_free(&stream->out);
>  		stream->outcnt =3D 0;
> -		goto out;
>  	}
> =20
>  out:
>=20
