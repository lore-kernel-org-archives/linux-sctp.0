From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 01:22:22 +0000
Subject: [PATCH] sctp: fix oops while removed transport still using as retran
Message-Id: <4DA4FACE.5060706@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DA4FA70.50506@cn.fujitsu.com>
In-Reply-To: <4DA4FA70.50506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: lksctp <linux-sctp@vger.kernel.org>

Since we can not update retran path to unconfirmed transports,
when we remove a peer, the retran path may not be update if the
other transports are all unconfirmed, and we will still using
the removed transport as the retran path. This may cause panic
if retrasnmit happen.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/associola.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 922fdd7..1a21c57 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -569,6 +569,8 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 		sctp_assoc_set_primary(asoc, transport);
 	if (asoc->peer.active_path = peer)
 		asoc->peer.active_path = transport;
+	if (asoc->peer.retran_path = peer)
+		asoc->peer.retran_path = transport;
 	if (asoc->peer.last_data_from = peer)
 		asoc->peer.last_data_from = transport;
 
-- 
1.6.5.2


