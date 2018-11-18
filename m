From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 13:59:49 +0000
Subject: [PATCH net] sctp: not increase stream's incnt before sending addstrm_in request
Message-Id: <74669ed0fa48471de2b6b1ebb3580858e4fa7895.1542549589.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Different from processing the addstrm_out request, The receiver handles
an addstrm_in request by sending back an addstrm_out request to the
sender who will increase its stream's in and incnt later.

Now stream->incnt has been increased since it sent out the addstrm_in
request in sctp_send_add_streams(), with the wrong stream->incnt will
even cause crash when copying stream info from the old stream's in to
the new one's in sctp_process_strreset_addstrm_out().

This patch is to fix it by simply removing the stream->incnt change
from sctp_send_add_streams().

Fixes: 242bd2d519d7 ("sctp: implement sender-side procedures for Add Incoming/Outgoing Streams Request Parameter")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ffb940d..3892e76 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -535,7 +535,6 @@ int sctp_send_add_streams(struct sctp_association *asoc,
 		goto out;
 	}
 
-	stream->incnt = incnt;
 	stream->outcnt = outcnt;
 
 	asoc->strreset_outstanding = !!out + !!in;
-- 
2.1.0
