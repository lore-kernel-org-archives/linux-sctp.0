From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 12:16:07 +0000
Subject: [PATCH net 2/3] sctp: force the params with right types for sctp csum apis
Message-Id: <b6a18a03feb2b815d75482e266cb5e4603bb8132.1511698478.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511698478.git.lucien.xin@gmail.com>
 <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
In-Reply-To: <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Now sctp_csum_xxx doesn't really match the param types of these common
csum apis. As sctp_csum_xxx is defined in sctp/checksum.h, many sparse
errors occur when make C=2 not only with M=net/sctp but also with other
modules that include this header file.

This patch is to force them fit in csum apis with the right types.

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/checksum.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index 4a5b9a3..32ee65a 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -48,31 +48,32 @@ static inline __wsum sctp_csum_update(const void *buff, int len, __wsum sum)
 	/* This uses the crypto implementation of crc32c, which is either
 	 * implemented w/ hardware support or resolves to __crc32c_le().
 	 */
-	return crc32c(sum, buff, len);
+	return (__force __wsum)crc32c((__force __u32)sum, buff, len);
 }
 
 static inline __wsum sctp_csum_combine(__wsum csum, __wsum csum2,
 				       int offset, int len)
 {
-	return __crc32c_le_combine(csum, csum2, len);
+	return (__force __wsum)__crc32c_le_combine((__force __u32)csum,
+						   (__force __u32)csum2, len);
 }
 
 static inline __le32 sctp_compute_cksum(const struct sk_buff *skb,
 					unsigned int offset)
 {
 	struct sctphdr *sh = sctp_hdr(skb);
-        __le32 ret, old = sh->checksum;
 	const struct skb_checksum_ops ops = {
 		.update  = sctp_csum_update,
 		.combine = sctp_csum_combine,
 	};
+	__le32 old = sh->checksum;
+	__wsum new;
 
 	sh->checksum = 0;
-	ret = cpu_to_le32(~__skb_checksum(skb, offset, skb->len - offset,
-					  ~(__u32)0, &ops));
+	new = ~__skb_checksum(skb, offset, skb->len - offset, ~(__wsum)0, &ops);
 	sh->checksum = old;
 
-	return ret;
+	return cpu_to_le32((__force __u32)new);
 }
 
 #endif /* __sctp_checksum_h__ */
-- 
2.1.0

