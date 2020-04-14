From: Waiman Long <longman@redhat.com>
Date: Tue, 14 Apr 2020 18:26:48 +0000
Subject: Re: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-Id: <3d8c80cb-68e5-9211-9eda-bc343ed7d894@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413211550.8307-2-longman@redhat.com>
 <20200414124854.GQ5920@twin.jikos.cz>
In-Reply-To: <20200414124854.GQ5920@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba@suse.cz, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Perches <joe@perches.com>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org, kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net, cocci@systeme.lip6.fr, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org

On 4/14/20 8:48 AM, David Sterba wrote:
> On Mon, Apr 13, 2020 at 05:15:49PM -0400, Waiman Long wrote:
>>  fs/btrfs/ioctl.c                              |  2 +-
>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 40b729dce91c..eab3f8510426 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2691,7 +2691,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
>>  	btrfs_put_root(root);
>>  out_free:
>>  	btrfs_free_path(path);
>> -	kzfree(subvol_info);
>> +	kfree_sensitive(subvol_info);
> This is not in a sensitive context so please switch it to plain kfree.
> With that you have my acked-by. Thanks.
>
Thanks for letting me know about. I think I will send it out as a
separate patch.

Cheers,
Longman
