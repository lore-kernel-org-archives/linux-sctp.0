From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 13 Feb 2013 21:15:53 +0000
Subject: Re: [PATCH net-next 2/2] net: sctp: add build check for sctp_sf_eat_sack_6_2/jsctp_sf_eat_sack
Message-Id: <20130213211553.GA15598@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360752304.git.dborkman@redhat.com>
 <84afa536e3652ea27a7efb1f6c9f7c4f29c15043.1360752304.git.dborkman@redhat.com>
In-Reply-To: <84afa536e3652ea27a7efb1f6c9f7c4f29c15043.1360752304.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, Feb 13, 2013 at 12:03:50PM +0100, Daniel Borkmann wrote:
> In order to avoid any future surprises of kernel panics due to jprobes
> function mismatches (as e.g. fixed in 4cb9d6eaf85ecd: sctp: jsctp_sf_eat_sack:
> fix jprobes function signature mismatch), we should check both function
> types during build and scream loudly if they do not match. __same_type
> resolves to __builtin_types_compatible_p, which is 1 in case both types
> are the same and 0 otherwise, qualifiers are ignored. Tested by myself.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  net/sctp/probe.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/sctp/probe.c b/net/sctp/probe.c
> index 4eaaaf6..261b7b9 100644
> --- a/net/sctp/probe.c
> +++ b/net/sctp/probe.c
> @@ -183,6 +183,13 @@ static __init int sctpprobe_init(void)
>  {
>  	int ret = -ENOMEM;
>  
> +	/* Warning: if the function signature of sctp_sf_eat_sack_6_2,
> +	 * has been changed, you also have to change the signature of
> +	 * jsctp_sf_eat_sack, otherwise you end up right here!
> +	 */
> +	BUILD_BUG_ON(__same_type(sctp_sf_eat_sack_6_2,
> +				 jsctp_sf_eat_sack) = 0);
> +
>  	init_waitqueue_head(&sctpw.wait);
>  	spin_lock_init(&sctpw.lock);
>  	if (kfifo_alloc(&sctpw.fifo, bufsize, GFP_KERNEL))
> -- 
> 1.7.11.7
Acked-by: Neil Horman <nhorman@tuxdriver.com>

