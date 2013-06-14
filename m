From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 14 Jun 2013 16:24:07 +0000
Subject: [PATCH net-next v3 4/4] net: sctp: sctp_association_init: put refs in reverse order
Message-Id: <1371227047-16852-5-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371227047-16852-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1371227047-16852-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

In case we need to bail out for whatever reason during assoc
init, we call sctp_endpoint_put() and then sock_put(), however,
we've hold both refs in reverse, non-symmetric order, so first
sctp_endpoint_hold() and then sock_hold().

Reverse this, so that in an error case we have sock_put() and then
sctp_endpoint_put(). Actually shouldn't matter too much, since both
cleanup paths do the right thing, but that way, it is more consistent
with the rest of the code.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/associola.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 91cfd8f..756025c 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,10 +86,9 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 
 	/* Discarding const is appropriate here.  */
 	asoc->ep = (struct sctp_endpoint *)ep;
-	sctp_endpoint_hold(asoc->ep);
-
-	/* Hold the sock.  */
 	asoc->base.sk = (struct sock *)sk;
+
+	sctp_endpoint_hold(asoc->ep);
 	sock_hold(asoc->base.sk);
 
 	/* Initialize the common base substructure.  */
@@ -343,8 +342,8 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	return asoc;
 
 fail_init:
-	sctp_endpoint_put(asoc->ep);
 	sock_put(asoc->base.sk);
+	sctp_endpoint_put(asoc->ep);
 	return NULL;
 }
 
-- 
1.7.11.7

