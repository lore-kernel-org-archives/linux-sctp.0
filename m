From: weiyj_lk@163.com
Date: Mon, 13 Jun 2016 15:08:26 +0000
Subject: [PATCH -next] sctp: fix error return code in sctp_init()
Message-Id: <1465830506-22752-1-git-send-email-weiyj_lk@163.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPgLHd-X5Qw64BnaSMr2ny6==jXGpRAYC7_1MGhP2v_GcVeApQ@mail.gmail.com>
In-Reply-To: <CAPgLHd-X5Qw64BnaSMr2ny6==jXGpRAYC7_1MGhP2v_GcVeApQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/sctp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 40022ee..3b56ae5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1479,7 +1479,8 @@ static __init int sctp_init(void)
 		INIT_HLIST_HEAD(&sctp_port_hashtable[i].chain);
 	}
 
-	if (sctp_transport_hashtable_init())
+	status = sctp_transport_hashtable_init();
+	if (status)
 		goto err_thash_alloc;
 
 	pr_info("Hash tables configured (bind %d/%d)\n", sctp_port_hashsize,


