From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Dec 2017 16:41:30 +0000
Subject: [PATCHv2 net-next 6/8] sctp: add stream interleave support in stream scheduler
Message-Id: <754ccfd8f4be04136dafa1d86deb8ee812638887.1513269224.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
 <5982a46414cdea7856ee17683c5a714b411c7eb4.1513269224.git.lucien.xin@gmail.com>
 <30a1a95a2943469521de456d050717e1d46711fc.1513269224.git.lucien.xin@gmail.com>
 <d19327abb7e1001da4f9f66e06b3dff94b867b18.1513269224.git.lucien.xin@gmail.com>
 <d001538d3ff8d80ba726b5443675b7eea6ee09f6.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <d001538d3ff8d80ba726b5443675b7eea6ee09f6.1513269224.git.lucien.xin@gmail.com>
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

