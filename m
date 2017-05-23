From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 May 2017 05:28:54 +0000
Subject: [PATCH net 1/2] sctp: fix stream update when processing dupcookie
Message-Id: <132661a3448bf87e944c07860305d979bc4d5518.1495517205.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1495517205.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1495517205.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Since commit 3dbcc105d556 ("sctp: alloc stream info when initializing
asoc"), stream and stream.out info are always alloced when creating
an asoc.

So it's not correct to check !asoc->stream before updating stream
info when processing dupcookie, but would be better to check asoc
state instead.

Fixes: 3dbcc105d556 ("sctp: alloc stream info when initializing asoc")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a9708da..9523828 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1176,7 +1176,9 @@ void sctp_assoc_update(struct sctp_association *asoc,
 
 		asoc->ctsn_ack_point = asoc->next_tsn - 1;
 		asoc->adv_peer_ack_point = asoc->ctsn_ack_point;
-		if (!asoc->stream) {
+
+		if (sctp_state(asoc, COOKIE_WAIT)) {
+			sctp_stream_free(asoc->stream);
 			asoc->stream = new->stream;
 			new->stream = NULL;
 		}
-- 
2.1.0

