From: Oleg Babin <obabin@virtuozzo.com>
Date: Mon, 23 Apr 2018 18:41:04 +0000
Subject: [PATCH net-next 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

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

 include/net/sctp/structs.h   |  31 +++++---
 net/sctp/chunk.c             |   6 +-
 net/sctp/outqueue.c          |  11 +--
 net/sctp/socket.c            |   4 +-
 net/sctp/stream.c            | 165 +++++++++++++++++++++++++++++--------------
 net/sctp/stream_interleave.c |   2 +-
 net/sctp/stream_sched.c      |  13 ++--
 net/sctp/stream_sched_prio.c |  22 +++---
 net/sctp/stream_sched_rr.c   |   8 +--
 9 files changed, 167 insertions(+), 95 deletions(-)

-- 
1.8.3.1

