From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Wed, 21 Jun 2017 16:28:09 +0000
Subject: [PATCH] net/sctp/ulpevent.c: Deinline sctp_ulpevent_set_owner, save 1616 bytes
Message-Id: <20170621162809.4305-1-dvlasenk@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This function compiles to 147 bytes of machine code. 13 callsites.

I'm no expert on SCTP events, but quick reading of SCTP docs tells me that
SCTP events are not happening on every packet.
They are ASSOC_CHANGE, PEER_ADDR_CHANGE, REMOTE_ERROR and such.
Does not look performance critical.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: David Miller <davem@davemloft.net>
CC: linux-sctp@vger.kernel.org
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 net/sctp/ulpevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index ec2b3e0..049aa5a 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -88,7 +88,7 @@ int sctp_ulpevent_is_notification(const struct sctp_ulpevent *event)
 /* Hold the association in case the msg_name needs read out of
  * the association.
  */
-static inline void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
+static void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
 					   const struct sctp_association *asoc)
 {
 	struct sctp_chunk *chunk = event->chunk;
-- 
1.8.3.1

