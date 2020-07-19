From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:03 +0000
Subject: [PATCH 26/51] sctp: switch sctp_setsockopt_auth_key to use memzero_explicit
Message-Id: <20200719072228.112645-27-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Switch from kzfree to sctp_setsockopt_auth_key + kfree to prepare for
moving the kfree to common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a573af7dfe41f5..365145746b559d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3649,7 +3649,8 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
+	memzero_explicit(authkey, optlen);
+	kfree(authkey);
 	return ret;
 }
 
-- 
2.27.0
