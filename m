From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 11 Apr 2014 15:21:40 +0000
Subject: Re: Is SCTP throughput really this low compared to TCP?
Message-Id: <53480884.3060006@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 04/11/2014 05:07 PM, Butler, Peter wrote:
> Yes indeed this is ixgbe and I do have SCTP checksum offloading enabled.  (For what
 > it's worth, the checksum offload gives about a 20% throughput gain - but this is,
 > of course, already included in the numbers I posted to this thread as I've been using
 > the CRC offload all along.)

Ok, understood.

> I re-did all the tests with TSO/GSO/LRO/GRO disabled (on both sides of the association -
 > i.e. on both endpoint nodes), and using 1452-byte messages instead of 1000-byte
 > messages.  With this new setup, the TCP performance drops significantly, as expected,
 > while the SCTP performance is boosted, and the playing field is somewhat more 'level'.
 > (Note that I could not use 1464-byte messages as suggested by Vlad, as anything above
 > 1452 cut the SCTP performance in half - must have hit the segmentation limit at this
 > slightly lower message size.  MTU is 1500.)
>
> So comparing "apples to apples" now, TCP only out-performs SCTP by approximately 40-70%
 > over the various range of network latencies I tested with (RTTs of 0.2 ms, 10 ms, 20 ms,
 > and 50 ms).  40-70% is still significant, but nowhere near the 200% better (i.e. 3
 > times the throughput) I was getting before.
>
> Does this value (i.e. 40-70%) sound reasonable?  Is this the more-or-less accepted
 > performance difference with the current LKSCTP implementation?

Yes, that sounds reasonable to me. There are still a lot of open todos in terms of
performance that we need to tackle over time, e.g. the way chunks are handled, imho,
and copies involved in fast path, also that we're heavily using atomic reference
counting, and other open issues.

> Also, for what it's worth, I get better SCTP throughput numbers with the older kernel
 > (3.4.2) than with the newer kernel (3.14)...

Interesting, a lot of things happened in between; were you able to bisect/identify
a possible commit that causes this? How big is the difference?
