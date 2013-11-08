From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 08 Nov 2013 02:55:05 +0000
Subject: [PATCH net-next 0/5] sctp: fix and clean up
Message-Id: <1383879310-22792-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: dingtianhong@huawei.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

This patch series include: remove the duplicate initialize,
remove else path, fix one lost free, convert func to boolean,
fix some typos.

Wang Weidong (5):
  sctp: remove the duplicate initialize
  sctp: remove the else path
  sctp: if we done update ssnmap, free the new ssnmap
  sctp: convert sctp_peer_needs_update to boolean
  sctp: fix some typos in associola.c

 net/sctp/associola.c | 63 ++++++++++------------------------------------------
 1 file changed, 12 insertions(+), 51 deletions(-)

-- 
1.7.12


