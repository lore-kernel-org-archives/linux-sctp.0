From: Keith Busch <kbusch@kernel.org>
Date: Wed, 09 Sep 2020 20:55:58 +0000
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
Message-Id: <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>, Kees Cook <kees.cook@canonical.com>, Nick Desaulniers <ndesaulniers@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-input@vger.kernel.org, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org, dm-devel@redhat.com, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org, oss-drivers@netronome.com, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org, linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org, storagedev@microchip.com, sparclinux@vger.kernel.org, linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, alsa-devel <alsa-devel@alsa-project.org>

On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index eea0f453cfb6..8aac5bc60f4c 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  		test_hash_speed("streebog512", sec,
>  				generic_hash_speed_template);
>  		if (mode > 300 && mode < 400) break;
> -		fallthrough;
> +		break;
>  	case 399:
>  		break;

Just imho, this change makes the preceding 'if' look even more
pointless. Maybe the fallthrough was a deliberate choice? Not that my
opinion matters here as I don't know this module, but it looked a bit
odd to me.
