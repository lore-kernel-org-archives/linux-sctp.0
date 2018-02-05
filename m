From: David Ahern <dsahern@gmail.com>
Date: Mon, 05 Feb 2018 23:20:49 +0000
Subject: Re: [PATCH net v3] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <c242ed66-cc0c-0783-360a-88e73fe5d541@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180205194814.14006-1-tommi.t.rantala@nokia.com>
In-Reply-To: <20180205194814.14006-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On 2/5/18 12:48 PM, Tommi Rantala wrote:
> Fix dst reference count leak in sctp_v4_get_dst() introduced in commit
> 410f03831 ("sctp: add routing output fallback"):
> 
> When walking the address_list, successive ip_route_output_key() calls
> may return the same rt->dst with the reference incremented on each call.
> 
> The code would not decrement the dst refcount when the dst pointer was
> identical from the previous iteration, causing the dst refcnt leak.
> 
...
>   ...
> 
> Fixes: 410f03831 ("sctp: add routing output fallback")
> Fixes: 0ca50d12f ("sctp: fix src address selection if using secondary addresses")

any syzbot references for this bug?
