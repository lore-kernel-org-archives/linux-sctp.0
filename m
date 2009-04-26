From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sun, 26 Apr 2009 15:08:22 +0000
Subject: [PATCH 0/2] Fix two kernel panic after we removed transport by ASCONF
Message-Id: <49F478E6.8020906@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patchset fix two kernel panic after we removed transport by
ASCONF.

[PATCH 1/2] sctp: fix panic when T2-shutdown timer expire on removed transport
[PATCH 2/2] sctp: fix panic when T4-rto timer expire on removed transport


