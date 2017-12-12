From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 09:25:57 +0000
Subject: [PATCH net-next 6/8] sctp: add stream interleave support in stream scheduler
Message-Id: <7a112fb936709ef7047548f778a895a46c31a935.1513070662.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com>
 <9b8315277069d021d8a6b581b7304af624a45c61.1513070662.git.lucien.xin@gmail.com>
 <dbe7bd0f6197086a6a4b4d28f0d63ee1073414e8.1513070662.git.lucien.xin@gmail.com>
 <807b1707f79b11d5883d71ea771e98e8f7af3ead.1513070662.git.lucien.xin@gmail.com>
 <5bdf9baf00c367ec91c1e06986be77835be7e451.1513070662.git.lucien.xin@gmail.com>
 <e4f468dc21292382de70c85f8e40272b37154ce0.1513070662.git.lucien.xin@gmail.com>
In-Reply-To: <e4f468dc21292382de70c85f8e40272b37154ce0.1513070662.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

As Marcelo said in the stream scheduler patch:

  Support for I-DATA chunks, also described in RFC8260, with user message
  interleaving is straightforward as it just requires the schedulers to
  probe for the feature and ignore datamsg boundaries when dequeueing.

All needs to do is just to ignore datamsg boundaries when dequeueing.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream_sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index d8c162a..f5fcd42 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -242,7 +242,8 @@ int sctp_sched_get_value(struct sctp_association *asoc, __u16 sid,
 
 void sctp_sched_dequeue_done(struct sctp_outq *q, struct sctp_chunk *ch)
 {
-	if (!list_is_last(&ch->frag_list, &ch->msg->chunks)) {
+	if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
+	    !q->asoc->intl_enable) {
 		struct sctp_stream_out *sout;
 		__u16 sid;
 
-- 
2.1.0

