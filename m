From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 08 Apr 2016 19:41:26 +0000
Subject: [PATCH v3 0/2] sctp: delay calls to sk_data_ready() as much as possible
Message-Id: <cover.1460144373.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>, Jakub Sitnicki <jkbs@redhat.com>

1st patch is a preparation for the 2nd. The idea is to not call
->sk_data_ready() for every data chunk processed while processing
packets but only once before releasing the socket.

v2: patchset re-checked, small changelog fixes
v3: on patch 2, make use of local vars to make it more readable

Marcelo Ricardo Leitner (2):
  sctp: compress bit-wide flags to a bitfield on sctp_sock
  sctp: delay calls to sk_data_ready() as much as possible

 include/net/sctp/structs.h | 13 +++++++------
 net/sctp/sm_sideeffect.c   |  7 +++++++
 net/sctp/ulpqueue.c        |  4 ++--
 3 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.5.0

