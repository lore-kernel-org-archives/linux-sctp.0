From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 01 Mar 2013 05:27:43 +0000
Subject: [patch] sctp: use the passed in gfp flags instead GFP_KERNEL
Message-Id: <20130301052743.GD2669@longonot.mountain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

This patch doesn't change how the code works because in the current
kernel gfp is always GFP_KERNEL.  But gfp was obviously intended
instead of GFP_KERNEL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 2b3ef03..12ed45d 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -155,7 +155,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 
 	/* SCTP-AUTH extensions*/
 	INIT_LIST_HEAD(&ep->endpoint_shared_keys);
-	null_key = sctp_auth_shkey_create(0, GFP_KERNEL);
+	null_key = sctp_auth_shkey_create(0, gfp);
 	if (!null_key)
 		goto nomem;
 
