From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Fri, 11 Apr 2014 19:24:38 +0000
Subject: RE: Is SCTP throughput really this low compared to TCP?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31B632@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I can certainly try that patch, however see the previous email where Daniel suggested that the issue may be IPv4 only.  I have subsequently tested it (email sent out 5 minutes ago) and he was right: IPv6 is smooth, whereas IPv4 is erratic.

Although even when using the smooth IPv6 behaviour, the 3.4.2 throughput is still better than 3.14; for example, 2.1 Gbps in the 'no' latency case (0.2 ms RTT) on 3.4.2 but only 1.6 Gbps with 3.14.

Should I try out the patch, or does the IPv4 vs IPv6 data shed new light on this?




-----Original Message-----
From: Vlad Yasevich [mailto:vyasevich@gmail.com] 
Sent: April-11-14 3:21 PM
To: Butler, Peter; Daniel Borkmann
Cc: linux-sctp@vger.kernel.org
Subject: Re: Is SCTP throughput really this low compared to TCP?

On 04/11/2014 02:22 PM, Butler, Peter wrote:
> The difference between 3.14 and 3.4.2 is staggering.  An order of
magnitude or so.  For example, using the precisely same setup as before, whereas I get about 2.1 Gbps throughput with 3.4 2, I can only manage between 70-150 Mbps with 3.14 - a staggering difference.
>
> Moreover, the SCTP throughput seems to 'choke' itself with 3.14, such
that it is always trying to recover.  For example, with 3.4.2 the 2.1 Gbps throughput is quite consistent from one second to the next (as you would expect):
>
> but with 3.14 the numbers as all over the place:
>
> [root@Lab200slot2 ~]# iperf3 --sctp -4 -c 192.168.241.3 -V -l 1452 -t 
> 60 iperf version 3.0.1 (10 January 2014) Linux Lab200slot2 3.14.0 #1 
> SMP Thu Apr 3 23:18:29 EDT 2014 x86_64
> Time: Fri, 11 Apr 2014 17:56:21 GMT
> Connecting to host 192.168.241.3, port 5201
>       Cookie: Lab200slot2.1397238981.812898.548918
> [  4] local 192.168.241.2 port 38616 connected to 192.168.241.3 port 
> 5201 Starting Test: protocol: SCTP, 1 streams, 1452 byte blocks, 
> omitting 0
seconds, 60 second test
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-1.09   sec  20.8 MBytes   161 Mbits/sec
> [  4]   1.09-2.13   sec  10.8 MBytes  86.8 Mbits/sec
> [  4]   2.13-3.15   sec  3.57 MBytes  29.5 Mbits/sec
> [  4]   3.15-4.16   sec  4.33 MBytes  35.7 Mbits/sec
> [  4]   4.16-6.21   sec  10.4 MBytes  42.7 Mbits/sec
> [  4]   6.21-6.21   sec  0.00 Bytes  0.00 bits/sec
> [  4]   6.21-7.35   sec  34.6 MBytes   253 Mbits/sec
> [  4]   7.35-11.45  sec  22.0 MBytes  45.0 Mbits/sec
> [  4]  11.45-11.45  sec  0.00 Bytes  0.00 bits/sec [  4]  11.45-11.45  
> sec  0.00 Bytes  0.00 bits/sec [  4]  11.45-11.45  sec  0.00 Bytes  
> 0.00 bits/sec
> [  4]  11.45-12.51  sec  16.0 MBytes   126 Mbits/sec
> [  4]  12.51-13.59  sec  20.3 MBytes   158 Mbits/sec
> [  4]  13.59-14.65  sec  13.4 MBytes   107 Mbits/sec
> [  4]  14.65-16.79  sec  33.3 MBytes   130 Mbits/sec
> [  4]  16.79-16.79  sec  0.00 Bytes  0.00 bits/sec [  4]  16.79-17.82  
> sec  5.94 MBytes  48.7 Mbits/sec
> (etc)
>
> Note: the difference appears to be SCTP-specific, as I get exactly the
same TCP throughput in both kernels.
>

Ouch.  That is not very good behavior...  I wonder if this a side-effect of the new rwnd algorithm...

In fact, I think I do see a small problem with the algorithm.

Can you try this patch:

<snipped>
