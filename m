From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Wed, 31 Jan 2018 12:13:11 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <677b4f94-ce40-cc06-ee6d-a562eed6e749@nokia.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130155909.GA25399@hmswarspite.think-freely.org>
 <085a2abc-36e3-74fd-8c3a-9352bdd05cf8@nokia.com>
 <20180130210353.GB25399@hmswarspite.think-freely.org>
 <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
In-Reply-To: <d6ddb96d-513d-0f6b-8114-0035d044e8be@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On 31.01.2018 11:42, Tommi Rantala wrote:
> I think there's a problem in the dst refcounting in sctp_v4_get_dst()
> 
> There's a dst_entry struct that has >0 refcnt after running the 
> testcase, which makes it impossible to delete the loopback device, as 
> that dst is never freed.
> 
> I'll try to make a patch.
> 
> Tommi
> 

Hi,

This fixes the problem for me, does it look good?

Tested it briefly on 4.4.113 and 4.15-rc9.


 From b94c037d27e36a3053e6862b7e7da5f07f2f5597 Mon Sep 17 00:00:00 2001
From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Wed, 31 Jan 2018 11:24:31 +0000
Subject: [PATCH] sctp: fix dst leak in sctp_v4_get_dst

Fix dst reference leak in sctp_v4_get_dst() introduced in commit
410f03831 ("sctp: add routing output fallback"):

When walking the address_list, successive ip_route_output_key() calls
may return the same rt->dst with the reference incremented on each call.

The code would not decrement the dst refcount when the dst pointer was
identical from the previous iteration, causing the dst leak.

Testcase:
   ip netns add TEST
   ip netns exec TEST ip link set lo up
   ip link add dummy0 type dummy
   ip link add dummy1 type dummy
   ip link add dummy2 type dummy
   ip link set dev dummy0 netns TEST
   ip link set dev dummy1 netns TEST
   ip link set dev dummy2 netns TEST
   ip netns exec TEST ip addr add 192.168.1.1/24 dev dummy0
   ip netns exec TEST ip link set dummy0 up
   ip netns exec TEST ip addr add 192.168.1.2/24 dev dummy1
   ip netns exec TEST ip link set dummy1 up
   ip netns exec TEST ip addr add 192.168.1.3/24 dev dummy2
   ip netns exec TEST ip link set dummy2 up
   ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1 
-p 20000 -s -B 192.168.1.3
   ip netns del TEST

In 4.4 and 4.9 kernels this results to:
   [  354.179591] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   [  364.419674] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   [  374.663664] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   [  384.903717] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   [  395.143724] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   [  405.383645] unregister_netdevice: waiting for lo to become free. 
Usage count = 1
   ...

Fixes: 410f03831 ("sctp: add routing output fallback")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
---
  net/sctp/protocol.c | 9 ++++-----
  1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8b4ff315695e..aadb9e7f60e2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -508,21 +508,20 @@ static void sctp_v4_get_dst(struct sctp_transport 
*t, union sctp_addr *saddr,
  		if (IS_ERR(rt))
  			continue;

-		if (!dst)
-			dst = &rt->dst;
-
  		/* Ensure the src address belongs to the output
  		 * interface.
  		 */
  		odev = __ip_dev_find(sock_net(sk), laddr->a.v4.sin_addr.s_addr,
  				     false);
  		if (!odev || odev->ifindex != fl4->flowi4_oif) {
-			if (&rt->dst != dst)
+			if (!dst)
+				dst = &rt->dst;
+			else
  				dst_release(&rt->dst);
  			continue;
  		}

-		if (dst != &rt->dst)
+		if (dst && dst != &rt->dst)
  			dst_release(dst);
  		dst = &rt->dst;
  		break;
-- 
2.15.1
