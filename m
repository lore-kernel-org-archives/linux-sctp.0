From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 06 Dec 2013 01:36:26 +0000
Subject: [PATCH v3 net-next 0/4] sctp: do some clean ups
Message-Id: <1386293790-19956-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, vyasevich@gmail.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

This patch series include: remove the duplicate initialize,
make code simple, convert func to boolean, fix some typos.

v2 -> v3:
  - patch1: add Neil's ACK
  - patch2: add Joe's suggested and Neil's ACK
  - patch3: add Neil's ACK
  - patch4: add Neil's ACK

Wang Weidong (4):
  sctp: remove the duplicate initialize
  sctp: remove the else path
  sctp: convert sctp_peer_needs_update to boolean
  sctp: fix some comments in associola.c

 net/sctp/associola.c | 65 ++++++++--------------------------------------------
 1 file changed, 10 insertions(+), 55 deletions(-)

-- 
1.7.12


