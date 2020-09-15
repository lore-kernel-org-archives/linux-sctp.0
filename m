From: Jani Nikula <jani.nikula@linux.intel.com>
Date: Tue, 15 Sep 2020 09:06:21 +0000
Subject: Re: [Intel-gfx] [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
Message-Id: <87d02nxvci.fsf@intel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org, oss-drivers@netronome.com, nouveau@lists.freedesktop.org, alsa-devel <alsa-devel@alsa-project.org>, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org, linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-afs@lists.infradead.org, coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org, linux-input@vger.kernel.org, linux-mmc@vger.kernel.org, Kees Cook <kees.cook@canonical.com>, linux-media@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, storagedev@microchip.com, ceph-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, linux-mips@vger.kernel.org, iommu@lists.linux-foundation.org, netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org

On Wed, 09 Sep 2020, Joe Perches <joe@perches.com> wrote:
> diff --git a/drivers/gpu/drm/i915/display/intel_sprite.c b/drivers/gpu/drm/i915/display/intel_sprite.c
> index 5ac0dbf0e03d..35ac539cc2b1 100644
> --- a/drivers/gpu/drm/i915/display/intel_sprite.c
> +++ b/drivers/gpu/drm/i915/display/intel_sprite.c
> @@ -2861,7 +2861,7 @@ static bool gen12_plane_format_mod_supported(struct drm_plane *_plane,
>  	case I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS:
>  		if (!gen12_plane_supports_mc_ccs(dev_priv, plane->id))
>  			return false;
> -		fallthrough;
> +		break;
>  	case DRM_FORMAT_MOD_LINEAR:
>  	case I915_FORMAT_MOD_X_TILED:
>  	case I915_FORMAT_MOD_Y_TILED:

Acked-by: Jani Nikula <jani.nikula@intel.com>

for merging via whichever tree seems best.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
