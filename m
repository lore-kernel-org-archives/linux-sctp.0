From: Waiman Long <longman@redhat.com>
Date: Tue, 16 Jun 2020 01:57:18 +0000
Subject: [PATCH v4 3/3] btrfs: Use kfree() in btrfs_ioctl_get_subvol_info()
Message-Id: <20200616015718.7812-4-longman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
In-Reply-To: <20200616015718.7812-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Perches <joe@perches.com>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, kasan-dev@googlegroups.com, linux-wpan@vger.kernel.org, Waiman Long <longman@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, virtualization@lists.linux-foundation.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, David Sterba <dsterba@suse.cz>, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
was incorrectly paired with kzfree(). According to David Sterba, there
isn't any sensitive information in the subvol_info that needs to be
cleared before freeing. So kfree_sensitive() isn't really needed,
use kfree() instead.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1dd9e4271e9..e8f7c5f00894 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2692,7 +2692,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 	btrfs_put_root(root);
 out_free:
 	btrfs_free_path(path);
-	kfree_sensitive(subvol_info);
+	kfree(subvol_info);
 	return ret;
 }
 
-- 
2.18.1
