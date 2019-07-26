From: Qian Cai <cai@lca.pw>
Date: Fri, 26 Jul 2019 20:57:39 +0000
Subject: [PATCH] net/sctp: fix GCC8+ -Wpacked-not-aligned warnings
Message-Id: <1564174659-21211-1-git-send-email-cai@lca.pw>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

There are a lot of those warnings with GCC8+ 64bit,

In file included from ./include/linux/sctp.h:42,
                 from net/core/skbuff.c:47:
./include/uapi/linux/sctp.h:395:1: warning: alignment 4 of 'struct
sctp_paddr_change' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:728:1: warning: alignment 4 of 'struct
sctp_setpeerprim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:727:26: warning: 'sspp_addr' offset 4 in
'struct sctp_setpeerprim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage sspp_addr;
                          ^~~~~~~~~
./include/uapi/linux/sctp.h:741:1: warning: alignment 4 of 'struct
sctp_prim' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:740:26: warning: 'ssp_addr' offset 4 in
'struct sctp_prim' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage ssp_addr;
                          ^~~~~~~~
./include/uapi/linux/sctp.h:792:1: warning: alignment 4 of 'struct
sctp_paddrparams' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:784:26: warning: 'spp_address' offset 4 in
'struct sctp_paddrparams' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spp_address;
                          ^~~~~~~~~~~
./include/uapi/linux/sctp.h:905:1: warning: alignment 4 of 'struct
sctp_paddrinfo' is less than 8 [-Wpacked-not-aligned]
 } __attribute__((packed, aligned(4)));
 ^
./include/uapi/linux/sctp.h:899:26: warning: 'spinfo_address' offset 4
in 'struct sctp_paddrinfo' isn't aligned to 8 [-Wpacked-not-aligned]
  struct sockaddr_storage spinfo_address;
                          ^~~~~~~~~~~~~~
Fix them by aligning the structures and fields to 8 bytes instead.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 include/uapi/linux/sctp.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b8f2c4d56532..e7bd71cde882 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -392,7 +392,7 @@ struct sctp_paddr_change {
 	int spc_state;
 	int spc_error;
 	sctp_assoc_t spc_assoc_id;
-} __attribute__((packed, aligned(4)));
+} __attribute__((packed, aligned(8)));
 
 /*
  *    spc_state:  32 bits (signed integer)
@@ -724,8 +724,8 @@ struct sctp_assocparams {
  */
 struct sctp_setpeerprim {
 	sctp_assoc_t            sspp_assoc_id;
-	struct sockaddr_storage sspp_addr;
-} __attribute__((packed, aligned(4)));
+	struct sockaddr_storage sspp_addr __attribute__((aligned(8)));
+} __attribute__((packed, aligned(8)));
 
 /*
  * 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
@@ -737,8 +737,8 @@ struct sctp_setpeerprim {
  */
 struct sctp_prim {
 	sctp_assoc_t            ssp_assoc_id;
-	struct sockaddr_storage ssp_addr;
-} __attribute__((packed, aligned(4)));
+	struct sockaddr_storage ssp_addr __attribute__((aligned(8)));
+} __attribute__((packed, aligned(8)));
 
 /* For backward compatibility use, define the old name too */
 #define sctp_setprim	sctp_prim
@@ -781,7 +781,7 @@ enum  sctp_spp_flags {
 
 struct sctp_paddrparams {
 	sctp_assoc_t		spp_assoc_id;
-	struct sockaddr_storage	spp_address;
+	struct sockaddr_storage	spp_address __attribute__((aligned(8)));
 	__u32			spp_hbinterval;
 	__u16			spp_pathmaxrxt;
 	__u32			spp_pathmtu;
@@ -789,7 +789,7 @@ struct sctp_paddrparams {
 	__u32			spp_flags;
 	__u32			spp_ipv6_flowlabel;
 	__u8			spp_dscp;
-} __attribute__((packed, aligned(4)));
+} __attribute__((packed, aligned(8)));
 
 /*
  * 7.1.18.  Add a chunk that must be authenticated (SCTP_AUTH_CHUNK)
@@ -896,13 +896,13 @@ struct sctp_stream_value {
  */
 struct sctp_paddrinfo {
 	sctp_assoc_t		spinfo_assoc_id;
-	struct sockaddr_storage	spinfo_address;
+	struct sockaddr_storage	spinfo_address __attribute__((aligned(8)));
 	__s32			spinfo_state;
 	__u32			spinfo_cwnd;
 	__u32			spinfo_srtt;
 	__u32			spinfo_rto;
 	__u32			spinfo_mtu;
-} __attribute__((packed, aligned(4)));
+} __attribute__((packed, aligned(8)));
 
 /* Peer addresses's state. */
 /* UNKNOWN: Peer address passed by the upper layer in sendmsg or connect[x]
-- 
1.8.3.1
