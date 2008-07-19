From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 19 Jul 2008 04:26:45 +0000
Subject: [PATC] sctp: various fixes
Message-Id: <12164416121552-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org

Hi David

This is a bunch of SCTP fixes that have accumlated over the past week or
so. 

Here is the shortlog:

Florian Westphal (2):
      sctp: Don't abort initialization when CONFIG_PROC_FS=n
      sctp: Prevent uninitialized memory access

Harvey Harrison (1):
      sctp: remove unnecessary byteshifting, calculate directly in big-endian

Vlad Yasevich (4):
      sctp: Support ipv6only AF_INET6 sockets.
      sctp: Do not leak memory on multiple listen() calls
      sctp: Allow only 1 listening socket with SO_REUSEADDR
      sctp: Update sctp global memory limit allocations.

Please apply.  Thanks
-vlad
