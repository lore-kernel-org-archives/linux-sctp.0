From: Vladislav Yasevich <vyasevich@gmail.com>
Date: Mon, 02 Apr 2018 13:40:04 +0000
Subject: [PATCH net-next 3/5] sctp: Build sctp offload support into the base kernel
Message-Id: <20180402134006.10111-4-vyasevic@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-1-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

We need to take the sctp offload out of the sctp module
and add it to the base kernel to support guests that can
support it.  This is similar to how IPv6 offloads are done
and works around kernels that exclude sctp protocol support.

Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
---
 include/net/sctp/sctp.h | 5 -----
 net/Kconfig             | 1 +
 net/sctp/Kconfig        | 1 -
 net/sctp/Makefile       | 3 ++-
 net/sctp/offload.c      | 4 +++-
 net/sctp/protocol.c     | 3 ---
 6 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 72c5b8f..625b45f 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -183,11 +183,6 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
 int __net_init sctp_proc_init(struct net *net);
 
 /*
- * sctp/offload.c
- */
-int sctp_offload_init(void);
-
-/*
  * sctp/stream_sched.c
  */
 void sctp_sched_ops_init(void);
diff --git a/net/Kconfig b/net/Kconfig
index 0428f12..2773f98 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -64,6 +64,7 @@ config INET
 	bool "TCP/IP networking"
 	select CRYPTO
 	select CRYPTO_AES
+	select LIBCRC32C
 	---help---
 	  These are the protocols used on the Internet and on most local
 	  Ethernets. It is highly recommended to say Y here (this will enlarge
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index c740b18..d07477a 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -9,7 +9,6 @@ menuconfig IP_SCTP
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
-	select LIBCRC32C
 	---help---
 	  Stream Control Transmission Protocol
 
diff --git a/net/sctp/Makefile b/net/sctp/Makefile
index e845e45..ee206ca 100644
--- a/net/sctp/Makefile
+++ b/net/sctp/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_IP_SCTP) += sctp.o
 obj-$(CONFIG_INET_SCTP_DIAG) += sctp_diag.o
+obj-$(CONFIG_INET) += offload.o
 
 sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  protocol.o endpointola.o associola.o \
@@ -12,7 +13,7 @@ sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  inqueue.o outqueue.o ulpqueue.o \
 	  tsnmap.o bind_addr.o socket.o primitive.o \
 	  output.o input.o debug.o stream.o auth.o \
-	  offload.o stream_sched.o stream_sched_prio.o \
+	  stream_sched.o stream_sched_prio.o \
 	  stream_sched_rr.o stream_interleave.o
 
 sctp_diag-y := diag.o
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 123e9f2..c61cbde 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -107,7 +107,7 @@ static const struct skb_checksum_ops crc32c_csum_ops = {
 	.combine = sctp_csum_combine,
 };
 
-int __init sctp_offload_init(void)
+static int __init sctp_offload_init(void)
 {
 	int ret;
 
@@ -127,3 +127,5 @@ int __init sctp_offload_init(void)
 out:
 	return ret;
 }
+
+fs_initcall(sctp_offload_init);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a24cde2..46d2b63 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1479,9 +1479,6 @@ static __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;
 
-	if (sctp_offload_init() < 0)
-		pr_crit("%s: Cannot add SCTP protocol offload\n", __func__);
-
 out:
 	return status;
 err_v6_add_protocol:
-- 
2.9.5

