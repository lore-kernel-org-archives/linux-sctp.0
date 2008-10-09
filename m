From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 09 Oct 2008 13:29:31 +0000
Subject: [PATCH net-next 0/3] sctp: Fixes for SNMP counters
Message-Id: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org


The following three patches fix a few SNMP counters.

1) When the Add-Ip timer expires and we tear down the association, the
SCTP_MIB_CURRESTAB should be decremented.

2) When processing a violation and discrding the packet instead of tearning
down the association, do not change SCTP_MIB_ABORTEDS since we didn't really
abort.

3) When the T5-timer expires and we abort the association, count
SCTP_MIB_ABORTEDS.

-vlad
