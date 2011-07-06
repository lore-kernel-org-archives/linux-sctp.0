From: =?UTF-8?B?Tmd1eeG7hW4gUGjGsOG7m2MgVGjDoG5o?= <ht22.pt@gmail.com>
Date: Wed, 06 Jul 2011 16:18:20 +0000
Subject: [Question LKSCTP] Reduce chunk HEARTBEAT
Message-Id: <4E148ACC.8020106@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I had code app transfer file with SCTP, I try test performance of my app 
with loss packet rate 0% app run ok.But with loss packet rate 10%, 
sometimes my app only send chunk HEARTBEAT and don't send data any more. 
I don't know how to reduce chunk HEARTBEAT send on association.I'm using 
LKSCTP 1.11 with Fedora 11 and Linux kernel 2.26.29. I am using iptables 
to simulate loss packet and present I am testing on interface lookpack.
Thanks a lots.
