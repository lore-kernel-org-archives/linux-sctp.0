From: Naruto Nguyen <narutonguyen2018@gmail.com>
Date: Thu, 28 Nov 2019 11:36:28 +0000
Subject: SCTP conntrack does not track init chunk types
Message-Id: <CANpxKHFkTApZufGkL-7JSwt0BqTmPpp1=77jVhrqHZdo74e0Sw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi everyone,

I have followed a simple SCTP server and SCTP client at
http://simplestcodings.blogspot.com/2010/08/sctp-server-client-implementation-in-c.html

It works well. Client and server can communicate successfully. Then I
tried to set up an iptable rule to drop INIT package on server node

iptables -A INPUT -p sctp  -m conntrack --ctstate NEW -m sctp
--chunk-types any INIT -j DROP

It can drop and connection cannot establish from client anymore.
However, when I tried to drop INIT_ACK sent from server by

iptables -A OUTPUT -p sctp  -m conntrack --ctstate NEW -m sctp
--chunk-types any INIT_ACK -j DROP

looks like it cannot drop INIT_ACK and connection from client is setup
well. Could you please tell me if SCTP conntrack can drop INIT_ACK,
COOKIE_ACK? My conntrack log does not show any INIT, INIT_ACK,
COOKIE_ACK

[NEW] sctp     132 3 src9.569.9.50 dst9.569.9.51 sportW295
dportb324 [UNREPLIED] src9.569.9.51 dst9.569.9.50 sportb324
dportW295
 [UPDATE] sctp     132 3 src9.569.9.50 dst9.569.9.51 sportW295
dportb324 src9.569.9.51 dst9.569.9.50 sportb324 dportW295
 [UPDATE] sctp     132 3 COOKIE_ECHOED src9.569.9.50
dst9.569.9.51 sportW295 dportb324 src9.569.9.51
dst9.569.9.50 sportb324 dportW295
 [UPDATE] sctp     132 432000 ESTABLISHED src9.569.9.50
dst9.569.9.51 sportW295 dportb324 src9.569.9.51
dst9.569.9.50 sportb324 dportW295 [ASSURED]

Is it expected? In tcp, conntrack log can show SYN_SENT/ SYN_RECEIVED.

Brs,
Naruto
