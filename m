From: Wang Weidong <wangweidong1@huawei.com>
Date: Tue, 10 Dec 2013 02:46:34 +0000
Subject: [PATCH v6 0/3] sctp: check the rto_min and rto_max
Message-Id: <1386643597-22156-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

v5 -> v6
  -patch1: do rto_min/max socket option handling in its own patch, and
   fix the check of rto_min/max.
  -patch2: do rto_min/max sysctl handling in its own patch.
  -patch3: add Suggested-by Daniel.

Wang Weidong (3):
  sctp: check the rto_min and rto_max in setsockopt
  sctp: add check rto_min and rto_max in sysctl
  sctp: fix up a spacing

 net/sctp/socket.c | 32 +++++++++++++++--------
 net/sctp/sysctl.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 89 insertions(+), 19 deletions(-)

-- 
1.7.12


