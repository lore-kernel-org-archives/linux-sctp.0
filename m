From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:38 +0000
Subject: [PATCH 01/51] sctp: copy the optval from user space in sctp_setsockopt
Message-Id: <20200719072228.112645-2-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Prepare for for moving the copy_from_user from the individual sockopts
to the main setsockopt helper.  As of this commit the kopt variable
is not used yet, but the following commits will start using it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d57e1a002ffc8f..af1ebc8313d303 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4677,6 +4677,7 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 static int sctp_setsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, unsigned int optlen)
 {
+	void *kopt = NULL;
 	int retval = 0;
 
 	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
@@ -4693,6 +4694,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		goto out_nounlock;
 	}
 
+	if (optlen > 0) {
+		kopt = memdup_user(optval, optlen);
+		if (IS_ERR(kopt))
+			return PTR_ERR(kopt);
+	}
+
 	lock_sock(sk);
 
 	switch (optname) {
@@ -4878,6 +4885,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
+	kfree(kopt);
 
 out_nounlock:
 	return retval;
-- 
2.27.0
