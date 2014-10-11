From: =?UTF-8?q?S=C3=A9bastien=20Barr=C3=A9?=  <sebastien.barre@uclouvain.be>
Date: Sat, 11 Oct 2014 14:29:24 +0000
Subject: [PATCH net-next] Removed unused function sctp_addr_is_valid()
Message-Id: <1413037764-12165-1-git-send-email-sebastien.barre@uclouvain.be>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

sctp_addr_is_valid() only appeared in its definition.

Signed-off-by: Sébastien Barré <sebastien.barre@uclouvain.be>

---
 include/net/sctp/structs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 4ff3f67..806e3b5 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1116,7 +1116,6 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw, int len,
 sctp_scope_t sctp_scope(const union sctp_addr *);
 int sctp_in_scope(struct net *net, const union sctp_addr *addr, const sctp_scope_t scope);
 int sctp_is_any(struct sock *sk, const union sctp_addr *addr);
-int sctp_addr_is_valid(const union sctp_addr *addr);
 int sctp_is_ep_boundall(struct sock *sk);
 
 
-- 
tg: (64b1f00..) net-next/removed-unused-sctp-function (depends on: net-next/master)
