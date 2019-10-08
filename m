From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:27:35 +0000
Subject: [PATCH net-next 3/4] sctp: add SCTP_ADDR_MADE_PRIM event
Message-Id: <52fca36c494e075b2d40781ada8669252125521b.1570534014.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
 <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <11f2df01acb8a5d90ad2b37e97416ee2a9ff1a20.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_ulpevent_nofity_peer_addr_change() would be called in
sctp_assoc_set_primary() to send SCTP_ADDR_MADE_PRIM event
when this transport is set to the primary path of the asoc.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_MADE_PRIM:  This address has now been made the primary
     destination address.  This notification is provided whenever an
     address is made primary.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 0d3d7ce..1ba893b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -429,6 +429,8 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
 		changeover = 1 ;
 
 	asoc->peer.primary_path = transport;
+	sctp_ulpevent_nofity_peer_addr_change(transport,
+					      SCTP_ADDR_MADE_PRIM, 0);
 
 	/* Set a default msg_name for events. */
 	memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
-- 
2.1.0
