From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 08 May 2014 12:55:00 +0000
Subject: [net-next 0/2] sctp: fix kfree static array pointer in sctp_sysctl_net_unregister
Message-Id: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

patch #1 revert the efb842c45("sctp: optimize the sctp_sysctl_net_register")
patch #2 add a checking for sctp_sysctl_net_register

Wang Weidong (2):
  Revert "sctp: optimize the sctp_sysctl_net_register"
  sctp: add a checking for sctp_sysctl_net_register

 net/sctp/sysctl.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

-- 
1.7.12


