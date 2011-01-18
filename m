From: Holger Freyther <zecke@selfish.org>
Date: Tue, 18 Jan 2011 11:29:18 +0000
Subject: [PATCH] sctp: Make some local functions static
Message-Id: <4D35798E.3010800@selfish.org>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------040800010008010807000608"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------040800010008010807000608
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


sparse proposed to mark these functions as static as they are
only accessed locally. This patch is doing that.

Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
---
 net/sctp/probe.c         |   10 +++++-----
 net/sctp/sm_make_chunk.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)



--------------040800010008010807000608
Content-Type: text/x-patch;
 name="0001-sctp-Make-some-local-functions-static.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-sctp-Make-some-local-functions-static.patch"

diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index bc6cd75..4616548 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -122,11 +122,11 @@ static const struct file_operations sctpprobe_fops = {
 	.llseek = noop_llseek,
 };
 
-sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
-				     const struct sctp_association *asoc,
-				     const sctp_subtype_t type,
-				     void *arg,
-				     sctp_cmd_seq_t *commands)
+static sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
+					    const struct sctp_association *asoc,
+					    const sctp_subtype_t type,
+					    void *arg,
+					    sctp_cmd_seq_t *commands)
 {
 	struct sctp_transport *sp;
 	static __u32 lcwnd = 0;
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9ea8ae7..912e534 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -132,8 +132,8 @@ void  sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
  * abort chunk.  Differs from sctp_init_cause in that it won't oops
  * if there isn't enough space in the op error chunk
  */
-int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
-		      size_t paylen)
+static int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
+				 size_t paylen)
 {
 	sctp_errhdr_t err;
 	__u16 len;


--------------040800010008010807000608--
