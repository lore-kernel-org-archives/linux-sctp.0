From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 13 Aug 2011 09:41:42 +0000
Subject: [PATCH] sctp: dont cast void* from kmalloc()
Message-Id: <1313228502.16820.40.camel@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h 2011-07-26 00:46:11.646827854 +0200
+++ b/include/net/sctp/sctp.h 2011-08-01 19:40:06.389592439 +0200
@@ -559,7 +559,7 @@ for (pos = chunk->subh.fwdtsn_hdr->skip;
 #define WORD_ROUND(s) (((s)+3)&~3)
 
 /* Make a new instance of type.  */
-#define t_new(type, flags)	(type *)kzalloc(sizeof(type), flags)
+#define t_new(type, flags)	kzalloc(sizeof(type), flags)
 
 /* Compare two timevals.  */
 #define tv_lt(s, t) \


