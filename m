From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:28 +0000
Subject: [PATCH 51/51] sctp: remove the out_nounlock label in sctp_setsockopt
Message-Id: <20200719072228.112645-52-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This is just used once, and a direct return for the redirect to the AF
case is much easier to follow than jumping to the end of a very long
function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f2d4f8a0c426bb..9a767f35971865 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4444,8 +4444,8 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	 */
 	if (level != SOL_SCTP) {
 		struct sctp_af *af = sctp_sk(sk)->pf->af;
-		retval = af->setsockopt(sk, level, optname, optval, optlen);
-		goto out_nounlock;
+
+		return af->setsockopt(sk, level, optname, optval, optlen);
 	}
 
 	if (optlen > 0) {
@@ -4635,8 +4635,6 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 
 	release_sock(sk);
 	kfree(kopt);
-
-out_nounlock:
 	return retval;
 }
 
-- 
2.27.0
