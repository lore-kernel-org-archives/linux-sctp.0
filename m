From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 29 May 2019 19:07:09 +0000
Subject: Re: memory leak in sctp_process_init
Message-Id: <20190529190709.GE31099@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
In-Reply-To: <20190528111550.GA4658@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Tue, May 28, 2019 at 07:15:50AM -0400, Neil Horman wrote:
> On Mon, May 27, 2019 at 10:36:00PM -0300, Marcelo Ricardo Leitner wrote:
> > On Mon, May 27, 2019 at 05:48:06PM -0700, syzbot wrote:
> > > Hello,
> > >=20
> > > syzbot found the following crash on:
> > >=20
> > > HEAD commit:    9c7db500 Merge tag 'selinux-pr-20190521' of git://git=
.kern..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10388530a00=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?xadd9e15a7616=
91d
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=F7e9153b037ea=
c9b1df8
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e32f8ca=
00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177fa530a00=
000
> > >=20
> > > IMPORTANT: if you fix the bug, please add the following tag to the co=
mmit:
> > > Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
> > >=20
> > >  0 to HW filter on device batadv0
> > > executing program
> > > executing program
> > > executing program
> > > BUG: memory leak
> > > unreferenced object 0xffff88810ef68400 (size 1024):
> > >   comm "syz-executor273", pid 7046, jiffies 4294945598 (age 28.770s)
> > >   hex dump (first 32 bytes):
> > >     1d de 28 8d de 0b 1b e3 b5 c2 f9 68 fd 1a 97 25  ..(........h...%
> > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > >   backtrace:
> > >     [<00000000a02cebbd>] kmemleak_alloc_recursive
> > > include/linux/kmemleak.h:55 [inline]
> > >     [<00000000a02cebbd>] slab_post_alloc_hook mm/slab.h:439 [inline]
> > >     [<00000000a02cebbd>] slab_alloc mm/slab.c:3326 [inline]
> > >     [<00000000a02cebbd>] __do_kmalloc mm/slab.c:3658 [inline]
> > >     [<00000000a02cebbd>] __kmalloc_track_caller+0x15d/0x2c0 mm/slab.c=
:3675
> > >     [<000000009e6245e6>] kmemdup+0x27/0x60 mm/util.c:119
> > >     [<00000000dfdc5d2d>] kmemdup include/linux/string.h:432 [inline]
> > >     [<00000000dfdc5d2d>] sctp_process_init+0xa7e/0xc20
> > > net/sctp/sm_make_chunk.c:2437
> > >     [<00000000b58b62f8>] sctp_cmd_process_init net/sctp/sm_sideeffect=
.c:682
> > > [inline]
> > >     [<00000000b58b62f8>] sctp_cmd_interpreter net/sctp/sm_sideeffect.=
c:1384
> > > [inline]
> > >     [<00000000b58b62f8>] sctp_side_effects net/sctp/sm_sideeffect.c:1=
194
> > > [inline]
> > >     [<00000000b58b62f8>] sctp_do_sm+0xbdc/0x1d60
> > > net/sctp/sm_sideeffect.c:1165
> >=20
> > Note that this is on the client side. It was handling the INIT_ACK
> > chunk, from sctp_sf_do_5_1C_ack().
> >=20
> > I'm not seeing anything else other than sctp_association_free()
> > releasing this memory. This means 2 things:
> > - Every time the cookie is retransmitted, it leaks. As shown by the
> >   repetitive leaks here.
> > - The cookie remains allocated throughout the association, which is
> >   also not good as that's a 1k that we could have released back to the
> >   system right after the handshake.
> >=20
> >   Marcelo
> >=20
> If we have an INIT chunk bundled with a COOKIE_ECHO chunk in the same pac=
ket,
> this might occur.  Processing for each chunk (via sctp_cmd_process_init a=
nd
> sctp_sf_do_5_1D_ce both call sctp_process_init, which would cause a secon=
d write
> to asoc->peer.cookie, leaving the first write (set via kmemdup), to be or=
phaned
> and leak.  Seems like we should set a flag to determine if we've already =
cloned
> the cookie, and free the old one if its set.  If we wanted to do that on =
the
> cheap, we might be able to get away with checking asoc->stream->[in|out]c=
nt for
> being non-zero as an indicator if we've already cloned the cookie
>=20
> Neil
>=20
>=20

Completely untested, but can you give this patch a shot?


diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0767701ef362..a5772d72eb87 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1701,6 +1701,7 @@ struct sctp_association {
 		__u8    sack_needed:1,     /* Do we need to sack the peer? */
 			sack_generation:1,
 			zero_window_announced:1;
+			cookie_allocated:1
 		__u32	sack_cnt;
=20
 		__u32   adaptation_ind;	 /* Adaptation Code point. */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1999237ce481..b6e8fd7081b7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -213,6 +213,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->peer.sack_needed =3D 1;
 	asoc->peer.sack_generation =3D 1;
+	asoc->cookie_allocated=3D0;
=20
 	/* Assume that the peer will tell us if he recognizes ASCONF
 	 * as part of INIT exchange.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 92331e1195c1..e966a3cc78bf 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2419,9 +2419,12 @@ int sctp_process_init(struct sctp_association *asoc,=
 struct sctp_chunk *chunk,
 	/* Copy cookie in case we need to resend COOKIE-ECHO. */
 	cookie =3D asoc->peer.cookie;
 	if (cookie) {
+		if (asoc->peer.cookie_allocated)
+			kfree(cookie);
 		asoc->peer.cookie =3D kmemdup(cookie, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			goto clean_up;
+		asoc->peer.cookie_allocated=3D1;
 	}
=20
 	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
