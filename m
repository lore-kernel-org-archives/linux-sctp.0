From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 23 Jul 2017 01:34:25 +0000
Subject: [PATCH net-next 00/11] sctp: remove typedefs from structures part 3
Message-Id: <cover.1500773578.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1498794481.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1498794481.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

As we know, typedef is suggested not to use in kernel, even checkpatch.pl
also gives warnings about it. Now sctp is using it for many structures.

All this kind of typedef's using should be removed. This patchset is the
part 3 to remove it for another 11 basic structures from linux/sctp.h.

Just as the part 1 and 2, No any code's logic would be changed in these
patches, only cleaning up.

Xin Long (11):
  sctp: remove the typedef sctp_initack_chunk_t
  sctp: remove the typedef sctp_cookie_param_t
  sctp: remove the typedef sctp_unrecognized_param_t
  sctp: remove the typedef sctp_gap_ack_block_t
  sctp: remove the typedef sctp_dup_tsn_t
  sctp: remove the typedef sctp_sack_variable_t
  sctp: remove the typedef sctp_sackhdr_t
  sctp: remove the typedef sctp_sack_chunk_t
  sctp: remove the typedef sctp_heartbeathdr_t
  sctp: remove the typedef sctp_heartbeat_chunk_t
  sctp: remove the typedef sctp_abort_chunk_t

 include/linux/sctp.h       | 53 +++++++++++++++++++++++-----------------------
 include/net/sctp/command.h |  4 ++--
 net/sctp/chunk.c           |  2 +-
 net/sctp/outqueue.c        | 10 ++++-----
 net/sctp/sm_make_chunk.c   | 18 +++++++++-------
 net/sctp/sm_statefuns.c    | 50 ++++++++++++++++++++-----------------------
 6 files changed, 68 insertions(+), 69 deletions(-)

-- 
2.1.0

