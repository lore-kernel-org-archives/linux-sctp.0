From: Waiman Long <longman@redhat.com>
Date: Tue, 16 Jun 2020 15:05:22 +0000
Subject: Re: [PATCH v4 3/3] btrfs: Use kfree() in btrfs_ioctl_get_subvol_info()
Message-Id: <75152002-5f02-04b6-a811-29ef79961e0b@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <20200616015718.7812-4-longman@redhat.com>
 <20200616144804.GD27795@twin.jikos.cz>
In-Reply-To: <20200616144804.GD27795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dsterba@suse.cz, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Perches <joe@perches.com>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Dan Carpenter <dan.carpenter@oracle.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-amlogic@lists.infradead.org, linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org, kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org

On 6/16/20 10:48 AM, David Sterba wrote:
> On Mon, Jun 15, 2020 at 09:57:18PM -0400, Waiman Long wrote:
>> In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
>> was incorrectly paired with kzfree(). According to David Sterba, there
>> isn't any sensitive information in the subvol_info that needs to be
>> cleared before freeing. So kfree_sensitive() isn't really needed,
>> use kfree() instead.
>>
>> Reported-by: David Sterba <dsterba@suse.cz>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   fs/btrfs/ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index f1dd9e4271e9..e8f7c5f00894 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2692,7 +2692,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
>>   	btrfs_put_root(root);
>>   out_free:
>>   	btrfs_free_path(path);
>> -	kfree_sensitive(subvol_info);
>> +	kfree(subvol_info);
> I would rather merge a patch doing to kzfree -> kfree instead of doing
> the middle step to switch it to kfree_sensitive. If it would help
> integration of your patchset I can push it to the next rc so there are
> no kzfree left in the btrfs code. Treewide change like that can take
> time so it would be one less problem to care about for you.
>
Sure, I will move it forward in the patch series.

Thanks,
Longman
