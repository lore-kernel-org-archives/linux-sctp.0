From: minyard@acm.org
Date: Tue, 23 Jun 2020 16:04:17 +0000
Subject: [PATCH] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Message-Id: <20200623160417.12418-1-minyard@acm.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <c1121947c9a94703b4ab6dc434a7c3f8@AcuMS.aculab.com>
In-Reply-To: <c1121947c9a94703b4ab6dc434a7c3f8@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>

From: Corey Minyard <cminyard@mvista.com>

If a socket was set ipv6only, it would still send IPv4 addresses in the
init and init ack packets.  So don't add IPv4 addresses to ipv6only
sockets.

Based on a patch by Xin Long <lucien.xin@gmail.com>

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
I have tested this and it seem to fix the issue.  However, I'm wondering
if it might be better to fix it where the addresses are put into the
association as opposed to where they are put into the message.

 include/net/sctp/structs.h | 3 ++-
 net/sctp/bind_addr.c       | 7 ++++++-
 net/sctp/sm_make_chunk.c   | 5 +++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index fb42c90348d3..1e839bf4eaa7 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1190,7 +1190,8 @@ union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
 					const union sctp_addr	*addrs,
 					int			addrcnt,
 					struct sctp_sock	*opt);
-union sctp_params sctp_bind_addrs_to_raw(const struct sctp_bind_addr *bp,
+union sctp_params sctp_bind_addrs_to_raw(const struct sctp_association *asoc,
+					 const struct sctp_bind_addr *bp,
 					 int *addrs_len,
 					 gfp_t gfp);
 int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw, int len,
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 53bc61537f44..3f5b448f2127 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -202,7 +202,8 @@ int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr)
  *
  * The second argument is the return value for the length.
  */
-union sctp_params sctp_bind_addrs_to_raw(const struct sctp_bind_addr *bp,
+union sctp_params sctp_bind_addrs_to_raw(const struct sctp_association *asoc,
+					 const struct sctp_bind_addr *bp,
 					 int *addrs_len,
 					 gfp_t gfp)
 {
@@ -214,6 +215,7 @@ union sctp_params sctp_bind_addrs_to_raw(const struct sctp_bind_addr *bp,
 	struct sctp_sockaddr_entry *addr;
 	struct list_head *pos;
 	struct sctp_af *af;
+	struct sock *sk = asoc->base.sk;
 
 	addrparms_len = 0;
 	len = 0;
@@ -238,6 +240,9 @@ union sctp_params sctp_bind_addrs_to_raw(const struct sctp_bind_addr *bp,
 	addrparms = retval;
 
 	list_for_each_entry(addr, &bp->address_list, list) {
+		if ((PF_INET6 = sk->sk_family) && inet_v6_ipv6only(sk) &&
+		    (AF_INET = addr->a.sa.sa_family))
+			continue;
 		af = sctp_get_af_specific(addr->a.v4.sin_family);
 		len = af->to_addr_param(&addr->a, &rawaddr);
 		memcpy(addrparms.v, &rawaddr, len);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 47910470e532..6e1a6af40779 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -230,7 +230,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	 */
 
 	/* Convert the provided bind address list to raw format. */
-	addrs = sctp_bind_addrs_to_raw(bp, &addrs_len, gfp);
+	addrs = sctp_bind_addrs_to_raw(asoc, bp, &addrs_len, gfp);
 
 	init.init_tag		   = htonl(asoc->c.my_vtag);
 	init.a_rwnd		   = htonl(asoc->rwnd);
@@ -397,7 +397,8 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	int addrs_len;
 
 	/* Note: there may be no addresses to embed. */
-	addrs = sctp_bind_addrs_to_raw(&asoc->base.bind_addr, &addrs_len, gfp);
+	addrs = sctp_bind_addrs_to_raw(asoc, &asoc->base.bind_addr,
+				       &addrs_len, gfp);
 
 	initack.init_tag	        = htonl(asoc->c.my_vtag);
 	initack.a_rwnd			= htonl(asoc->rwnd);
-- 
2.17.1
