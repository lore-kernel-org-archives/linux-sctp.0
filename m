From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 05:55:11 +0000
Subject: [PATCH 0/3] lksctp-tools: Some change of lksctp-tools for support
Message-Id: <4966E6BF.9000108@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad Yasevich:

I made some change to lksctp-tools package, which include one bug fix of
sctp_darn and two new functions. This will be used by our SCTP
conformance test suite, which will be release later as GPLv2. It will be
usedful for SCTP test.

Can you merge those three patch?

[PATCH 1/3] lksctp-tools: Fix -e option of sctp_darn
[PATCH 2/3] lksctp-tools: Add -T option to sctp_test
[PATCH 3/3] lksctp-tools: Add sctp_status for congestion control test
