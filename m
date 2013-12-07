From: Wang Weidong <wangweidong1@huawei.com>
Date: Sat, 07 Dec 2013 07:17:29 +0000
Subject: [PATCH v5 0/2] sctp: check the rto_min and rto_max
Message-Id: <1386400651-21744-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

v4 -> v5
  - patch1: add marco in constants.h and fix up spacing as
    suggested by Daniel
  - patch2: add a patch for fix up do_hmac_alg for according
    to do_rto_min[max]

Wang Weidong (2):
  sctp: check the rto_min and rto_max
  sctp: fix up a spacing

 include/net/sctp/constants.h |  3 ++
 net/sctp/socket.c            |  5 +++
 net/sctp/sysctl.c            | 80 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 11 deletions(-)

-- 
1.7.12


