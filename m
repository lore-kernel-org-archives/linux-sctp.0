From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 03 Aug 2018 16:21:00 +0000
Subject: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180803162102.19540-1-khorenko@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
In-Reply-To: <20180724173647.GA8881@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

Each SCTP association can have up to 65535 input and output streams.
For each stream type an array of sctp_stream_in or sctp_stream_out
structures is allocated using kmalloc_array() function. This function
allocates physically contiguous memory regions, so this can lead
to allocation of memory regions of very high order, i.e.:

  sizeof(struct sctp_stream_out) = 24,
  ((65535 * 24) / 4096) = 383 memory pages (4096 byte per page),
  which means 9th memory order.

This can lead to a memory allocation failures on the systems
under a memory stress.

We actually do not need these arrays of memory to be physically
contiguous. Possible simple solution would be to use kvmalloc()
instread of kmalloc() as kvmalloc() can allocate physically scattered
pages if contiguous pages are not available. But the problem
is that the allocation can happed in a softirq context with
GFP_ATOMIC flag set, and kvmalloc() cannot be used in this scenario.

So the other possible solution is to use flexible arrays instead of
contiguios arrays of memory so that the memory would be allocated
on a per-page basis.

This patchset replaces kvmalloc() with flex_array usage.
It consists of two parts:

  * First patch is preparatory - it mechanically wraps all direct
    access to assoc->stream.out[] and assoc->stream.in[] arrays
    with SCTP_SO() and SCTP_SI() wrappers so that later a direct
    array access could be easily changed to an access to a
    flex_array (or any other possible alternative).
  * Second patch replaces kmalloc_array() with flex_array usage.

Oleg Babin (2):
  net/sctp: Make wrappers for accessing in/out streams
  net/sctp: Replace in/out stream arrays with flex_array

 include/net/sctp/structs.h   |  31 ++++----
 net/sctp/chunk.c             |   6 +-
 net/sctp/outqueue.c          |  11 +--
 net/sctp/socket.c            |   4 +-
 net/sctp/stream.c            | 165 +++++++++++++++++++++++++++++--------------
 net/sctp/stream_interleave.c |  20 +++---
 net/sctp/stream_sched.c      |  13 ++--
 net/sctp/stream_sched_prio.c |  22 +++---
 net/sctp/stream_sched_rr.c   |   8 +--
 9 files changed, 175 insertions(+), 105 deletions(-)

v2 changes:
 sctp_stream_in() users are updated to provide stream as an argument,
 sctp_stream_{in,out}_ptr() are now just sctp_stream_{in,out}().


Performance results:
==========
  * Kernel: v4.18-rc6 - stock and with 2 patches from Oleg (earlier in this thread)
  * Node: CPU (8 cores): Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
          RAM: 32 Gb

  * netperf: taken from https://github.com/HewlettPackard/netperf.git,
	     compiled from sources with sctp support
  * netperf server and client are run on the same node
  * ip link set lo mtu 1500

The script used to run tests:
 # cat run_tests.sh
 #!/bin/bash

for test in SCTP_STREAM SCTP_STREAM_MANY SCTP_RR SCTP_RR_MANY; do
  echo "TEST: $test";
  for i in `seq 1 3`; do
    echo "Iteration: $i";
    set -x
    netperf -t $test -H localhost -p 22222 -S 200000,200000 -s 200000,200000 \
            -l 60 -- -m 1452;
    set +x
  done
done
========================

Results (a bit reformatted to be more readable):
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

				v4.18-rc7	v4.18-rc7 + fixes
TEST: SCTP_STREAM
212992 212992   1452    60.21	1125.52		1247.04
212992 212992   1452    60.20	1376.38		1149.95
212992 212992   1452    60.20	1131.40		1163.85
TEST: SCTP_STREAM_MANY
212992 212992   1452    60.00	1111.00		1310.05
212992 212992   1452    60.00	1188.55		1130.50
212992 212992   1452    60.00	1108.06		1162.50

=====Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

					v4.18-rc7	v4.18-rc7 + fixes
TEST: SCTP_RR
212992 212992 1        1       60.00	45486.98	46089.43
212992 212992 1        1       60.00	45584.18	45994.21
212992 212992 1        1       60.00	45703.86	45720.84
TEST: SCTP_RR_MANY
212992 212992 1        1       60.00	40.75		40.77
212992 212992 1        1       60.00	40.58		40.08
212992 212992 1        1       60.00	39.98		39.97

-- 
2.15.1

