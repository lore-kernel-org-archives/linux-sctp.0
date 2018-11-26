From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Nov 2018 09:02:11 +0000
Subject: [PATCH net] sctp: update frag_point when stream_interleave is set
Message-Id: <9d006cb7fe16d32e2cbacfaddb9c9f4b48aa2755.1543222931.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Jakub Audykowicz <jakub.audykowicz@gmail.com>

sctp_assoc_update_frag_point() should be called whenever asoc->pathmtu
changes, but we missed one place in sctp_association_init(). It would
cause frag_point is zero when sending data.

As says in Jakub's reproducer, if sp->pathmtu is set by socketopt, the
new asoc->pathmtu inherits it in sctp_association_init(). Later when
transports are added and their pmtu >= asoc->pathmtu, it will never
call sctp_assoc_update_frag_point() to set frag_point.

This patch is to fix it by updating frag_point when stream_interleave
is set in sctp_stream_interleave_init(), which is also called in
sctp_association_init(). We're doing this also because frag_point
is affected by datachunk's type, namely stream_interleave_0/1.

Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
Reported-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream_interleave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 0a78cdf..19d596d 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1327,4 +1327,5 @@ void sctp_stream_interleave_init(struct sctp_stream *stream)
 	asoc = container_of(stream, struct sctp_association, stream);
 	stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
 				       : &sctp_stream_interleave_0;
+	sctp_assoc_update_frag_point(asoc);
 }
-- 
2.1.0
