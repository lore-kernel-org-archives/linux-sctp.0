From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 07 Feb 2013 11:41:39 +0000
Subject: [PATCH net-next] net: sctp: sctp_auth_make_key_vector: remove duplicate ntohs calls
Message-Id: <c029f55f4d0bde790f77f62d623f4d1e387c4c0b.1360237025.git.dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360237025.git.dborkman@redhat.com>
In-Reply-To: <cover.1360237025.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Instead of calling 3 times ntohs(random->param_hdr.length), 2 times
ntohs(hmacs->param_hdr.length), and 3 times ntohs(chunks->param_hdr.length)
within the same function, we only call each once and store it in a
variable.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/auth.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 159b9bc..94a12de 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -200,10 +200,14 @@ static struct sctp_auth_bytes *sctp_auth_make_key_vector(
 	struct sctp_auth_bytes *new;
 	__u32	len;
 	__u32	offset = 0;
+	__u16	random_len, hmacs_len, chunks_len = 0;
 
-	len = ntohs(random->param_hdr.length) + ntohs(hmacs->param_hdr.length);
-        if (chunks)
-		len += ntohs(chunks->param_hdr.length);
+	random_len = ntohs(random->param_hdr.length);
+	hmacs_len = ntohs(hmacs->param_hdr.length);
+	if (chunks)
+		chunks_len = ntohs(chunks->param_hdr.length);
+
+	len = random_len + hmacs_len + chunks_len;
 
 	new = kmalloc(sizeof(struct sctp_auth_bytes) + len, gfp);
 	if (!new)
@@ -211,16 +215,15 @@ static struct sctp_auth_bytes *sctp_auth_make_key_vector(
 
 	new->len = len;
 
-	memcpy(new->data, random, ntohs(random->param_hdr.length));
-	offset += ntohs(random->param_hdr.length);
+	memcpy(new->data, random, random_len);
+	offset += random_len;
 
 	if (chunks) {
-		memcpy(new->data + offset, chunks,
-			ntohs(chunks->param_hdr.length));
-		offset += ntohs(chunks->param_hdr.length);
+		memcpy(new->data + offset, chunks, chunks_len);
+		offset += chunks_len;
 	}
 
-	memcpy(new->data + offset, hmacs, ntohs(hmacs->param_hdr.length));
+	memcpy(new->data + offset, hmacs, hmacs_len);
 
 	return new;
 }
-- 
1.7.11.7

