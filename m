From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 03 Aug 2017 07:42:08 +0000
Subject: [PATCH net-next 00/14] sctp: remove typedefs from structures part 4
Message-Id: <cover.1501745729.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

As we know, typedef is suggested not to use in kernel, even checkpatch.pl
also gives warnings about it. Now sctp is using it for many structures.

All this kind of typedef's using should be removed. This patchset is the
part 4 to remove it for another 14 basic structures from linux/sctp.h.
After this patchset, all typedefs are cleaned in linux/sctp.h.

Just as the part 1-3, No any code's logic would be changed in these patches,
only cleaning up.

Xin Long (14):
  sctp: remove the typedef sctp_shutdownhdr_t
  sctp: fix the name of struct sctp_shutdown_chunk_t
  sctp: remove the typedef sctp_errhdr_t
  sctp: remove the typedef sctp_operr_chunk_t
  sctp: remove the typedef sctp_error_t
  sctp: remove the typedef sctp_ecnehdr_t
  sctp: remove the typedef sctp_ecne_chunk_t
  sctp: remove the typedef sctp_cwrhdr_t
  sctp: remove the typedef sctp_cwr_chunk_t
  sctp: remove the typedef sctp_addip_param_t
  sctp: remove the typedef sctp_addiphdr_t
  sctp: remove the typedef sctp_addip_chunk_t
  sctp: remove the typedef sctp_authhdr_t
  sctp: remove the typedef sctp_auth_chunk_t

 include/linux/sctp.h     |  69 +++++++++++++--------------
 include/net/sctp/sctp.h  |   8 ++--
 net/sctp/chunk.c         |   2 +-
 net/sctp/input.c         |   2 +-
 net/sctp/sm_make_chunk.c | 119 ++++++++++++++++++++++++-----------------------
 net/sctp/sm_sideeffect.c |   2 +-
 net/sctp/sm_statefuns.c  | 107 ++++++++++++++++++++++--------------------
 net/sctp/ulpevent.c      |  10 ++--
 8 files changed, 162 insertions(+), 157 deletions(-)

-- 
2.1.0

