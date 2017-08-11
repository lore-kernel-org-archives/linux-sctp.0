From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 11 Aug 2017 02:23:47 +0000
Subject: [PATCH net-next 03/14] sctp: remove the typedef sctp_endpoint_type_t
Message-Id: <5031dc5f40135c4ede57452bc61a1b29dfc76d89.1502417340.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1502417340.git.lucien.xin@gmail.com>
 <e15322cc52e110730f2bcb77973222b687717369.1502417340.git.lucien.xin@gmail.com>
 <67dec3f4936413e5bf596dc0ce9be0b9aa15a444.1502417340.git.lucien.xin@gmail.com>
In-Reply-To: <67dec3f4936413e5bf596dc0ce9be0b9aa15a444.1502417340.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to remove the typedef sctp_endpoint_type_t, and
replace with enum sctp_endpoint_type in the places where it's
using this typedef.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 60033a2..937187f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1142,10 +1142,10 @@ int sctp_is_ep_boundall(struct sock *sk);
 
 
 /* What type of endpoint?  */
-typedef enum {
+enum sctp_endpoint_type {
 	SCTP_EP_TYPE_SOCKET,
 	SCTP_EP_TYPE_ASSOCIATION,
-} sctp_endpoint_type_t;
+};
 
 /*
  * A common base class to bridge the implmentation view of a
@@ -1169,7 +1169,7 @@ struct sctp_ep_common {
 	int hashent;
 
 	/* Runtime type information.  What kind of endpoint is this? */
-	sctp_endpoint_type_t type;
+	enum sctp_endpoint_type type;
 
 	/* Some fields to help us manage this object.
 	 *   refcnt   - Reference count access to this object.
-- 
2.1.0

