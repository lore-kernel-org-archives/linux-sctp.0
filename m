From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 20 Mar 2017 10:00:28 +0000
Subject: [PATCH net] sctp: remove useless err from sctp_association_init
Message-Id: <82209fcc4742baa1c4855af7e54b88177e9d0537.1490004028.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patch is to remove the unnecessary temporary variable 'err' from
sctp_association_init.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 2a6835b..0439a1a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -71,9 +71,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 {
 	struct net *net = sock_net(sk);
 	struct sctp_sock *sp;
-	int i;
 	sctp_paramhdr_t *p;
-	int err;
+	int i;
 
 	/* Retrieve the SCTP per socket area.  */
 	sp = sctp_sk((struct sock *)sk);
@@ -264,8 +263,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 
 	/* AUTH related initializations */
 	INIT_LIST_HEAD(&asoc->endpoint_shared_keys);
-	err = sctp_auth_asoc_copy_shkeys(ep, asoc, gfp);
-	if (err)
+	if (sctp_auth_asoc_copy_shkeys(ep, asoc, gfp))
 		goto fail_init;
 
 	asoc->active_key_id = ep->active_key_id;
-- 
2.1.0

