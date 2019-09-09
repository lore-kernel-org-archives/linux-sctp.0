From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 09 Sep 2019 07:33:29 +0000
Subject: [PATCH net] sctp: fix the missing put_user when dumping transport thresholds
Message-Id: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
a transport thresholds info.

Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.

Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9d1f83b..ad87518 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7173,7 +7173,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
 
-		return 0;
+		goto out;
 	}
 
 	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
@@ -7191,6 +7191,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
 
+out:
 	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
 		return -EFAULT;
 
-- 
2.1.0
