From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Fri, 02 May 2014 16:52:56 +0000
Subject: RE: SCTP throughput does not scale
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E3348EA@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

So that you can readily understand the output below, a tiny bit of background.  There are 2 high performance blades communicating over a 10 Gbps dual-Ethernet-fabric backplane.  Each slot has two 10 Gbps NICs, each connected to one of the two segregated backplane fabrics.  The NIC names are p19p1 and p19p2.   The two blades are in slots 2 and 3, with hostnames 'slot2' and 'slot3' respectively.  The IP aliases for the two backplane IP addresses are 'slot2_0' and 'slot2_1' (for the two slot 2 IP addresses) and 'slot3_0' and 'slot3_1' (for the two slot 3 IP addresses).

To 'fairly' implement the 50 ms RTT, I add a 25 ms to each blade (rather than 50 ms to one of the two blades):

[root@slot2 ~]# tc qdisc show
qdisc netem 8002: dev p19p2 root refcnt 65 limit 1000 delay 25.0ms
qdisc netem 8001: dev p19p1 root refcnt 65 limit 1000 delay 25.0ms


[root@slot3 ~]# tc qdisc show
qdisc netem 8002: dev p19p2 root refcnt 65 limit 1000 delay 25.0ms
qdisc netem 8001: dev p19p1 root refcnt 65 limit 1000 delay 25.0ms


With the RTT implemented as such, I have a 50 ms RTT for both addresses used in the SCTP association (as well as any single IP used when performing the analogous test with TCP or UDP):

[root@slot2 ~]# ping slot3_0
PING slot3_0 (192.168.240.3) 56(84) bytes of data.
64 bytes from slot3_0 (192.168.240.3): icmp_req=1 ttld timeP.3 ms
64 bytes from slot3_0 (192.168.240.3): icmp_req=2 ttld timeP.6 ms
64 bytes from slot3_0 (192.168.240.3): icmp_req=3 ttld timeP.6 ms
(etc.)

 [root@slot2 ~]# ping slot3_1
PING slot3_1 (192.168.241.3) 56(84) bytes of data.
64 bytes from slot3_1 (192.168.241.3): icmp_req=1 ttld timeP.4 ms
64 bytes from slot3_1 (192.168.241.3): icmp_req=2 ttld timeP.4 ms
64 bytes from slot3_1 (192.168.241.3): icmp_req=3 ttld timeP.4 ms
(etc.)



-----Original Message-----
From: linux-sctp-owner@vger.kernel.org [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of Neil Horman
Sent: May-02-14 12:37 PM
To: Butler, Peter
Cc: linux-sctp@vger.kernel.org
Subject: Re: SCTP throughput does not scale

On Fri, May 02, 2014 at 04:33:23PM +0000, Butler, Peter wrote:
> The only entries from "tc qdisc show" are the ones used to implement the 50 ms RTT, which applies to all packet types (not just SCTP).
> 
Can you dump out the tc configuartion here?
Neil
rdomo info at  http://vger.kernel.org/majordomo-info.html
