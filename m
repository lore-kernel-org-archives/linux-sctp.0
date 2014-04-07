From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Mon, 07 Apr 2014 22:14:40 +0000
Subject: LKSCTP tuning
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31A774@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Are the values in /proc/sys/net/sctp/sctp_[rw]mem honored?  Or are they overridden by those in /proc/sys/net/core/[rw]mem_*

Furthermore, the kernel documentation states that sctp_wmem has no effect, but makes no such mention for sctp_mem and sctp_rmem.


