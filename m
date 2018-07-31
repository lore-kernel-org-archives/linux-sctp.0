From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:15 +0000
Subject: [PATCH lksctp-tools 7/9] testlib: fix covscan warnings
Message-Id: <e21e5ce66e17c751c03fac2e0f8d6ccbaf996a66.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

free the allocated memory 'found' in testlib/sctputil.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/testlib/sctputil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/testlib/sctputil.c b/src/testlib/sctputil.c
index 714d7a5..24f305a 100644
--- a/src/testlib/sctputil.c
+++ b/src/testlib/sctputil.c
@@ -412,5 +412,6 @@ int test_peer_addr(int sk, sctp_assoc_t asoc, sockaddr_storage_t *peers, int cou
 		}
 	}
 	sctp_freepaddrs(addrs);
+	free(found);
 	return 0;
 }
-- 
2.1.0

