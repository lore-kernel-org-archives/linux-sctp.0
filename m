From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 05 Feb 2018 01:01:14 +0000
Subject: Re: [PATCH net] sctp: fix dst reference leak in sctp_v4_get_dst
Message-Id: <20180205010114.GA27685@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180204090239.8875-1-tommi.t.rantala@nokia.com>
In-Reply-To: <20180204090239.8875-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Alexey Kodanev <alexey.kodanev@oracle.com>

Hi,

On Sun, Feb 04, 2018 at 11:02:39AM +0200, Tommi Rantala wrote:
> Fix dst reference leak in sctp_v4_get_dst() introduced in commit
> 410f03831 ("sctp: add routing output fallback"):
> 
> When walking the address_list, successive ip_route_output_key() calls
> may return the same rt->dst with the reference incremented on each call.
> 
> The code would not decrement the dst refcount when the dst pointer was
> identical from the previous iteration, causing the dst leak.
> 
> Testcase:
>   ip netns add TEST
>   ip netns exec TEST ip link set lo up
>   ip link add dummy0 type dummy
>   ip link add dummy1 type dummy
>   ip link add dummy2 type dummy
>   ip link set dev dummy0 netns TEST
>   ip link set dev dummy1 netns TEST
>   ip link set dev dummy2 netns TEST
>   ip netns exec TEST ip addr add 192.168.1.1/24 dev dummy0
>   ip netns exec TEST ip link set dummy0 up
>   ip netns exec TEST ip addr add 192.168.1.2/24 dev dummy1
>   ip netns exec TEST ip link set dummy1 up
>   ip netns exec TEST ip addr add 192.168.1.3/24 dev dummy2
>   ip netns exec TEST ip link set dummy2 up
>   ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1 -p 20000 -s -B 192.168.1.3
>   ip netns del TEST

Thanks for the detailed steps. I'll adapt and include it on
github/sctp/sctp-tests

> 
> In 4.4 and 4.9 kernels this results to:

I wonder why you couldn't reproduce this on newer kernels. Maybe
something masked it?

>   [  354.179591] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   [  364.419674] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   [  374.663664] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   [  384.903717] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   [  395.143724] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   [  405.383645] unregister_netdevice: waiting for lo to become free. Usage count = 1
>   ...
> 
> Fixes: 410f03831 ("sctp: add routing output fallback")
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Alexey Kodanev <alexey.kodanev@oracle.com>
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
> ---
>  net/sctp/protocol.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 8b4ff315695e..aadb9e7f60e2 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -508,21 +508,20 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>  		if (IS_ERR(rt))
>  			continue;
>  
> -		if (!dst)
> -			dst = &rt->dst;
> -
>  		/* Ensure the src address belongs to the output
>  		 * interface.
>  		 */
>  		odev = __ip_dev_find(sock_net(sk), laddr->a.v4.sin_addr.s_addr,
>  				     false);
>  		if (!odev || odev->ifindex != fl4->flowi4_oif) {
> -			if (&rt->dst != dst)
> +			if (!dst)
> +				dst = &rt->dst;
> +			else
>  				dst_release(&rt->dst);
>  			continue;
>  		}
>  
> -		if (dst != &rt->dst)
> +		if (dst && dst != &rt->dst)
>  			dst_release(dst);
>  		dst = &rt->dst;
>  		break;
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
