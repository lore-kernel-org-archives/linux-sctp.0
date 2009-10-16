From: Jiri Kosina <jkosina@suse.cz>
Date: Fri, 16 Oct 2009 13:24:21 +0000
Subject: Re: [PATCH 7/8] trivial: fix many typos s/untill/until/
Message-Id: <alpine.LSU.2.00.0910161523400.8582@wotan.suse.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <1255638072-6236-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1255638072-6236-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, bonding-devel@lists.sourceforge.net, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, users@host1.serialmonkey.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-ext4@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, 15 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
>  drivers/net/bonding/bond_alb.c           |    2 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c  |    2 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         |    2 +-
>  drivers/staging/rtl8187se/r8180.h        |    2 +-
>  fs/ext4/balloc.c                         |    2 +-
>  net/bluetooth/bnep/core.c                |    2 +-
>  net/sctp/sm_statefuns.c                  |    2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)

Merged together with patches 2-8 from your series and applied to trivial 
queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
