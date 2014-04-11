From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 11 Apr 2014 15:27:59 +0000
Subject: Re: Is SCTP throughput really this low compared to TCP?
Message-Id: <534809FF.4050509@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 04/11/2014 11:07 AM, Butler, Peter wrote:
> Yes indeed this is ixgbe and I do have SCTP checksum offloading enabled.  (For what it's worth, the checksum offload gives about a 20% throughput gain - but this is, of course, already included in the numbers I posted to this thread as I've been using the CRC offload all along.)
> 
> I re-did all the tests with TSO/GSO/LRO/GRO disabled (on both sides of the association - i.e. on both endpoint nodes), and using 1452-byte messages instead of 1000-byte messages.  With this new setup, the TCP performance drops significantly, as expected, while the SCTP performance is boosted, and the playing field is somewhat more 'level'.   (Note that I could not use 1464-byte messages as suggested by Vlad, as anything above 1452 cut the SCTP performance in half - must have hit the segmentation limit at this slightly lower message size.  MTU is 1500.)
> 
> So comparing "apples to apples" now, TCP only out-performs SCTP by approximately 40-70% over the various range of network latencies I tested with (RTTs of 0.2 ms, 10 ms, 20 ms, and 50 ms).  40-70% is still significant, but nowhere near the 200% better (i.e. 3 times the throughput) I was getting before.
> 
> Does this value (i.e. 40-70%) sound reasonable? 

This still looks high.  Could you run 'perf record -a' and 'perf report'
to see where we are spending all of our time in sctp.

My guess is that a lot of it is going to be in memcpy(), but I am
curious.

> Is this the more-or-less accepted performance difference with the current LKSCTP implementation?
> 
> Also, for what it's worth, I get better SCTP throughput numbers with the older kernel (3.4.2) than with the newer kernel (3.14)...
> 

That's interesting.  I'll have to look at see what might have changed here.

-vlad

> 
> 
> -----Original Message-----
> From: Daniel Borkmann [mailto:dborkman@redhat.com] 
> Sent: April-11-14 3:43 AM
> To: Vlad Yasevich
> Cc: Butler, Peter; linux-sctp@vger.kernel.org
> Subject: Re: Is SCTP throughput really this low compared to TCP?
> 
> Hi Peter,
> 
> On 04/10/2014 10:21 PM, Vlad Yasevich wrote:
>> On 04/10/2014 03:12 PM, Butler, Peter wrote:
>>> I've been testing SCTP throughput between two nodes over a 10Gb-Ethernet backplane, and am finding that at best, its throughput is about a third of that of TCP.  Is this number generally accepted for current LKSCTP performance?
>>>
>>> All TCP/SCTP tests performed with 1000-byte (payload) messages, between 8-core Xeon nodes @ 2.13GHz, with no CPU throttling (always running at 100%) on otherwise idle systems.  Test applications include netperf, iperf and proprietary in-house stubs.
>>>
>>> The latency between nodes is generally 0.2 ms.  Tests were run using this low-latency scenario, as well as using traffic control (tc) to simulate networks with 10 ms, 20 ms and 50 ms latency (i.e. 20 ms, 40 ms and 100 ms RTT, respectively).
>>>
>>> In addition, each of these network scenarios were tested using various kernel socket buffer sizes, ranging from the default kernel size (100-200 kB), to several MB for send and receive buffers, and multiple send:receive ratios for these buffer sizes (generally using larger receive buffer sizes, up to a factor of about 6).
>>>
>>> Finally, tests were performed on kernels as old as 3.4.2 and as recent as 3.14.
>>>
>>> The TCP throughput is about 3x higher than that of SCTP as a best-case scenario (i.e. from an SCTP perspective), and much higher still in worst-case scenarios.
>>
>> To do a more of apples-to-apples comparison, you need to disable 
>> tso/gso on the sending node.
>>
>> The reason is that even if you limit buffer sizes, tcp will still try 
>> to do tso on the transmit size, thus coalescing you 1000-byte messages 
>> into something much larger, thus utilizing your MTU much more efficiently.
>>
>> SCTP, on the other hand, has to preserve message boundaries which 
>> results in sub-optimal mtu utilization when using 1000-byte payloads.
>>
>> My recommendation is to use 1464 byte message for SCTP on a 1500 byte 
>> MTU nic.
>>
>> I would be interested to see the results.  There could very well be issues.
> 
> Agreed.
> 
> Also, what NIC are you using? It seems only Intel provides SCTP checksum offloading so far, i.e. ixgbe/i40e NICs.
> 
>> -vlad

