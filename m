From: Wasim Baig <wasimbaig@gmail.com>
Date: Fri, 17 Jun 2016 04:55:12 +0000
Subject: No COOKIE_ECHO after INIT_ACK
Message-Id: <CABHdwCpNDcpQHUpR6ho+Eh2CUfCbGhEt1dKt2vE9wTfHJv1Gfw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In trying to establish an association, linux-sctp Debian 8 (libsctp1
1.0.16+dfsg-2) is not responding with COOKIE_ECHO to the INIT_ACK.

Linux smsc-01 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt25-1 (2016-03-06)
x86_64 GNU/Linux

Far end is probably a Huawei STP, but I have to confirm this
information with the operator.

Attached is a PCAP showing the INIT and INIT_ACK (this goes on...)

sctp_test -H 10.123.86.248 -P 2527 -h 10.157.120.36 -p 2527 -s
remote:addr.157.120.36, port%27, family=2
local:addr.123.86.248, port%27, family=2
seed = 1466138967

Starting tests...
        socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3
        bind(sk=3, [a:10.123.86.248,p:2527])  --  attempt 1/10
Client: Sending packets.(1/10)
        sendmsg(sk=3, assoc=0)    1 bytes.
          SNDRCV(stream=0 flags=0x1 ppid9959982

In between is an IPSEC tunnel, could it be the INIT_ACK is not
reaching sctp_test? How can I get more debug?

Would appreciate insight into the matter as we haven't seen this
behaviour below.

Many thanks.

-- 
wasim h. baig | +92 30 0850 8070 | peace be upon you
