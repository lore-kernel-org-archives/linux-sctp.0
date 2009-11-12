From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Thu, 12 Nov 2009 15:50:14 +0000
Subject: [PATCH 2/3] sctp: fix integer overflow when setting the autoclose timer
Message-Id: <20091112155014.GO10897@shell.iptel.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When setting the autoclose timeout in jiffies there is a possible
integer overflow if the value in seconds is very large
(e.g. for 2^22 s with HZ24). The problem appears even on
64-bit due to the integer promotion rules. The fix is just a cast
 to unsigned long.

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 net/sctp/associola.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 525864b..7f69f4d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -166,7 +166,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_HEARTBEAT] = 0;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] -		sp->autoclose * HZ;
+		(unsigned long)sp->autoclose * HZ;
 
 	/* Initilizes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)
-- 
1.6.5.2

