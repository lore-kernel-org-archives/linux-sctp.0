From: Michele Baldessari <michele@acksyn.org>
Date: Wed, 04 Apr 2012 22:16:08 +0000
Subject: [PATCH] Return error to userspace in __sctp_connect when inconsistent ports are used
Message-Id: <20120404221608.GA1999@marquez.int.rhx>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad,
  
just as we similarly do in sctp_do_bind() we should return EINVAL when
sctp_connectx is called with multiple addresses but different ports. 

Issue first mentioned with patch in sourceforge #3323780

regards,
Michele
      
Tested-by: Michele Baldessari <michele@acksyn.org>

---
 net/sctp/socket.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 626e4ed..553d54a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1110,10 +1110,12 @@ static int __sctp_connect(struct sock* sk,
 			goto out_free;
 
 		/* Make sure the destination port is correctly set
-		 * in all addresses.
+		 * in all addresses and return EINVAL otherwise
 		 */
-		if (asoc && asoc->peer.port && asoc->peer.port != port)
+		if (asoc && asoc->peer.port && asoc->peer.port != port) {
+			err = -EINVAL;
 			goto out_free;
+		}
 
 
 		/* Check if there already is a matching association on the
-- 
1.7.9.3

