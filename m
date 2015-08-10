From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 10 Aug 2015 06:24:33 +0000
Subject: [PATCH V1 Resend 11/11] net: Drop unlikely before IS_ERR(_OR_NULL)
Message-Id: <c3999bbcb63b3f8d09be161333224c14cf709a8e.1439187003.git.viresh.kumar@linaro.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1439187003.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1439187003.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>, "David S. Miller" <davem@davemloft.net>, "open list:OPENVSWITCH" <dev@openvswitch.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "open list:OPENVSWITCH" <netdev@vger.kernel.org>, Pravin Shelar <pshelar@nicira.com>, Vlad Yasevich <vyasevich@gmail.com>

IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag and there
is no need to do that again from its callers. Drop it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 net/openvswitch/datapath.c | 2 +-
 net/sctp/socket.c          | 2 +-
 net/socket.c               | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index ffe984f5b95c..a515e338cade 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1143,7 +1143,7 @@ static int ovs_flow_cmd_set(struct sk_buff *skb, struct genl_info *info)
 						info, OVS_FLOW_CMD_NEW, false,
 						ufid_flags);
 
-		if (unlikely(IS_ERR(reply))) {
+		if (IS_ERR(reply)) {
 			error = PTR_ERR(reply);
 			goto err_unlock_ovs;
 		}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 17bef01b9aa3..897c01c029ca 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4475,7 +4475,7 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
 	}
 
 	newfile = sock_alloc_file(newsock, 0, NULL);
-	if (unlikely(IS_ERR(newfile))) {
+	if (IS_ERR(newfile)) {
 		put_unused_fd(retval);
 		sock_release(newsock);
 		return PTR_ERR(newfile);
diff --git a/net/socket.c b/net/socket.c
index 9963a0b53a64..dd2c247c99e3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -373,7 +373,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
 
 	file = alloc_file(&path, FMODE_READ | FMODE_WRITE,
 		  &socket_file_ops);
-	if (unlikely(IS_ERR(file))) {
+	if (IS_ERR(file)) {
 		/* drop dentry, keep inode */
 		ihold(d_inode(path.dentry));
 		path_put(&path);
@@ -1303,7 +1303,7 @@ SYSCALL_DEFINE4(socketpair, int, family, int, type, int, protocol,
 	}
 
 	newfile1 = sock_alloc_file(sock1, flags, NULL);
-	if (unlikely(IS_ERR(newfile1))) {
+	if (IS_ERR(newfile1)) {
 		err = PTR_ERR(newfile1);
 		goto out_put_unused_both;
 	}
@@ -1467,7 +1467,7 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 		goto out_put;
 	}
 	newfile = sock_alloc_file(newsock, flags, sock->sk->sk_prot_creator->name);
-	if (unlikely(IS_ERR(newfile))) {
+	if (IS_ERR(newfile)) {
 		err = PTR_ERR(newfile);
 		put_unused_fd(newfd);
 		sock_release(newsock);
-- 
2.4.0

