From: Dan Carpenter <error27@gmail.com>
Date: Fri, 23 Apr 2010 11:59:06 +0000
Subject: [patch] sctp: cleanup: remove unneeded null check
Message-Id: <20100423115906.GE29093@bicker>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>, Chris Dischino <cdischino@sonusnet.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

"chunk" can never be null here.  We dereferenced it earlier in the
function and also at the start of the function we passed it to 
sctp_pack_cookie() which dereferences it.

This code has been around since the dawn of git history so if "chunk"
were ever null someone would have complained about it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 17cb400..52352fc 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -470,8 +470,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	 *
 	 * [INIT ACK back to where the INIT came from.]
 	 */
-	if (chunk)
-		retval->transport = chunk->transport;
+	retval->transport = chunk->transport;
 
 nomem_chunk:
 	kfree(cookie);
