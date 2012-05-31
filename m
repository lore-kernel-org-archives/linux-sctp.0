From: Peter Butler <PButler@pt.com>
Date: Thu, 31 May 2012 16:28:09 +0000
Subject: crc32c_intel vs libcrc32c
Message-Id: <OF37C8B3DB.4464FF3A-ON85257A0F.005A2106-85257A0F.005A77CC@pt.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I have a system with SSE4.2 and thus hardware support for CRC32C 
calculations.  I can manually load the crc32c_intel module, however when I 
do an lsmod I see:

[root@peterFC16 ~]# lsmod | grep -E 'crc|sctp'
crc32c_intel           12770  0 
libcrc32c              12603  1 sctp
sctp                  203671  2 

Does this mean that SCTP is not actually using the crc32c_intel module? If 
so, how do I remedy that?


