From: David Sterba <dsterba@suse.cz>
Date: Tue, 14 Apr 2020 12:48:54 +0000
Subject: Re: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <20200414124854.GQ5920@twin.jikos.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413211550.8307-2-longman@redhat.com>
In-Reply-To: <20200413211550.8307-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, virtualization@lists.linux-foundation.org, David Howells <dhowells@redhat.com>, linux-mm@kvack.org, linux-sctp@vger.kernel.org, keyrings@vger.kernel.org, kasan-dev@googlegroups.com, samba-technical@lists.samba.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org, James Morris <jmorris@namei.org>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, linux-wpan@vger.kernel.org, intel-wired-lan@lists.osuosl.org, David Rientjes <rientjes@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

On Mon, Apr 13, 2020 at 05:15:49PM -0400, Waiman Long wrote:
>  fs/btrfs/ioctl.c                              |  2 +-


> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 40b729dce91c..eab3f8510426 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2691,7 +2691,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
>  	btrfs_put_root(root);
>  out_free:
>  	btrfs_free_path(path);
> -	kzfree(subvol_info);
> +	kfree_sensitive(subvol_info);

This is not in a sensitive context so please switch it to plain kfree.
With that you have my acked-by. Thanks.
