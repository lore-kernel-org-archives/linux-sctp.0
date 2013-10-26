From: Wang Weidong <wangweidong1@huawei.com>
Date: Sat, 26 Oct 2013 08:06:29 +0000
Subject: [PATCH v2 0/3] sctp: do some clean up and fix comments
Message-Id: <1382774792-13440-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This patch series includes some comments fix, merge tow if-statements,
remove the repeat initialize with 0.

v1 -> v2:
  - patch1: combine two comment typos fix patches into one,
    as suggested by Vlad, and add his ACK.
  - patch2: add Vlad's ACK.
  - patch3: line up 2 parts of 'if' statements, as suggested by Vlad.
    fix some comment typos, as suggested by Sergei.

Wang Weidong (3):
  sctp: fix some comments in chunk.c and associola.c
  sctp: remove the repeat initialize with 0
  sctp: merge two if statements to one

 net/sctp/associola.c     |  4 ++--
 net/sctp/auth.c          | 14 +++++---------
 net/sctp/chunk.c         |  2 +-
 net/sctp/sm_make_chunk.c | 29 ++++++++---------------------
 4 files changed, 16 insertions(+), 33 deletions(-)

-- 
1.7.12


