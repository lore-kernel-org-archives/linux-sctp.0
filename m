From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Mon, 29 Jan 2018 15:55:45 +0000
Subject: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

Hi,

When running sctp_test from lksctp-tools in netns in 4.4 and 4.9 with 
suitable arguments, the local loopback device in the netns is not 
getting destroyed after deleting the netns.

For example:

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
ip netns exec TEST sctp_test -H 192.168.1.2 -P 20002 -h 192.168.1.1 -p 
20000 -s -B 192.168.1.3
ip netns del TEST

Results to:

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

Based on a quick test, 4.14 and 4.15 does not suffer from this, but its 
reproducible e.g. in 4.4.113 and 4.9.75

Any ideas?

Tommi
