From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 04 Jun 2008 18:25:45 +0000
Subject: [PATCH 0/6] [SCTP] Bug fixes
Message-Id: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net


The following is a series of patches that correct the following bugs:
  1.  Correctly pick the a retransmission path when we have more the one
      path, but only 1 is active.

  2.  Fix multiple problems with fast retransmit.  These include: not
      restrating retransmission timers, incorrectly decrementing congestion
      widow, and sending multiple packets during fast retransmit.

  3.  Fix ECN markings when sending over IPv6.  SCTP be default marks
      that it's ECN capable.  I found that it has changed not too long
      ago.

There was also a small cleanup.

Please apply.

Thanks
-vlad
