From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:03:57 +0000
Subject: [PATCHv2 net-next 00/12] sctp: Implement Stream Interleave: The I-DATA Chunk Supporting User Message
Message-Id: <cover.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Stream Interleave would be Implemented in two Parts:

   1. The I-DATA Chunk Supporting User Message Interleaving
   2. Interaction with Other SCTP Extensions

Overview in section 1.1 of RFC8260 for Part 1:

   This document describes a new chunk carrying payload data called
   I-DATA.  This chunk incorporates the properties of the current SCTP
   DATA chunk, all the flags and fields except the Stream Sequence
   Number (SSN), and also adds two new fields in its chunk header -- the
   Fragment Sequence Number (FSN) and the Message Identifier (MID).  The
   FSN is only used for reassembling all fragments that have the same
   MID and the same ordering property.  The TSN is only used for the
   reliable transfer in combination with Selective Acknowledgment (SACK)
   chunks.

   In addition, the MID is also used for ensuring ordered delivery
   instead of using the stream sequence number (the I-DATA chunk omits
   an SSN).

As the 1st part of Stream Interleave Implementation, this patchset adds
an ops framework named sctp_stream_interleave with a bunch of stuff that
does lots of things needed somewhere.

Then it defines sctp_stream_interleave_0 to work for normal DATA chunks
and sctp_stream_interleave_1 for I-DATA chunks.

With these functions, hundreds of if-else checks for the different process
on I-DATA chunks would be avoided. Besides, very few codes could be shared
in these two function sets.

In this patchset, it adds some basic variables, structures and socket
options firstly, then implement these functions one by one to add the
procedures for ordered idata gradually, at last adjusts some codes to
make them work for unordered idata.

To make it safe to be implemented and also not break the normal data
chunk process, this feature can't be enabled to use until all stream
interleave codes are completely accomplished.

v1 -> v2:
  - fixed a checkpatch warning that a blank line was missed.
  - avoided a kbuild warning reported from gcc-4.9.

Xin Long (12):
  sctp: add stream interleave enable members and sockopt
  sctp: add asoc intl_enable negotiation during 4 shakehands
  sctp: add basic structures and make chunk function for idata
  sctp: implement make_datafrag for sctp_stream_interleave
  sctp: implement assign_number for sctp_stream_interleave
  sctp: implement validate_data for sctp_stream_interleave
  sctp: implement ulpevent_data for sctp_stream_interleave
  sctp: implement enqueue_event for sctp_stream_interleave
  sctp: implement renege_events for sctp_stream_interleave
  sctp: implement start_pd for sctp_stream_interleave
  sctp: implement abort_pd for sctp_stream_interleave
  sctp: add support for the process of unordered idata

 include/linux/sctp.h                 |   20 +
 include/net/netns/sctp.h             |    5 +-
 include/net/sctp/constants.h         |    9 +-
 include/net/sctp/sctp.h              |    4 +-
 include/net/sctp/sm.h                |   15 +-
 include/net/sctp/stream_interleave.h |   54 ++
 include/net/sctp/structs.h           |   56 +-
 include/net/sctp/ulpevent.h          |   23 +-
 include/net/sctp/ulpqueue.h          |   10 +-
 include/uapi/linux/sctp.h            |    3 +
 net/sctp/Makefile                    |    2 +-
 net/sctp/associola.c                 |    2 +-
 net/sctp/chunk.c                     |    8 +-
 net/sctp/output.c                    |    5 +-
 net/sctp/sm_make_chunk.c             |   45 +-
 net/sctp/sm_sideeffect.c             |   23 +-
 net/sctp/sm_statefuns.c              |   21 +-
 net/sctp/sm_statetable.c             |    3 +
 net/sctp/socket.c                    |  130 +++-
 net/sctp/stream.c                    |    1 +
 net/sctp/stream_interleave.c         | 1118 ++++++++++++++++++++++++++++++++++
 net/sctp/ulpevent.c                  |   15 +-
 net/sctp/ulpqueue.c                  |   23 +-
 23 files changed, 1501 insertions(+), 94 deletions(-)
 create mode 100644 include/net/sctp/stream_interleave.h
 create mode 100644 net/sctp/stream_interleave.c

-- 
2.1.0

