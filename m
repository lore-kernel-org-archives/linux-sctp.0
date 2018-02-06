From: David Miller <davem@davemloft.net>
Date: Tue, 06 Feb 2018 02:22:37 +0000
Subject: Re: [PATCH net v3] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <20180205.212237.773881869579654639.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180205194814.14006-1-tommi.t.rantala@nokia.com>
In-Reply-To: <20180205194814.14006-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tommi.t.rantala@nokia.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, alexey.kodanev@oracle.com, marcelo.leitner@gmail.com

From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Mon,  5 Feb 2018 21:48:14 +0200

> Fix dst reference count leak in sctp_v4_get_dst() introduced in commit
> 410f03831 ("sctp: add routing output fallback"):
> 
> When walking the address_list, successive ip_route_output_key() calls
> may return the same rt->dst with the reference incremented on each call.
> 
> The code would not decrement the dst refcount when the dst pointer was
> identical from the previous iteration, causing the dst refcnt leak.
 ...
> Fixes: 410f03831 ("sctp: add routing output fallback")
> Fixes: 0ca50d12f ("sctp: fix src address selection if using secondary addresses")
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>

Applied and queued up for -stable, thanks.
