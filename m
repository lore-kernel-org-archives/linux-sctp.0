From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 28 Sep 2017 20:25:18 +0000
Subject: [PATCH net-next 05/10] sctp: introduce sctp_chunk_stream_no
Message-Id: <0dd42e7d58493629797cdf69528090c8e5852b27.1506536044.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1506536044.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1506536044.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>, David Laight <David.Laight@ACULAB.COM>

Add a helper to fetch the stream number from a given chunk.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/structs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 9b2b30b3ba4dfd10c24c3e06ed80779180a06baf..c48f7999fe9b80c5b5e41910a3608059b94140a7 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -642,6 +642,11 @@ void sctp_init_addrs(struct sctp_chunk *, union sctp_addr *,
 		     union sctp_addr *);
 const union sctp_addr *sctp_source(const struct sctp_chunk *chunk);
 
+static inline __u16 sctp_chunk_stream_no(struct sctp_chunk *ch)
+{
+	return ntohs(ch->subh.data_hdr->stream);
+}
+
 enum {
 	SCTP_ADDR_NEW,		/* new address added to assoc/ep */
 	SCTP_ADDR_SRC,		/* address can be used as source */
-- 
2.13.5

