From: =?UTF-8?q?S=C3=A9bastien=20Barr=C3=A9?=  <sebastien.barre@uclouvain.be>
Date: Tue, 21 Oct 2014 13:26:15 +0000
Subject: [PATCH net-next] Removed unused function sctp_addr_is_valid()
Message-Id: <1413897975-6066-1-git-send-email-sebastien.barre@uclouvain.be>
List-Id: <linux-sctp.vger.kernel.org>
References: <1413037764-12165-1-git-send-email-sebastien.barre@uclouvain.be>
In-Reply-To: <1413037764-12165-1-git-send-email-sebastien.barre@uclouvain.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "David S. Miller" <davem@davemloft.net>
Cc: =?UTF-8?q?S=C3=A9bastien=20Barr=C3=A9?= <sebastien.barre@uclouvain.be>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

sctp_addr_is_valid() only appeared in its definition.

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Sébastien Barré <sebastien.barre@uclouvain.be>

---

Note: originally sent on linux-sctp (11/10/2014, 16:29).
Sorry, I should probably have sent immediately to you and netdev as well.
Neil Horman had acked the patch, so I included
the ack here.

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
tg: (61ed53d..) net-next/removed-unused-sctp-function (depends on: net-next/master)
