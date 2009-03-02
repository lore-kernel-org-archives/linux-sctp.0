From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Mar 2009 16:46:50 +0000
Subject: [PATCH 1/2] sctp: fix crash during module unload
Message-Id: <1236012411-17841-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
In-Reply-To: <>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

An extra list_del() during the module load failure and unload
resulted in a crash with a list corruption.  Now sctp can
be unloaded again.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/protocol.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b78e3be..4e66384 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1322,9 +1322,8 @@ SCTP_STATIC __init int sctp_init(void)
 out:
 	return status;
 err_v6_add_protocol:
-	sctp_v6_del_protocol();
-err_add_protocol:
 	sctp_v4_del_protocol();
+err_add_protocol:
 	inet_ctl_sock_destroy(sctp_ctl_sock);
 err_ctl_sock_init:
 	sctp_v6_protosw_exit();
@@ -1335,7 +1334,6 @@ err_protosw_init:
 	sctp_v4_pf_exit();
 	sctp_v6_pf_exit();
 	sctp_sysctl_unregister();
-	list_del(&sctp_af_inet.list);
 	free_pages((unsigned long)sctp_port_hashtable,
 		   get_order(sctp_port_hashsize *
 			     sizeof(struct sctp_bind_hashbucket)));
@@ -1383,7 +1381,6 @@ SCTP_STATIC __exit void sctp_exit(void)
 	sctp_v4_pf_exit();
 
 	sctp_sysctl_unregister();
-	list_del(&sctp_af_inet.list);
 
 	free_pages((unsigned long)sctp_assoc_hashtable,
 		   get_order(sctp_assoc_hashsize *
-- 
1.5.4.3

