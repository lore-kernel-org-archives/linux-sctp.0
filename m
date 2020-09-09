From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Wed, 09 Sep 2020 22:36:02 +0000
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
Message-Id: <20200909223602.GJ87483@ziepe.ca>
List-Id: <linux-sctp.vger.kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>, Kees Cook <kees.cook@canonical.com>, Nick Desaulniers <ndesaulniers@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-input@vger.kernel.org, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org, dm-devel@redhat.com, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org, oss-drivers@netronome.com, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org, linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org, storagedev@microchip.com, sparclinux@vger.kernel.org, linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, alsa-devel <alsa-devel@alsa-project.org>

On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> fallthrough to a separate case/default label break; isn't very readable.
> 
> Convert pseudo-keyword fallthrough; statements to a simple break; when
> the next label is case or default and the only statement in the next
> label block is break;
> 
> Found using:
> 
> $ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *
> 
> Miscellanea:
> 
> o Move or coalesce a couple label blocks above a default: block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Compiled allyesconfig x86-64 only.
> A few files for other arches were not compiled.

IB part looks OK, I prefer it like this

You could do the same for continue as well, I saw a few of those..

Thanks,
Jason
