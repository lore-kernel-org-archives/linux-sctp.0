From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 08 Nov 2013 06:17:47 +0000
Subject: [PATCH net-next v2 0/4] sctp: do some clean ups
Message-Id: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This patch series include: remove the duplicate initialize,                                                                                                
make code simple, convert func to boolean, fix some typos.

v1 -> v2:
  - patch2: make the code more simplification, as suggested
    by Joe Perches.

Wang Weidong (4):
  sctp: remove the duplicate initialize
  sctp: remove the else path
  sctp: convert sctp_peer_needs_update to boolean
  sctp: fix some comments in associola.c

 net/sctp/associola.c | 65 ++++++++--------------------------------------------
 1 file changed, 10 insertions(+), 55 deletions(-)

-- 
1.7.12


