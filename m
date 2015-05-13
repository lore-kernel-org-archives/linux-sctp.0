From: Moohyoung KIM <emusal@gmail.com>
Date: Wed, 13 May 2015 02:14:47 +0000
Subject: Checksum at INIT ACK.
Message-Id: <FF69E842-A2CC-4870-9894-D355FFE80086@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear all,

I am currently trying to make an association with otter vendor's system. but it is failed.
The engineer of peer side requests me to set checksum parameter into INIT Ack. message we sent.

Q1. is it possible to differently set checksum value for each associations on linux-sctp?
Q2-1. If it is possible to set checksum separately, how to set the flag either use or not?
Q2-2. If it is NOT possible, we MUST turn the checksum feature on for whole association? how to do that? I am using lksctp-1.0.10-7 on Linux 2.6.32-432 (RHEL6).

Thanks