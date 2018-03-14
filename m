From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 14 Mar 2018 20:46:21 +0000
Subject: sctp: use proc_remove_subtree()
Message-Id: <20180314204621.GY30522@ZenIV.linux.org.uk>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org

use proc_remove_subtree() for subtree removal, both on setup failure
halfway through and on teardown.  No need to make simple things
complex...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/sctp/sctp.h |  9 +--------
 net/sctp/proc.c         | 90 +++++++++++++++++++++---------------------------------------------------------------------
 net/sctp/protocol.c     | 57 ++++++---------------------------------------------------
 3 files changed, 28 insertions(+), 128 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f7ae6b0a21d0..3f90134008e9 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -180,14 +180,7 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
 /*
  * sctp/proc.c
  */
-int sctp_snmp_proc_init(struct net *net);
-void sctp_snmp_proc_exit(struct net *net);
-int sctp_eps_proc_init(struct net *net);
-void sctp_eps_proc_exit(struct net *net);
-int sctp_assocs_proc_init(struct net *net);
-void sctp_assocs_proc_exit(struct net *net);
-int sctp_remaddr_proc_init(struct net *net);
-void sctp_remaddr_proc_exit(struct net *net);
+int __net_init sctp_proc_init(struct net *net);
 
 /*
  * sctp/offload.c
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 537545ebcb0e..17d0155d9de3 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -101,25 +101,6 @@ static const struct file_operations sctp_snmp_seq_fops = {
 	.release = single_release_net,
 };
 
-/* Set up the proc fs entry for 'snmp' object. */
-int __net_init sctp_snmp_proc_init(struct net *net)
-{
-	struct proc_dir_entry *p;
-
-	p = proc_create("snmp", S_IRUGO, net->sctp.proc_net_sctp,
-			&sctp_snmp_seq_fops);
-	if (!p)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/* Cleanup the proc fs entry for 'snmp' object. */
-void sctp_snmp_proc_exit(struct net *net)
-{
-	remove_proc_entry("snmp", net->sctp.proc_net_sctp);
-}
-
 /* Dump local addresses of an association/endpoint. */
 static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_common *epb)
 {
@@ -259,25 +240,6 @@ static const struct file_operations sctp_eps_seq_fops = {
 	.release = seq_release_net,
 };
 
-/* Set up the proc fs entry for 'eps' object. */
-int __net_init sctp_eps_proc_init(struct net *net)
-{
-	struct proc_dir_entry *p;
-
-	p = proc_create("eps", S_IRUGO, net->sctp.proc_net_sctp,
-			&sctp_eps_seq_fops);
-	if (!p)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/* Cleanup the proc fs entry for 'eps' object. */
-void sctp_eps_proc_exit(struct net *net)
-{
-	remove_proc_entry("eps", net->sctp.proc_net_sctp);
-}
-
 struct sctp_ht_iter {
 	struct seq_net_private p;
 	struct rhashtable_iter hti;
@@ -390,25 +352,6 @@ static const struct file_operations sctp_assocs_seq_fops = {
 	.release = seq_release_net,
 };
 
-/* Set up the proc fs entry for 'assocs' object. */
-int __net_init sctp_assocs_proc_init(struct net *net)
-{
-	struct proc_dir_entry *p;
-
-	p = proc_create("assocs", S_IRUGO, net->sctp.proc_net_sctp,
-			&sctp_assocs_seq_fops);
-	if (!p)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/* Cleanup the proc fs entry for 'assocs' object. */
-void sctp_assocs_proc_exit(struct net *net)
-{
-	remove_proc_entry("assocs", net->sctp.proc_net_sctp);
-}
-
 static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 {
 	struct sctp_association *assoc;
@@ -488,12 +431,6 @@ static const struct seq_operations sctp_remaddr_ops = {
 	.show  = sctp_remaddr_seq_show,
 };
 
-/* Cleanup the proc fs entry for 'remaddr' object. */
-void sctp_remaddr_proc_exit(struct net *net)
-{
-	remove_proc_entry("remaddr", net->sctp.proc_net_sctp);
-}
-
 static int sctp_remaddr_seq_open(struct inode *inode, struct file *file)
 {
 	return seq_open_net(inode, file, &sctp_remaddr_ops,
@@ -507,13 +444,28 @@ static const struct file_operations sctp_remaddr_seq_fops = {
 	.release = seq_release_net,
 };
 
-int __net_init sctp_remaddr_proc_init(struct net *net)
+/* Set up the proc fs entry for the SCTP protocol. */
+int __net_init sctp_proc_init(struct net *net)
 {
-	struct proc_dir_entry *p;
-
-	p = proc_create("remaddr", S_IRUGO, net->sctp.proc_net_sctp,
-			&sctp_remaddr_seq_fops);
-	if (!p)
+	net->sctp.proc_net_sctp = proc_net_mkdir(net, "sctp", net->proc_net);
+	if (!net->sctp.proc_net_sctp)
 		return -ENOMEM;
+	if (!proc_create("snmp", S_IRUGO, net->sctp.proc_net_sctp,
+			&sctp_snmp_seq_fops))
+		goto cleanup;
+	if (!proc_create("eps", S_IRUGO, net->sctp.proc_net_sctp,
+			&sctp_eps_seq_fops))
+		goto cleanup;
+	if (!proc_create("assocs", S_IRUGO, net->sctp.proc_net_sctp,
+			&sctp_assocs_seq_fops))
+		goto cleanup;
+	if (!proc_create("remaddr", S_IRUGO, net->sctp.proc_net_sctp,
+			&sctp_remaddr_seq_fops))
+		goto cleanup;
 	return 0;
+
+cleanup:
+	remove_proc_subtree("sctp", net->proc_net);
+	net->sctp.proc_net_sctp = NULL;
+	return -ENOMEM;
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 91813e686c67..aea493649f3f 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -80,56 +80,6 @@ long sysctl_sctp_mem[3];
 int sysctl_sctp_rmem[3];
 int sysctl_sctp_wmem[3];
 
-/* Set up the proc fs entry for the SCTP protocol. */
-static int __net_init sctp_proc_init(struct net *net)
-{
-#ifdef CONFIG_PROC_FS
-	net->sctp.proc_net_sctp = proc_net_mkdir(net, "sctp", net->proc_net);
-	if (!net->sctp.proc_net_sctp)
-		goto out_proc_net_sctp;
-	if (sctp_snmp_proc_init(net))
-		goto out_snmp_proc_init;
-	if (sctp_eps_proc_init(net))
-		goto out_eps_proc_init;
-	if (sctp_assocs_proc_init(net))
-		goto out_assocs_proc_init;
-	if (sctp_remaddr_proc_init(net))
-		goto out_remaddr_proc_init;
-
-	return 0;
-
-out_remaddr_proc_init:
-	sctp_assocs_proc_exit(net);
-out_assocs_proc_init:
-	sctp_eps_proc_exit(net);
-out_eps_proc_init:
-	sctp_snmp_proc_exit(net);
-out_snmp_proc_init:
-	remove_proc_entry("sctp", net->proc_net);
-	net->sctp.proc_net_sctp = NULL;
-out_proc_net_sctp:
-	return -ENOMEM;
-#endif /* CONFIG_PROC_FS */
-	return 0;
-}
-
-/* Clean up the proc fs entry for the SCTP protocol.
- * Note: Do not make this __exit as it is used in the init error
- * path.
- */
-static void sctp_proc_exit(struct net *net)
-{
-#ifdef CONFIG_PROC_FS
-	sctp_snmp_proc_exit(net);
-	sctp_eps_proc_exit(net);
-	sctp_assocs_proc_exit(net);
-	sctp_remaddr_proc_exit(net);
-
-	remove_proc_entry("sctp", net->proc_net);
-	net->sctp.proc_net_sctp = NULL;
-#endif
-}
-
 /* Private helper to extract ipv4 address and stash them in
  * the protocol structure.
  */
@@ -1285,10 +1235,12 @@ static int __net_init sctp_defaults_init(struct net *net)
 	if (status)
 		goto err_init_mibs;
 
+#ifdef CONFIG_PROC_FS
 	/* Initialize proc fs directory.  */
 	status = sctp_proc_init(net);
 	if (status)
 		goto err_init_proc;
+#endif
 
 	sctp_dbg_objcnt_init(net);
 
@@ -1322,7 +1274,10 @@ static void __net_exit sctp_defaults_exit(struct net *net)
 
 	sctp_dbg_objcnt_exit(net);
 
-	sctp_proc_exit(net);
+#ifdef CONFIG_PROC_FS
+	remove_proc_subtree("sctp", net->proc_net);
+	net->sctp.proc_net_sctp = NULL;
+#endif
 	cleanup_sctp_mibs(net);
 	sctp_sysctl_net_unregister(net);
 }
