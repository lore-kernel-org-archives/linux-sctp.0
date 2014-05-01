From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 01 May 2014 22:51:36 +0000
Subject: Re: SCTP throughput does not scale
Message-Id: <5362CFF8.60005@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E333BF5@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 05/01/2014 01:55 PM, Butler, Peter wrote:
> It would appear that, in a latency-limited* network, the overall SCTP throughput for a given system does not scale.  That is, no matter how many associations are instantiated on a given system the overall throughput remains capped at the same limit.  This is in contrast to TCP and UDP where one can, for example, obtain twice the throughput by instantiating 2 TCP/UDP connections as opposed to only 1.
> 
> *The above observation applies to a network where the throughput is limited due to network latency as opposed to CPU and/or network bandwidth.  (In a low-latency system where throughput is instead limited by CPU and/or network bandwidth we would not expect to be able to obtain better throughput with more associations as the system/network is already maxed out).
> 
> Quantitative summary and detailed results are shown below for TCP and SCTP (UDP not shown, for brevity, but behavior is similar to TCP: 2 UDP 'connections' yield twice the throughput as 1 UDP 'connection', etc.).  
> 
> Testing performed on both the 3.4.2 kernel and 3.14.0 kernel, using iperf3, with a network RTT of 50 ms (manually implemented via tc-netem), using 1000-byte messages, with both send and receive socket kernel buffer sizes of 2 MB, over a 10 Gbps backplane (although for this particular testing (i.e. with 50 ms RTT latency) the high-speed backplane doesn't really factor in).
> 

Hi Peter

on the 3.14 kernel,  could you retest with
/proc/sys/net/sctp/max_burst = 0

Thanks
-vlad

> Summary (rounding errors included in numbers below):
> 
> TCP, 1 connection:    1 x 144 Mbps = 144 Mbps total throughput
> TCP, 2 connections:   2 x 144 Mbps = 287 Mbps total throughput
> TCP, 3 connections:   3 x 145 Mbps = 434 Mbps total throughput
> 
> SCTP, 1 association:    1 x 122 Mbps = 122 Mbps total throughput
> SCTP, 2 associations:   2 x 61.4 Mbps = 123 Mbps total throughput
> SCTP, 3 associations:   3 x 41.4 Mbps = 124 Mbps total throughput
> 
> TCP (and UDP, not shown) scales, SCTP does not.
> 
> 
> 
> Actual iperf3 output below.
> 
> 
> (1a) TCP, one connection
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 08:17:43 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398500263.347708.23b404
>       TCP MSS: 1448 (default)
> [  4] local 192.168.240.2 port 40776 connected to 192.168.240.3 port 5201
> Starting Test: protocol: TCP, 1 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-600.05 sec  10.1 GBytes   144 Mbits/sec    0             sender
> [  4]   0.00-600.05 sec  10.1 GBytes   144 Mbits/sec                  receiver
> CPU Utilization: local/sender 1.2% (0.1%u/1.1%s), remote/receiver 3.2% (0.3%u/2.9%s)
> 
> 
> 
> (1b) TCP, two connections
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 08:28:44 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398500924.026363.19e3a5
>       TCP MSS: 1448 (default)
> [  4] local 192.168.240.2 port 40780 connected to 192.168.240.3 port 5201
> [  6] local 192.168.240.2 port 40781 connected to 192.168.240.3 port 5201
> Starting Test: protocol: TCP, 2 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-600.05 sec  10.0 GBytes   144 Mbits/sec  137             sender
> [  4]   0.00-600.05 sec  10.0 GBytes   144 Mbits/sec                  receiver
> [  6]   0.00-600.05 sec  10.0 GBytes   144 Mbits/sec    2             sender
> [  6]   0.00-600.05 sec  10.0 GBytes   144 Mbits/sec                  receiver
> [SUM]   0.00-600.05 sec  20.1 GBytes   287 Mbits/sec  139             sender
> [SUM]   0.00-600.05 sec  20.0 GBytes   287 Mbits/sec                  receiver
> CPU Utilization: local/sender 2.5% (0.2%u/2.3%s), remote/receiver 4.4% (0.4%u/4.1%s)
> 
> 
> 
> (1c) TCP, three connections
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 08:39:44 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398501584.755085.3c10fa
>       TCP MSS: 1448 (default)
> [  4] local 192.168.240.2 port 40785 connected to 192.168.240.3 port 5201
> [  6] local 192.168.240.2 port 40786 connected to 192.168.240.3 port 5201
> [  8] local 192.168.240.2 port 40787 connected to 192.168.240.3 port 5201
> Starting Test: protocol: TCP, 3 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec    0             sender
> [  4]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec                  receiver
> [  6]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec    7             sender
> [  6]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec                  receiver
> [  8]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec    4             sender
> [  8]   0.00-600.05 sec  10.1 GBytes   145 Mbits/sec                  receiver
> [SUM]   0.00-600.05 sec  30.3 GBytes   434 Mbits/sec   11             sender
> [SUM]   0.00-600.05 sec  30.3 GBytes   434 Mbits/sec                  receiver
> CPU Utilization: local/sender 3.7% (0.3%u/3.4%s), remote/receiver 5.7% (0.5%u/5.3%s)
> 
> 
> 
> (2a) SCTP, one association
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 05:30:34 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398490234.326620.36ee2f
>  [  4] local 192.168.240.2 port 46631 connected to 192.168.240.3 port 5201
> Starting Test: protocol: SCTP, 1 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-600.07 sec  8.52 GBytes   122 Mbits/sec                  sender
> [  4]   0.00-600.07 sec  8.52 GBytes   122 Mbits/sec                  receiver
> CPU Utilization: local/sender 4.1% (0.2%u/3.9%s), remote/receiver 2.0% (0.2%u/1.8%s)
> 
> 
> 
> (2b) SCTP, two associations
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 05:41:35 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398490895.079359.28c5c1
>  [  4] local 192.168.240.2 port 34175 connected to 192.168.240.3 port 5201
>  [  6] local 192.168.240.2 port 41448 connected to 192.168.240.3 port 5201
> Starting Test: protocol: SCTP, 2 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-600.09 sec  4.29 GBytes  61.4 Mbits/sec                  sender
> [  4]   0.00-600.09 sec  4.29 GBytes  61.4 Mbits/sec                  receiver
> [  6]   0.00-600.09 sec  4.29 GBytes  61.4 Mbits/sec                  sender
> [  6]   0.00-600.09 sec  4.29 GBytes  61.4 Mbits/sec                  receiver
> [SUM]   0.00-600.09 sec  8.58 GBytes   123 Mbits/sec                  sender
> [SUM]   0.00-600.09 sec  8.58 GBytes   123 Mbits/sec                  receiver
> CPU Utilization: local/sender 2.5% (0.1%u/2.4%s), remote/receiver 1.7% (0.2%u/1.5%s)
> 
> 
> 
> (2c) SCTP, three associations
> 
> iperf version 3.0.1 (10 January 2014)
> Linux Lab200slot2 3.4.2-1.fc16.x86_64 #1 SMP Thu Jun 14 20:17:26 UTC 2012 x86_64
> Time: Sat, 26 Apr 2014 05:52:36 GMT
> Connecting to host 192.168.240.3, port 5201
>       Cookie: Lab200slot2.1398491555.947776.10993d
>  [  4] local 192.168.240.2 port 45551 connected to 192.168.240.3 port 5201
>  [  6] local 192.168.240.2 port 35528 connected to 192.168.240.3 port 5201
>  [  8] local 192.168.240.2 port 44540 connected to 192.168.240.3 port 5201
> Starting Test: protocol: SCTP, 3 streams, 1000 byte blocks, omitting 0 seconds, 600 second test
> .
> . <snip>
> .
> Test Complete. Summary Results:
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  sender
> [  4]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  receiver
> [  6]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  sender
> [  6]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  receiver
> [  8]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  sender
> [  8]   0.00-600.08 sec  2.90 GBytes  41.4 Mbits/sec                  receiver
> [SUM]   0.00-600.08 sec  8.69 GBytes   124 Mbits/sec                  sender
> [SUM]   0.00-600.08 sec  8.69 GBytes   124 Mbits/sec                  receiver
> CPU Utilization: local/sender 2.6% (0.1%u/2.5%s), remote/receiver 1.6% (0.1%u/1.5%s)
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

