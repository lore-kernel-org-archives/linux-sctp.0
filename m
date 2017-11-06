From: Petr Malat <oss@malat.biz>
Date: Mon, 06 Nov 2017 13:39:56 +0000
Subject: [PATCH] sctp: Fix len returned by getsockopt(sk, SCTP_GET_LOCAL_ADDRS, opt, &len)
Message-Id: <20171106133955.GA31556@bordel.klfree.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

A call to
  getsockopt(sk, SCTP_GET_LOCAL_ADDRS, opt, &optlen)
returns a wrong value in optlen, because it doesn't account struct sctp_getaddrs
preceding the actual addresses.

Signed-off-by: Petr Malat <petr.malat.ext@nokia.com>
---
 net/sctp/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6f45d17..9082269 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5560,6 +5560,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		err = -EFAULT;
 		goto out;
 	}
+	bytes_copied += offsetof(struct sctp_getaddrs, addrs);
 	if (put_user(bytes_copied, optlen))
 		err = -EFAULT;
 out:
-- 
1.7.11.3

