From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Mar 2009 19:49:16 +0000
Subject: [PATCH net-next 0/4] sctp: clean-ups and fixes
Message-Id: <1236887360-1904-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Hi David

This a small set of fixes in sctp:
 1) clean up and simplify sctp listening code.
 2) fix ASCONF indication in INIT-ACK.
 3) send FORWARD TSN chunks only when peer supports the extension.
 4) include Adaptation Indication parameter only when user set it.

Thanks
-vlad
