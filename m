From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 18 Feb 2014 11:22:06 +0000
Subject: [ANNOUNCE] lksctp-tools-1.0.16
Message-Id: <5303425E.4000003@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The user space package is available at:
	http://lksctp.org/

You can download the source from:
	git://github.com/borkmann/lksctp-tools.git

---
Daniel Borkmann (2):
       sctp_status: fix usage of max_stream parameter
       Release lksctp-tools-1.0.16

Hangbin Liu (5):
       Remove duplicate sys/errno.h
       Move bzero to memset
       test_1_to_1_sockopt: we have changed the minimum value to 2048
       sctp_status: add missed parameter description and remove unused option
       sctp_status: server side should also receive msg_cnt times

Markos Chandras (1):
       lib/connectx: Fix build for prefixed architectures

Matija Glavinic Pecotic (1):
       Remove dependency to implementation-specific a_rwnd behavior

Simon Xu (1):
       lksctp: Avoid using file descriptor 0 to get ENOTSOCK

Wang Weidong (1):
       tests: fix test_1_to_1_sockopt sock buff test case
