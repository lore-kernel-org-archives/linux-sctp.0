From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Jun 2008 13:49:07 +0000
Subject: [PATCH 0/2] sctp: Two small bugfixes.
Message-Id: <1213364949-9997-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

Hi David

The following are two small bug fixes that have been day-one bugs.

The first one takes care of the failure cases when creating /proc
entries.

The second, in addition to being the right thing to do, fixes
a problem with fast retransmit where the very first packet association
sends is never fast-rtxed.

Thanks
-vlad
