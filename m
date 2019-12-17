From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 17 Dec 2019 00:37:16 +0000
Subject: Re: memory leak in sctp_stream_init
Message-Id: <20191217003716.GC5058@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000f531080599c4073c@google.com>
 <20191216114828.GA20281@hmswarspite.think-freely.org>
 <20191216145638.GB5058@localhost.localdomain>
In-Reply-To: <20191216145638.GB5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Mon, Dec 16, 2019 at 11:56:38AM -0300, Marcelo Ricardo Leitner wrote:
...
> Considering that genradix_prealloc() failure is not fatal, seems the
> fix here is to just ignore the failure in sctp_stream_alloc_out() and
> let genradix try again later on.

Better yet, this fixes it here:

---8<---

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index df60b5ef24cb..e0b01bf912b3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->out);
 		return ret;
+	}
 
 	stream->outcnt = outcnt;
 	return 0;
@@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return 0;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
-	if (ret)
+	if (ret) {
+		genradix_free(&stream->in);
 		return ret;
+	}
 
 	stream->incnt = incnt;
 	return 0;
