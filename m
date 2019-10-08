From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:27:34 +0000
Subject: [PATCH net-next 2/4] sctp: add SCTP_ADDR_REMOVED event
Message-Id: <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_ulpevent_nofity_peer_addr_change() is called in
sctp_assoc_rm_peer() to send SCTP_ADDR_REMOVED event
when this transport is removed from the asoc.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_REMOVED:  The address is no longer part of the
     association.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 55aad70..0d3d7ce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -569,6 +569,7 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 
 	asoc->peer.transport_count--;
 
+	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
 	sctp_transport_free(peer);
 }
 
-- 
2.1.0
