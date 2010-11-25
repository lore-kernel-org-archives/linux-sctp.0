From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Thu, 25 Nov 2010 02:11:06 +0000
Subject: Re: Source address selection with secondary interface address
Message-Id: <4CEDC5BA.1030202@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
In-Reply-To: <79C4240C13B4C84B910850B96B1B431201C276DA@DEMUEXC035.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Kiss, Zoltan (NSN - HU/Budapest) wrote, at 11/24/2010 11:18 PM:
> Hi,
> 
> In this routing entry:
> 
> 10.0.0.36/28 via 10.0.0.153 dev vlan2
> 
> .153 is the nexthop, not the source IP! My theory that when it queries this route, it will give back implicitly the primary IP of that interface, which is .156, and that's why it isn't succeeded.

You'd better to confirm it.

> 
> About the next step, so is this a correct statement?:
> 
> sctp_v4_get_dst() is querying the routing table with every local address (.146 and .154, in this order) of that association as SRC address, and if it receives ANY kind of valid route with this condition (only SRC is defined), it will use that SRC for the packet (right the first query will succeed with .146), BUT it won't change the outgoing interface according to this routing entry (OR it change it in the skb, but later IP will overwrite it?)

Isn't [HB ACK] send out from vlan1?

-- 
Best Regards
-----
Shan Wei




