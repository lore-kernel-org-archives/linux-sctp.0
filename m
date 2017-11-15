From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 15 Nov 2017 09:00:11 +0000
Subject: [PATCHv2 net] sctp: check stream reset info len before making reconf chunk
Message-Id: <49f43731ffc66c5da5eb3ee3e365d12a0e1fe8cb.1510736411.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com

Now when resetting stream, if both in and out flags are set, the info
len can reach:
  sizeof(struct sctp_strreset_outreq) + SCTP_MAX_STREAM(65535) +
  sizeof(struct sctp_strreset_inreq)  + SCTP_MAX_STREAM(65535)
even without duplicated stream no, this value is far greater than the
chunk's max size.

_sctp_make_chunk doesn't do any check for this, which would cause the
skb it allocs is huge, syzbot even reported a crash due to this.

This patch is to check stream reset info len before making reconf
chunk and return EINVAL if the len exceeds chunk's capacity.

Thanks Marcelo and Neil for making this clear.

v1->v2:
  - move the check into sctp_send_reset_streams instead.

Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_make_chunk.c |  2 +-
 net/sctp/stream.c        | 32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 514465b..9bf575f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3594,8 +3594,8 @@ struct sctp_chunk *sctp_make_strreset_req(
 					__u16 stream_num, __be16 *stream_list,
 					bool out, bool in)
 {
+	__u16 stream_len = stream_num * sizeof(__u16);
 	struct sctp_strreset_outreq outreq;
-	__u16 stream_len = stream_num * 2;
 	struct sctp_strreset_inreq inreq;
 	struct sctp_chunk *retval;
 	__u16 outlen, inlen;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index fa8371f..e443768 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -139,15 +139,31 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 
 	str_nums = params->srs_number_streams;
 	str_list = params->srs_stream_list;
-	if (out && str_nums)
-		for (i = 0; i < str_nums; i++)
-			if (str_list[i] >= stream->outcnt)
-				goto out;
+	if (str_nums) {
+		int param_len = 0;
 
-	if (in && str_nums)
-		for (i = 0; i < str_nums; i++)
-			if (str_list[i] >= stream->incnt)
-				goto out;
+		if (out) {
+			for (i = 0; i < str_nums; i++)
+				if (str_list[i] >= stream->outcnt)
+					goto out;
+
+			param_len = str_nums * sizeof(__u16) +
+				    sizeof(struct sctp_strreset_outreq);
+		}
+
+		if (in) {
+			for (i = 0; i < str_nums; i++)
+				if (str_list[i] >= stream->incnt)
+					goto out;
+
+			param_len += str_nums * sizeof(__u16) +
+				     sizeof(struct sctp_strreset_inreq);
+		}
+
+		if (param_len > SCTP_MAX_CHUNK_LEN -
+				sizeof(struct sctp_reconf_chunk))
+			goto out;
+	}
 
 	nstr_list = kcalloc(str_nums, sizeof(__be16), GFP_KERNEL);
 	if (!nstr_list) {
-- 
2.1.0

