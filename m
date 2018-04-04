From: Davide Caratti <dcaratti@redhat.com>
Date: Wed, 04 Apr 2018 15:31:00 +0000
Subject: Re: [PATCH net-next 5/5] macvlan/macvtap: Add support for SCTP checksum offload.
Message-Id: <1522855860.2617.7.camel@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
         <20180402134006.10111-6-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-6-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Mon, 2018-04-02 at 09:40 -0400, Vladislav Yasevich wrote:
> Since we now have support for software CRC32c offload, turn it on
> for macvlan and macvtap devices so that guests can take advantage
> of offload SCTP checksums to the host or host hardware.
> 
> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  drivers/net/macvlan.c       | 5 +++--
>  drivers/net/tap.c           | 8 +++++---
>  include/uapi/linux/if_tun.h | 1 +
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 

I think also ipvlan can improve its SCTP performance with a similar patch.
WDYT?

thanks,
-- 
davide

