From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 06 Apr 2016 17:53:11 +0000
Subject: [PATCH v2 0/2] sctp: delay calls to sk_data_ready() as much as possible
Message-Id: <cover.1459952558.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

1st patch is a preparation for the 2nd. The idea is to not call
->sk_data_ready() for every data chunk processed while processing
packets but only once before releasing the socket.

v2: patchset re-checked, small changelog fixes

Marcelo Ricardo Leitner (2):
  sctp: compress bit-wide flags to a bitfield on sctp_sock
  sctp: delay calls to sk_data_ready() as much as possible

 include/net/sctp/structs.h | 13 +++++++------
 net/sctp/sm_sideeffect.c   |  5 +++++
 net/sctp/ulpqueue.c        |  4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.5.0

