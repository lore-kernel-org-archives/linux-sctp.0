From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Tue, 08 Apr 2014 15:38:39 +0000
Subject: Are sctp_mem, sctp_rmem and sctp_wmem not honored?
Message-Id: <1383F7BACEF3F141A39A7AC90F80407E31A931@psmwsonsmbx01.sonusnet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Are the sctp_mem, sctp_rmem and sctp_wmem values (set in /proc/sys/net/sctp) not honored?

It would appear that they are not honored, although some kernel documentation states that they are (or that at least some of them are).

It seems like the actual values are coming from /proc/sys/net/core and that the sctp-specific ones are simply ignored...


