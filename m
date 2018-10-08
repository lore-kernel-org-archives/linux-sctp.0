From: Krzysztof Grzywocz <kgrzywocz@wp.pl>
Date: Mon, 08 Oct 2018 19:07:24 +0000
Subject: [PATCH 1/1] sctp: fix align sctp_assoc_stats to run on x86_64 in compat IA32
Message-Id: <C23DDB3F-AE59-49F1-9B45-4205B61668E4@wp.pl>
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
Realign struct at the end of `sctp_getsockopt_assoc_stats(..)` when called in compat mode. See patch for details.

For more details see: https://github.com/kgrzywocz/align_compat32_sctp_assoc_stats


-----
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ce620e87..73963062 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6685,6 +6685,65 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+
+struct __kernel_sockaddr_storage_compat32 {
+	__kernel_sa_family_t	ss_family;		/* address family */
+	/* Following field(s) are implementation specific */
+	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+				/* space to achieve desired size, */
+				/* _SS_MAXSIZE value minus size of ss_family */
+} __attribute__ ((packed,aligned(4)));	/* force desired alignment */
+
+
+struct sctp_assoc_stats_compat32 {
+	int32_t	sas_assoc_id;    /* Input */
+					 /* Transport of observed max RTO */
+	struct __kernel_sockaddr_storage_compat32 sas_obs_rto_ipaddr;
+	uint64_t		sas_maxrto;      /* Maximum Observed RTO for period */
+	uint64_t		sas_isacks;	 /* SACKs received */
+	uint64_t		sas_osacks;	 /* SACKs sent */
+	uint64_t		sas_opackets;	 /* Packets sent */
+	uint64_t		sas_ipackets;	 /* Packets received */
+	uint64_t		sas_rtxchunks;   /* Retransmitted Chunks */
+	uint64_t		sas_outofseqtsns;/* TSN received > next expected */
+	uint64_t		sas_idupchunks;  /* Dups received (ordered+unordered) */
+	uint64_t		sas_gapcnt;      /* Gap Acknowledgements Received */
+	uint64_t		sas_ouodchunks;  /* Unordered data chunks sent */
+	uint64_t		sas_iuodchunks;  /* Unordered data chunks received */
+	uint64_t		sas_oodchunks;	 /* Ordered data chunks sent */
+	uint64_t		sas_iodchunks;	 /* Ordered data chunks received */
+	uint64_t		sas_octrlchunks; /* Control chunks sent */
+	uint64_t		sas_ictrlchunks; /* Control chunks received */
+} __attribute__ ((packed,aligned(4)));
+
+
+static void align_compat32_sctp_assoc_stats(void *sctp_assoc_stats)
+{
+	struct sctp_assoc_stats* p64 = sctp_assoc_stats;
+	struct sctp_assoc_stats_compat32* p32 = sctp_assoc_stats;
+
+	p32->sas_assoc_id   				= p64->sas_assoc_id;
+	p32->sas_obs_rto_ipaddr.ss_family   = p64->sas_obs_rto_ipaddr.ss_family;
+	memcpy(p32->sas_obs_rto_ipaddr.__data, p64->sas_obs_rto_ipaddr.__data, sizeof(p32->sas_obs_rto_ipaddr.__data));
+	p32->sas_maxrto		  				= p64->sas_maxrto;
+	p32->sas_isacks  					= p64->sas_isacks;
+	p32->sas_osacks  					= p64->sas_osacks;
+	p32->sas_opackets  					= p64->sas_opackets;
+	p32->sas_ipackets  					= p64->sas_ipackets;
+	p32->sas_rtxchunks  				= p64->sas_rtxchunks;
+	p32->sas_outofseqtsns  				= p64->sas_outofseqtsns;
+	p32->sas_idupchunks  				= p64->sas_idupchunks;
+	p32->sas_gapcnt   					= p64->sas_gapcnt;
+	p32->sas_ouodchunks   				= p64->sas_ouodchunks;
+	p32->sas_iuodchunks   				= p64->sas_iuodchunks;
+	p32->sas_oodchunks   				= p64->sas_oodchunks;
+	p32->sas_iodchunks   				= p64->sas_iodchunks;
+	p32->sas_octrlchunks   				= p64->sas_octrlchunks;
+	p32->sas_ictrlchunks   				= p64->sas_ictrlchunks;
+}
+#endif
+
 /*
  * SCTP_GET_ASSOC_STATS
  *
@@ -6743,6 +6802,13 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 
 	pr_debug("%s: len:%d, assoc_id:%d\n", __func__, len, sas.sas_assoc_id);
 
+	#ifdef CONFIG_COMPAT
+	if (in_compat_syscall()) {
+		pr_debug("%s:running in compat32. Aligningsctp_assoc_stats\n", __func__);
+		align_compat32_sctp_assoc_stats(&sas);
+	}
+	#endif
+
 	if (copy_to_user(optval, &sas, len))
 		return -EFAULT;
 
