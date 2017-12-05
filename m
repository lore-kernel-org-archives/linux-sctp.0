From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:00 +0000
Subject: [PATCH net-next 03/12] sctp: add basic structures and make chunk function for idata
Message-Id: <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_idatahdr and sctp_idata_chunk are used to define and parse
I-DATA chunk format, and sctp_make_idata is a function to build
the chunk.

The I-DATA Chunk Format is defined in section 2.1 of RFC8260.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h       | 17 +++++++++++++++++
 include/net/sctp/sm.h      |  2 ++
 include/net/sctp/structs.h |  1 +
 net/sctp/sm_make_chunk.c   |  6 ++++++
 4 files changed, 26 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 6d2bd64..38e2cf6 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -243,6 +243,23 @@ struct sctp_data_chunk {
 	struct sctp_datahdr data_hdr;
 };
 
+struct sctp_idatahdr {
+	__be32 tsn;
+	__be16 stream;
+	__be16 reserved;
+	__be32 mid;
+	union {
+		__u32 ppid;
+		__be32 fsn;
+	};
+	__u8 payload[0];
+};
+
+struct sctp_idata_chunk {
+	struct sctp_chunkhdr chunk_hdr;
+	struct sctp_idatahdr data_hdr;
+};
+
 /* DATA Chuck Specific Flags */
 enum {
 	SCTP_DATA_MIDDLE_FRAG	= 0x00,
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 70fb397..5389ae0 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -197,6 +197,8 @@ struct sctp_chunk *sctp_make_cookie_ack(const struct sctp_association *asoc,
 struct sctp_chunk *sctp_make_cwr(const struct sctp_association *asoc,
 				 const __u32 lowest_tsn,
 				 const struct sctp_chunk *chunk);
+struct sctp_chunk *sctp_make_idata(const struct sctp_association *asoc,
+				   __u8 flags, int paylen, gfp_t gfp);
 struct sctp_chunk *sctp_make_datafrag_empty(struct sctp_association *asoc,
 					    const struct sctp_sndrcvinfo *sinfo,
 					    int len, const __u8 flags,
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index dd2bb62..15183bf 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -574,6 +574,7 @@ struct sctp_chunk {
 		struct sctp_addiphdr *addip_hdr;
 		struct sctp_fwdtsn_hdr *fwdtsn_hdr;
 		struct sctp_authhdr *auth_hdr;
+		struct sctp_idatahdr *idata_hdr;
 	} subh;
 
 	__u8 *chunk_end;
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index da33c85..b969397 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1425,6 +1425,12 @@ static struct sctp_chunk *sctp_make_data(const struct sctp_association *asoc,
 	return _sctp_make_chunk(asoc, SCTP_CID_DATA, flags, paylen, gfp);
 }
 
+struct sctp_chunk *sctp_make_idata(const struct sctp_association *asoc,
+				   __u8 flags, int paylen, gfp_t gfp)
+{
+	return _sctp_make_chunk(asoc, SCTP_CID_I_DATA, flags, paylen, gfp);
+}
+
 static struct sctp_chunk *sctp_make_control(const struct sctp_association *asoc,
 					    __u8 type, __u8 flags, int paylen,
 					    gfp_t gfp)
-- 
2.1.0

