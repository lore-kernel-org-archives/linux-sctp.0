From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 13 Aug 2011 09:43:45 +0000
Subject: [PATCH] sctp: dont cast void* from kmalloc()
Message-Id: <1313228625.16820.42.camel@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1313228502.16820.40.camel@localhost.localdomain>
In-Reply-To: <1313228502.16820.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/net/sctp/protocol.c b/net/sctp/protocol.c
--- a/net/sctp/protocol.c 2011-07-26 00:46:12.663489013 +0200
+++ b/net/sctp/protocol.c 2011-08-01 20:02:43.478907122 +0200
@@ -1337,7 +1337,7 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
+	sctp_ep_hashtable  		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		pr_err("Failed endpoint_hash alloc\n");


