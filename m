From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jan 2018 21:02:29 +0000
Subject: [PATCH net 3/3] sctp: make use of pre-calculated len
Message-Id: <fa78b39d4579f0e30f716c3bf24c3db2895ee816.1515436112.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515436112.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515436112.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, haliu@redhat.com

Some sockopt handling functions were calculating the length of the
buffer to be written to userspace and then calculating it again when
actually writing the buffer, which could lead to some write not using
an up-to-date length.

This patch updates such places to just make use of the len variable.

Also, replace some sizeof(type) to sizeof(var).

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 022b94f11fd8ac0d3b839b16dfc14f86abf2324f..9b01e994f66108a12abc31f452482f1de8749d84 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5025,7 +5025,7 @@ static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optv
 	len = sizeof(int);
 	if (put_user(len, optlen))
 		return -EFAULT;
-	if (copy_to_user(optval, &sctp_sk(sk)->autoclose, sizeof(int)))
+	if (copy_to_user(optval, &sctp_sk(sk)->autoclose, len))
 		return -EFAULT;
 	return 0;
 }
@@ -5655,6 +5655,9 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		err = -EFAULT;
 		goto out;
 	}
+	/* XXX: We should have accounted for sizeof(struct sctp_getaddrs) too,
+	 * but we can't change it anymore.
+	 */
 	if (put_user(bytes_copied, optlen))
 		err = -EFAULT;
 out:
@@ -6091,7 +6094,7 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 		params.assoc_id = 0;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
-		if (copy_from_user(&params, optval, sizeof(params)))
+		if (copy_from_user(&params, optval, len))
 			return -EFAULT;
 	} else
 		return -EINVAL;
@@ -6261,7 +6264,9 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 
 	if (len < sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, sizeof(struct sctp_authkeyid)))
+
+	len = sizeof(struct sctp_authkeyid);
+	if (copy_from_user(&val, optval, len))
 		return -EFAULT;
 
 	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
@@ -6273,7 +6278,6 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 	else
 		val.scact_keynumber = ep->active_key_id;
 
-	len = sizeof(struct sctp_authkeyid);
 	if (put_user(len, optlen))
 		return -EFAULT;
 	if (copy_to_user(optval, &val, len))
@@ -6299,7 +6303,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(struct sctp_authchunks)))
+	if (copy_from_user(&val, optval, sizeof(val)))
 		return -EFAULT;
 
 	to = p->gauth_chunks;
@@ -6344,7 +6348,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	if (len < sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(struct sctp_authchunks)))
+	if (copy_from_user(&val, optval, sizeof(val)))
 		return -EFAULT;
 
 	to = p->gauth_chunks;
-- 
2.14.3

