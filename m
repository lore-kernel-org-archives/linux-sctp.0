From: Krzysztof Grzywocz <kgrzywocz@wp.pl>
Date: Tue, 09 Oct 2018 04:45:05 +0000
Subject: [PATCH v2 1/1] sctp: fix align sctp_assoc_stats to run on x86_64 in compat IA32
Message-Id: <D54ABB61-F55D-4CE5-8A31-4BBD255B807C@wp.pl>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Krzysztof Grzywocz <kgrzywocz@wp.pl>

Problem:
On 64bit kernel ELF32bit gets improper value of `SCTP_GET_ASSOC_STATS` (call `getsockopt` on SCTP socket) due to different `struct sctp_assoc_stats` aligment (mostly because of different `_K_SS_ALIGNSIZE`).

Example:
Sent 1000 bytes, Received 1000 bytes
May result in: 
packets sent(sas_opackets): 12884901888
packets recv(sas_ipackets): 12884901888

Patch solution:
Realign struct at the end of `sctp_getsockopt_assoc_stats(..)` when called in compat mode see patch for details.

For detail see: https://github.com/kgrzywocz/align_compat32_sctp_assoc_stats

Signed-off-by: Krzysztof Grzywocz <kgrzywocz@wp.pl>

-----
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ce620e87..4e3f920f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6685,6 +6685,59 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+
+struct __kernel_sockaddr_storage_compat32 {
+	__kernel_sa_family_t	ss_family;
+	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+} __attribute__ ((packed,aligned(4)));	/* force desired alignment */
+
+struct sctp_assoc_stats_compat32 {
+	int32_t	sas_assoc_id;
+	struct __kernel_sockaddr_storage_compat32 sas_obs_rto_ipaddr;
+	uint64_t sas_maxrto;
+	uint64_t sas_isacks;
+	uint64_t sas_osacks;
+	uint64_t sas_opackets;
+	uint64_t sas_ipackets;
+	uint64_t sas_rtxchunks;
+	uint64_t sas_outofseqtsns;
+	uint64_t sas_idupchunks;
+	uint64_t sas_gapcnt;
+	uint64_t sas_ouodchunks;
+	uint64_t sas_iuodchunks;
+	uint64_t sas_oodchunks;
+	uint64_t sas_iodchunks;
+	uint64_t sas_octrlchunks;
+	uint64_t sas_ictrlchunks;
+} __attribute__ ((packed,aligned(4)));
+
+static void align_compat32_sctp_assoc_stats(void *sctp_assoc_stats)
+{
+	struct sctp_assoc_stats* p64 = sctp_assoc_stats;
+	struct sctp_assoc_stats_compat32* p32 = sctp_assoc_stats;
+
+	p32->sas_assoc_id = p64->sas_assoc_id;
+	p32->sas_obs_rto_ipaddr.ss_family = p64->sas_obs_rto_ipaddr.ss_family;
+	memcpy(p32->sas_obs_rto_ipaddr.__data, p64->sas_obs_rto_ipaddr.__data, sizeof(p32->sas_obs_rto_ipaddr.__data));
+	p32->sas_maxrto = p64->sas_maxrto;
+	p32->sas_isacks = p64->sas_isacks;
+	p32->sas_osacks = p64->sas_osacks;
+	p32->sas_opackets = p64->sas_opackets;
+	p32->sas_ipackets = p64->sas_ipackets;
+	p32->sas_rtxchunks = p64->sas_rtxchunks;
+	p32->sas_outofseqtsns = p64->sas_outofseqtsns;
+	p32->sas_idupchunks = p64->sas_idupchunks;
+	p32->sas_gapcnt = p64->sas_gapcnt;
+	p32->sas_ouodchunks = p64->sas_ouodchunks;
+	p32->sas_iuodchunks = p64->sas_iuodchunks;
+	p32->sas_oodchunks = p64->sas_oodchunks;
+	p32->sas_iodchunks = p64->sas_iodchunks;
+	p32->sas_octrlchunks = p64->sas_octrlchunks;
+	p32->sas_ictrlchunks = p64->sas_ictrlchunks;
+}
+#endif
+
 /*
  * SCTP_GET_ASSOC_STATS
  *
@@ -6743,6 +6796,13 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 
 	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
 
+#ifdef CONFIG_COMPAT
+	if (in_compat_syscall()) {
+		pr_debug("%s: Aligning sctp_assoc_stats for 32bit compat\n", __func__);
+		align_compat32_sctp_assoc_stats(&sas);
+	}
+#endif
+
 	if (copy_to_user(optval, &sas, len))
 		return -EFAULT;
 
