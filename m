From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Tue, 24 Jul 2018 15:35:35 +0000
Subject: Re: [PATCH net-next 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <b5ab1199-629b-1803-7826-ad74200bb34d@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180426222814.GA10301@localhost.localdomain>
In-Reply-To: <20180426222814.GA10301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On 04/27/2018 01:28 AM, Marcelo Ricardo Leitner wrote:
 > On Fri, Apr 27, 2018 at 01:14:56AM +0300, Oleg Babin wrote:
 >> Hi Marcelo,
 >>
 >> On 04/24/2018 12:33 AM, Marcelo Ricardo Leitner wrote:
 >>> Hi,
 >>>
 >>> On Mon, Apr 23, 2018 at 09:41:04PM +0300, Oleg Babin wrote:
 >>>> Each SCTP association can have up to 65535 input and output streams.
 >>>> For each stream type an array of sctp_stream_in or sctp_stream_out
 >>>> structures is allocated using kmalloc_array() function. This function
 >>>> allocates physically contiguous memory regions, so this can lead
 >>>> to allocation of memory regions of very high order, i.e.:
 >>>>
 >>>>   sizeof(struct sctp_stream_out) = 24,
 >>>>   ((65535 * 24) / 4096) = 383 memory pages (4096 byte per page),
 >>>>   which means 9th memory order.
 >>>>
 >>>> This can lead to a memory allocation failures on the systems
 >>>> under a memory stress.
 >>>
 >>> Did you do performance tests while actually using these 65k streams
 >>> and with 256 (so it gets 2 pages)?
 >>>
 >>> This will introduce another deref on each access to an element, but
 >>> I'm not expecting any impact due to it.
 >>>
 >>
 >> No, I didn't do such tests. Could you please tell me what methodology
 >> do you usually use to measure performance properly?
 >>
 >> I'm trying to do measurements with iperf3 on unmodified kernel and get
 >> very strange results like this:
 > ...
 >
 > I've been trying to fight this fluctuation for some time now but
 > couldn't really fix it yet. One thing that usually helps (quite a lot)
 > is increasing the socket buffer sizes and/or using smaller messages,
 > so there is more cushion in the buffers.
 >
 > What I have seen in my tests is that when it floats like this, is
 > because socket buffers floats between 0 and full and don't get into a
 > steady state. I believe this is because of socket buffer size is used
 > for limiting the amount of memory used by the socket, instead of being
 > the amount of payload that the buffer can hold. This causes some
 > discrepancy, especially because in SCTP we don't defrag the buffer (as
 > TCP does, it's the collapse operation), and the announced rwnd may
 > turn up being a lie in the end, which triggers rx drops, then tx cwnd
 > reduction, and so on. SCTP min_rto of 1s also doesn't help much on
 > this situation.
 >
 > On netperf, you may use -S 200000,200000 -s 200000,200000. That should
 > help it.

Hi Marcelo,

pity to abandon Oleg's attempt to avoid high order allocations and use
flex_array instead, so i tried to do the performance measurements with
options you kindly suggested.

Here are results:
   * Kernel: v4.18-rc6 - stock and with 2 patches from Oleg (earlier in this thread)
   * Node: CPU (8 cores): Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
           RAM: 32 Gb

   * netperf: taken from https://github.com/HewlettPackard/netperf.git,
	     compiled from sources with sctp support
   * netperf server and client are run on the same node

The script used to run tests:
# cat run_tests.sh
#!/bin/bash

for test in SCTP_STREAM SCTP_STREAM_MANY SCTP_RR SCTP_RR_MANY; do
   echo "TEST: $test";
   for i in `seq 1 3`; do
     echo "Iteration: $i";
     set -x
     netperf -t $test -H localhost -p 22222 -S 200000,200000 -s 200000,200000 -l 60;
     set +x
   done
done
========================

Results (a bit reformatted to be more readable):
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

				v4.18-rc6	v4.18-rc6 + fixes
TEST: SCTP_STREAM
212992 212992 212992    60.11       4.11	4.11
212992 212992 212992    60.11       4.11	4.11
212992 212992 212992    60.11       4.11	4.11
TEST: SCTP_STREAM_MANY
212992 212992   4096    60.00    1769.26	2283.85
212992 212992   4096    60.00    2309.59	858.43
212992 212992   4096    60.00    5300.65	3351.24

=====Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

					v4.18-rc6	v4.18-rc6 + fixes
TEST: SCTP_RR
212992 212992 1        1       60.00    44832.10	45148.68
212992 212992 1        1       60.00    44835.72	44662.95
212992 212992 1        1       60.00    45199.21	45055.86
TEST: SCTP_RR_MANY
212992 212992 1        1       60.00      40.90		45.55
212992 212992 1        1       60.00      40.65		45.88
212992 212992 1        1       60.00      44.53		42.15

As we can see single stream tests do not show any noticeable degradation,
and SCTP_*_MANY tests spread decreased significantly when -S/-s options are used,
but still too big to consider the performance test pass or fail.

Can you please advise anything else to try - to decrease the dispersion rate -
or can we just consider values are fine and i'm reworking the patch according
to your comment about sctp_stream_in(asoc, sid)/sctp_stream_in_ptr(stream, sid)
and that's it?

Thank you in advance!

--
Best regards,
Konstantin
