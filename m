From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 24 Nov 2008 05:51:02 +0000
Subject: sctp: Avoid memory overflow while FWD-TSN chunk is received with
Message-Id: <492A40C6.5010005@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If FWD-TSN chunk is received with bad stream ID, the sctp will not do the
validity check, this may cause memory overflow when overwrite the TSN of
the stream ID.

The FORWARD-TSN chunk is like this:

FORWARD-TSN chunk
  Type                       = 192
  Flags                      = 0
  Length                     = 172
  NewTSN                     = 99
  Stream                     = 10000
  StreamSequence             = 0xFFFF

This patch fix this problem by skip the stream ID which not less than MIS.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/ulpqueue.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 7b23803..dacdc3b 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -940,7 +940,10 @@ void sctp_ulpq_skip(struct sctp_ulpq *ulpq, __u16 sid, __u16 ssn)
 {
 	struct sctp_stream *in;
 
-	/* Note: The stream ID must be verified before this routine.  */
+	/* Skip the stream ID which larger than MIS */
+	if (sid >= ulpq->asoc->c.sinit_max_instreams)
+		return;
+
 	in  = &ulpq->asoc->ssnmap->in;
 
 	/* Is this an old SSN?  If so ignore. */
-- 
1.6.0.2.530.g67faa



