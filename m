From: Steffen Maier <maier@linux.ibm.com>
Date: Thu, 10 Sep 2020 09:18:29 +0000
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
Message-Id: <0c66fbe5-c48b-7dc1-f7fe-1498da9cc1a3@linux.ibm.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>, Benjamin Block <bblock@linux.ibm.com>
Cc: Kees Cook <kees.cook@canonical.com>, Nick Desaulniers <ndesaulniers@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-input@vger.kernel.org, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org, dm-devel@redhat.com, linux-media@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org, oss-drivers@netronome.com, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org, linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org, storagedev@microchip.com, sparclinux@vger.kernel.org, linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, alsa-devel <alsa-devel@alsa-project.org>

On 9/9/20 10:06 PM, Joe Perches wrote:
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

>   drivers/s390/scsi/zfcp_fsf.c                              |  2 +-

>   82 files changed, 109 insertions(+), 112 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 140186fe1d1e..2741a07df692 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2105,7 +2105,7 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
>   
>   	case FSF_PORT_HANDLE_NOT_VALID:
>   		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1");
> -		fallthrough;
> +		break;
>   	case FSF_LUN_ALREADY_OPEN:
>   		break;
>   	case FSF_PORT_BOXED:

Acked-by: Steffen Maier <maier@linux.ibm.com> # for zfcp


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
