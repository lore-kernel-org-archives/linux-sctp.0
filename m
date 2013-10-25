From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 25 Oct 2013 01:50:01 +0000
Subject: [PATCH 0/4] sctp: do some clean up and fix comments
Message-Id: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

I found: two if statements do the same work, we can merge to one;
kmem_cache_zalloc will reset the memory, no need do the work
which initialize with 0; some spelling errors, then fix them.

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


