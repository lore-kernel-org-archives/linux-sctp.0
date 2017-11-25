From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:05:36 +0000
Subject: [PATCH net 5/5] sctp: set sender next_tsn for the old result with ctsn_ack_point plus 1
Message-Id: <380acfa72f7260cccf9fc9ffb2db81d4234fd38a.1511614961.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <feb3ee6070cc0f526210fa36752148c0e0704bcf.1511614961.git.lucien.xin@gmail.com>
 <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
 <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
 <01a98a157b28c058568ccb7b9909e990e7ac7744.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <01a98a157b28c058568ccb7b9909e990e7ac7744.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

When doing asoc reset, if the sender of the response has already sent some
chunk and increased asoc->next_tsn before the duplicate request comes, the
response will use the old result with an incorrect sender next_tsn.

Better than asoc->next_tsn, asoc->ctsn_ack_point can't be changed after
the sender of the response has performed the asoc reset and before the
peer has confirmed it, and it's value is still asoc->next_tsn original
value minus 1.

This patch sets sender next_tsn for the old result with ctsn_ack_point
plus 1 when processing the duplicate request, to make sure the sender
next_tsn value peer gets will be always right.

Fixes: 692787cef651 ("sctp: implement receiver-side procedures for the SSN/TSN Reset Request Parameter")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 9dd5bfe..a20145b 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -725,7 +725,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 		i = asoc->strreset_inseq - request_seq - 1;
 		result = asoc->strreset_result[i];
 		if (result = SCTP_STRRESET_PERFORMED) {
-			next_tsn = asoc->next_tsn;
+			next_tsn = asoc->ctsn_ack_point + 1;
 			init_tsn  				sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map) + 1;
 		}
-- 
2.1.0

