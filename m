From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 13 Mar 2018 02:57:31 +0000
Subject: [PATCH net-next v2] sctp: fix error return code in sctp_sendmsg_new_asoc()
Message-Id: <1520910210-147500-1-git-send-email-weiyongjun1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1520856964-132516-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Return error code -EINVAL in the address len check error handling
case since 'err' can be overwrite to 0 by 'err = sctp_verify_addr()'
in the for loop.

Fixes: 2c0dbaa0c43d ("sctp: add support for SCTP_DSTADDRV4/6 Information for sendmsg")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
v1 -> v2: remove the 'err' initialization
---
 net/sctp/socket.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7d3476a..af5cf29 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1677,7 +1677,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	struct sctp_association *asoc;
 	enum sctp_scope scope;
 	struct cmsghdr *cmsg;
-	int err = -EINVAL;
+	int err;
 
 	*tp = NULL;
 
@@ -1761,16 +1761,20 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 		memset(daddr, 0, sizeof(*daddr));
 		dlen = cmsg->cmsg_len - sizeof(struct cmsghdr);
 		if (cmsg->cmsg_type = SCTP_DSTADDRV4) {
-			if (dlen < sizeof(struct in_addr))
+			if (dlen < sizeof(struct in_addr)) {
+				err = -EINVAL;
 				goto free;
+			}
 
 			dlen = sizeof(struct in_addr);
 			daddr->v4.sin_family = AF_INET;
 			daddr->v4.sin_port = htons(asoc->peer.port);
 			memcpy(&daddr->v4.sin_addr, CMSG_DATA(cmsg), dlen);
 		} else {
-			if (dlen < sizeof(struct in6_addr))
+			if (dlen < sizeof(struct in6_addr)) {
+				err = -EINVAL;
 				goto free;
+			}
 
 			dlen = sizeof(struct in6_addr);
 			daddr->v6.sin6_family = AF_INET6;

