From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 17 Sep 2020 19:40:13 +0000
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
Message-Id: <321069c8-a4c1-56ff-49fb-4c2bce1e6352@intel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
 <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
In-Reply-To: <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Keith Busch <kbusch@kernel.org>, Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org, oss-drivers@netronome.com, nouveau@lists.freedesktop.org, alsa-devel <alsa-devel@alsa-project.org>, dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org, linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-afs@lists.infradead.org, coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org, linux-input@vger.kernel.org, linux-mmc@vger.kernel.org, Kees Cook <kees.cook@canonical.com>, linux-media@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, storagedev@microchip.com, ceph-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org, Jiri Kosina <trivial@kernel.org>, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org, netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org



On 9/9/2020 1:55 PM, Keith Busch wrote:
> On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
>> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
>> index eea0f453cfb6..8aac5bc60f4c 100644
>> --- a/crypto/tcrypt.c
>> +++ b/crypto/tcrypt.c
>> @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>>  		test_hash_speed("streebog512", sec,
>>  				generic_hash_speed_template);
>>  		if (mode > 300 && mode < 400) break;
>> -		fallthrough;
>> +		break;
>>  	case 399:
>>  		break;
> 
> Just imho, this change makes the preceding 'if' look even more
> pointless. Maybe the fallthrough was a deliberate choice? Not that my
> opinion matters here as I don't know this module, but it looked a bit
> odd to me.
> 

Yea this does look very odd..
