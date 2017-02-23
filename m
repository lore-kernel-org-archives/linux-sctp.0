From: "Jonathan T. Leighton" <jtleight@udel.edu>
Date: Thu, 23 Feb 2017 22:42:31 +0000
Subject: netinet/sctp.h or linux/sctp.h?
Message-Id: <333c3b86-5715-b8e7-5b7d-36051456ffdd@udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I typically include netinet/sctp.h, but I've noticed that linux/sctp.h 
contains some definitions that are not in netinet/sctp.h and which give 
me access to a few additional socket options, such as SCTP_RECVRCVMSG. 
Why does netinet/sctp.h not contain definitions for a few of the options 
that the kernel supports?

- Jon
