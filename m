From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 19 Dec 2013 06:51:57 +0000
Subject: [PATCH net-next 0/5] sctp: fix checkpatch errors
Message-Id: <1387435922-24152-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

fix checkpatch errors.

Wang Weidong (5):
  sctp: fix checkpatch errors with space required or prohibited
  sctp: fix checkpatch errors with foo
  sctp: fix checkpatch errors with indent
  sctp: fix checkpatch errors
  sctp: fix checkpatch errors with //commen

 net/sctp/auth.c          | 27 +++++++++---------
 net/sctp/chunk.c         |  4 +--
 net/sctp/input.c         | 58 +++++++++++++++++++--------------------
 net/sctp/ipv6.c          |  2 +-
 net/sctp/objcnt.c        |  2 +-
 net/sctp/output.c        | 11 ++++----
 net/sctp/outqueue.c      |  8 +++---
 net/sctp/proc.c          |  8 +++---
 net/sctp/protocol.c      |  4 +--
 net/sctp/sm_make_chunk.c | 71 ++++++++++++++++++++++++------------------------
 net/sctp/sm_sideeffect.c |  4 +--
 net/sctp/sm_statefuns.c  | 27 +++++++++---------
 net/sctp/sm_statetable.c |  2 +-
 net/sctp/socket.c        | 53 ++++++++++++++++++------------------
 net/sctp/sysctl.c        |  2 +-
 net/sctp/ulpqueue.c      | 11 ++++----
 16 files changed, 145 insertions(+), 149 deletions(-)

-- 
1.7.12


