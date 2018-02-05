From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Mon, 05 Feb 2018 13:33:11 +0000
Subject: [PATCH net v2] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <20180205133311.2620-1-tommi.t.rantala@nokia.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Alexey Kodanev <alexey.kodanev@oracle.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Tommi Rantala <tommi.t.rantala@nokia.com>

Fix dst reference count leak in sctp_v4_get_dst() introduced in commit
410f03831 ("sctp: add routing output fallback"):

When walking the address_list, successive ip_route_output_key() calls
may return the same rt->dst with the reference incremented on each call.

The code would not decrement the dst refcount when the dst pointer was
identical from the previous iteration, causing the dst refcnt leak.

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
  ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1 -p 20000 -s -B 192.168.1.3
  ip netns del TEST

In 4.4 and 4.9 kernels this results to:
  [  354.179591] unregister_netdevice: waiting for lo to become free. Usage count = 1
  [  364.419674] unregister_netdevice: waiting for lo to become free. Usage count = 1
  [  374.663664] unregister_netdevice: waiting for lo to become free. Usage count = 1
  [  384.903717] unregister_netdevice: waiting for lo to become free. Usage count = 1
  [  395.143724] unregister_netdevice: waiting for lo to become free. Usage count = 1
  [  405.383645] unregister_netdevice: waiting for lo to become free. Usage count = 1
  ...

Fixes: 410f03831 ("sctp: add routing output fallback")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
---

v2: unconditional dst_release() before breaking out of the loop:
 - if dst = NULL, then dst_release() is no-op.
 - if dst != &rt->dst, then drop reference to the first dst, we do not
   need it after all.
 - if dst = &rt->dst, then the refcnt was incremented twice for this
   dst, so drop the second ref.

 net/sctp/protocol.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ba28d270eb24..aba2381d3cf9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -509,22 +509,20 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
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
-			dst_release(dst);
+		dst_release(dst);
 		dst = &rt->dst;
 		break;
 	}
-- 
2.15.1

