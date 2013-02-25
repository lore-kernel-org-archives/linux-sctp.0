From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 25 Feb 2013 12:26:46 +0000
Subject: [PATCH net-next] sctp: Fix smatch error in ASCONF code
Message-Id: <1361795206-4703-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Fix up a missed null pointer check in the asconf code.  If we don't find a
local address, but we pass in an address length of more than 1, we may
dereference a NULL laddr pointer.  Currently this can't happen, as the only
users of the function pass in the value 1 as the addrcnt parameter, but its not
a hot path, and it doesn't hurt to check for NULL should that ever be the case

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cedd9bf..75ebde9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -820,6 +820,9 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 			goto skip_mkasconf;
 		}
 
+		if (laddr = NULL)
+			return -EINVAL;
+
 		/* We do not need RCU protection throughout this loop
 		 * because this is done under a socket lock from the
 		 * setsockopt call.
-- 
1.7.11.7

