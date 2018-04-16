From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 16 Apr 2018 17:12:03 +0000
Subject: Re: [PATCH net-next 4/5] tun: Add support for SCTP checksum offload
Message-Id: <20180416201004-mutt-send-email-mst@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180402134006.10111-1-vyasevic@redhat.com>
 <20180402134006.10111-5-vyasevic@redhat.com>
In-Reply-To: <20180402134006.10111-5-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Mon, Apr 02, 2018 at 09:40:05AM -0400, Vladislav Yasevich wrote:
> Adds a new tun offload flag to allow for SCTP checksum offload.
> The flag has to be set by the user and defaults to "no offload".
> 
> Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>

When would user set this flag? Wouldn't that be when
userspace is ready to get SCTP packets without a checksum?
Seems to be this is an indication that when userspace
is qemu running a guest, said guest needs to communicate
the new ability to qemu.

> ---
>  drivers/net/tun.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index a1ba262..263bcbe 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2719,6 +2719,11 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
>  		arg &= ~TUN_F_UFO;
>  	}
>  
> +	if (arg & TUN_F_SCTP_CSUM) {
> +		features |= NETIF_F_SCTP_CRC;
> +		arg &= ~TUN_F_SCTP_CSUM;
> +	}
> +
>  	/* This gives the user a way to test for new features in future by
>  	 * trying to set them. */
>  	if (arg)
> -- 
> 2.9.5
