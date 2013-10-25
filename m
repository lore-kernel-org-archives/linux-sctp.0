From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 25 Oct 2013 03:45:44 +0000
Subject: [PATCH net-next 0/4] sctp: do some clean up and fix comments
Message-Id: <1382672748-10156-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This patch series includes some comments fix, merge two if-statements,
remove the repeat initialize with 0.

Wang Weidong (4):
  sctp: merge two if statements to one
  sctp: remove the repeat initialize with 0
  sctp: fix some comments in associola.c
  sctp: fix comment in chunk.c

 net/sctp/associola.c     |  4 ++--
 net/sctp/auth.c          | 12 ++++--------
 net/sctp/chunk.c         |  2 +-
 net/sctp/sm_make_chunk.c | 29 ++++++++---------------------
 4 files changed, 15 insertions(+), 32 deletions(-)

-- 
1.7.12


