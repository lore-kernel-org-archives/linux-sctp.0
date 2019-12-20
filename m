From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Dec 2019 16:05:59 +0000
Subject: Re: general protection fault in sctp_stream_free (2)
Message-Id: <20191220160559.GD5058@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0000000000001b6443059a1a815d@google.com>
 <20191220152810.GI4444@localhost.localdomain>
In-Reply-To: <20191220152810.GI4444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Fri, Dec 20, 2019 at 12:28:10PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 19, 2019 at 07:45:09PM -0800, syzbot wrote:
> > Hello,
> >=20
> > syzbot found the following crash on:
> >=20
> > HEAD commit:    6fa9a115 Merge branch 'stmmac-fixes'
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10c4fe99e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x!6dca5e1758db87
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9A1bc632e78a1a9=
8488b
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ada71e00=
000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f23a6e00000
> >=20
> > The bug was bisected to:
> >=20
> > commit 951c6db954a1adefab492f6da805decacabbd1a7
> > Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Date:   Tue Dec 17 01:01:16 2019 +0000
> >=20
> >     sctp: fix memleak on err handling of stream initialization
>=20
> Ouch... this wasn't a good fix.
> When called from sctp_stream_init(), it is doing the right thing.
> But when called from sctp_send_add_streams(), it can't free the
> genradix. Ditto from sctp_process_strreset_addstrm_in().

Tentative fix. I'll post after additional tests.

--8<--

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6a30392068a0..c1a100d2fed3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *str=
eam, __u16 outcnt,
 		return 0;
=20
 	ret =3D genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret) {
-		genradix_free(&stream->out);
+	if (ret)
 		return ret;
-	}
=20
 	stream->outcnt =3D outcnt;
 	return 0;
@@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *st=
ream, __u16 incnt,
 		return 0;
=20
 	ret =3D genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret) {
-		genradix_free(&stream->in);
+	if (ret)
 		return ret;
-	}
=20
 	stream->incnt =3D incnt;
 	return 0;
@@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 =
outcnt, __u16 incnt,
 	 * a new one with new outcnt to save memory if needed.
 	 */
 	if (outcnt =3D stream->outcnt)
-		goto in;
+		goto handle_in;
=20
 	/* Filter out chunks queued on streams that won't exist anymore */
 	sched->unsched_all(stream);
@@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u1=
6 outcnt, __u16 incnt,
=20
 	ret =3D sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out;
+		goto out_err;
=20
 	for (i =3D 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state =3D SCTP_STREAM_OPEN;
=20
-in:
+handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
 		goto out;
=20
 	ret =3D sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret) {
-		sched->free(stream);
-		genradix_free(&stream->out);
-		stream->outcnt =3D 0;
-		goto out;
-	}
+	if (ret)
+		goto in_err;
+
+	goto out;
=20
+in_err:
+	sched->free(stream);
+	genradix_free(&stream->in);
+out_err:
+	genradix_free(&stream->out);
+	stream->outcnt =3D 0;
 out:
 	return ret;
 }
