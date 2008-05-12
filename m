From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 12 May 2008 15:11:09 +0000
Subject: [RFC PATCH v2] Fast retransmit fixes
Message-Id: <1210605072-12377-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This is an update to the Fast retransmit changes.

This fixes a small bug introduced by a prior series where the fast_rtx
hint in the outq structure was never cleared.

All prior comments still stand.

-vlad
