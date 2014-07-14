From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 14 Jul 2014 16:36:39 +0000
Subject: [PATCH 16/16] net: sctp: remove unnecessary break after return/goto
Message-Id: <1405355799-7691-7-git-send-email-fabf@skynet.be>
List-Id: <linux-sctp.vger.kernel.org>
References: <1405355799-7691-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1405355799-7691-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/sctp/outqueue.c     | 1 -
 net/sctp/sm_statefuns.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 9c77947..d31435e 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1025,7 +1025,6 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 
 				sctp_outq_head_data(q, chunk);
 				goto sctp_flush_out;
-				break;
 
 			case SCTP_XMIT_OK:
 				/* The sender is in the SHUTDOWN-PENDING state,
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 5170a1f..d3f1ea4 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4182,7 +4182,6 @@ sctp_disposition_t sctp_sf_unk_chunk(struct net *net,
 	case SCTP_CID_ACTION_DISCARD:
 		/* Discard the packet.  */
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-		break;
 	case SCTP_CID_ACTION_DISCARD_ERR:
 		/* Generate an ERROR chunk as response. */
 		hdr = unk_chunk->chunk_hdr;
@@ -4198,11 +4197,9 @@ sctp_disposition_t sctp_sf_unk_chunk(struct net *net,
 		/* Discard the packet.  */
 		sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 		return SCTP_DISPOSITION_CONSUME;
-		break;
 	case SCTP_CID_ACTION_SKIP:
 		/* Skip the chunk.  */
 		return SCTP_DISPOSITION_DISCARD;
-		break;
 	case SCTP_CID_ACTION_SKIP_ERR:
 		/* Generate an ERROR chunk as response. */
 		hdr = unk_chunk->chunk_hdr;
@@ -4216,7 +4213,6 @@ sctp_disposition_t sctp_sf_unk_chunk(struct net *net,
 		}
 		/* Skip the chunk.  */
 		return SCTP_DISPOSITION_CONSUME;
-		break;
 	default:
 		break;
 	}
-- 
1.8.4.5

