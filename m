From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:05:34 +0000
Subject: [PATCH net 3/5] sctp: only allow the asoc reset when the asoc outq is empty
Message-Id: <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <feb3ee6070cc0f526210fa36752148c0e0704bcf.1511614961.git.lucien.xin@gmail.com>
 <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

As it says in rfc6525#section5.1.4, before sending the request,

   C2:  The sender has either no outstanding TSNs or considers all
        outstanding TSNs abandoned.

Prior to this patch, it tried to consider all outstanding TSNs abandoned
by dropping all chunks in all outqs with sctp_outq_free (even including
sacked, retransmit and transmitted queues) when doing this reset, which
is too aggressive.

To make it work gently, this patch will only allow the asoc reset when
the sender has no outstanding TSNs by checking if unsent, transmitted
and retransmit are all empty with sctp_outq_is_empty before sending
and processing the request.

Fixes: 692787cef651 ("sctp: implement receiver-side procedures for the SSN/TSN Reset Request Parameter")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index b209037..f3b7d27 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -406,6 +406,9 @@ int sctp_send_reset_assoc(struct sctp_association *asoc)
 	if (asoc->strreset_outstanding)
 		return -EINPROGRESS;
 
+	if (!sctp_outq_is_empty(&asoc->outqueue))
+		return -EAGAIN;
+
 	chunk = sctp_make_strreset_tsnreq(asoc);
 	if (!chunk)
 		return -ENOMEM;
@@ -728,6 +731,12 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 		}
 		goto err;
 	}
+
+	if (!sctp_outq_is_empty(&asoc->outqueue)) {
+		result = SCTP_STRRESET_IN_PROGRESS;
+		goto err;
+	}
+
 	asoc->strreset_inseq++;
 
 	if (!(asoc->strreset_enable & SCTP_ENABLE_RESET_ASSOC_REQ))
-- 
2.1.0

