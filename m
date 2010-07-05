From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 09:17:51 +0000
Subject: [PATCH] sctp: Increase the counter value of SctpInDataChunkDiscards
Message-Id: <4C31A33F.4090309@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


The commit ac0b04627269ff16c3c7ab854a65fe6780c6e3e5 has added
an item of SctpInDataChunkDiscards for tracing discarded DATA chunk
with high tsn, bad stream or dup tsn at ESTABLISHED state.

But at SHUTDOWN-SENT state, this kind of discarded DATA chunk
can't be traced. So increase the counter value of SctpInDataChunkDiscards
for them.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..1937f0b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3006,10 +3006,12 @@ sctp_disposition_t sctp_sf_eat_data_fast_4_4(const struct sctp_endpoint *ep,
 	error = sctp_eat_data(asoc, chunk, commands );
 	switch (error) {
 	case SCTP_IERROR_NO_ERROR:
+		break;
 	case SCTP_IERROR_HIGH_TSN:
 	case SCTP_IERROR_DUP_TSN:
 	case SCTP_IERROR_IGNORE_TSN:
 	case SCTP_IERROR_BAD_STREAM:
+		SCTP_INC_STATS(SCTP_MIB_IN_DATA_CHUNK_DISCARDS);
 		break;
 	case SCTP_IERROR_NO_DATA:
 		goto consume;
-- 
1.6.3.3
