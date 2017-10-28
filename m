From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 28 Oct 2017 11:43:56 +0000
Subject: [PATCH net 3/4] sctp: fix a type cast warnings that causes a_rwnd gets the wrong value
Message-Id: <3d8cee6216e261609ec6307fc17fd6f5d6d28e5f.1509190967.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1509190967.git.lucien.xin@gmail.com>
 <d85747d7d1af0972a00b8d4594a84f2afe97aac8.1509190967.git.lucien.xin@gmail.com>
 <ddda2f5b5825a379793ac6f2ffff4c7ab9aa64e5.1509190967.git.lucien.xin@gmail.com>
In-Reply-To: <ddda2f5b5825a379793ac6f2ffff4c7ab9aa64e5.1509190967.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

These warnings were found by running 'make C=2 M=net/sctp/'.

Commit d4d6fb5787a6 ("sctp: Try not to change a_rwnd when faking a
SACK from SHUTDOWN.") expected to use the peers old rwnd and add
our flight size to the a_rwnd. But with the wrong Endian, it may
not work as well as expected.

So fix it by converting to the right value.

Fixes: d4d6fb5787a6 ("sctp: Try not to change a_rwnd when faking a SACK from SHUTDOWN.")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index e6a2974..8f2762b 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1680,8 +1680,8 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 		case SCTP_CMD_PROCESS_CTSN:
 			/* Dummy up a SACK for processing. */
 			sackh.cum_tsn_ack = cmd->obj.be32;
-			sackh.a_rwnd = asoc->peer.rwnd +
-					asoc->outqueue.outstanding_bytes;
+			sackh.a_rwnd = htonl(asoc->peer.rwnd +
+					     asoc->outqueue.outstanding_bytes);
 			sackh.num_gap_ack_blocks = 0;
 			sackh.num_dup_tsns = 0;
 			chunk->subh.sack_hdr = &sackh;
-- 
2.1.0

