From: kunapaneni prashanth <prask9@gmail.com>
Date: Wed, 09 Sep 2015 08:25:01 +0000
Subject: lksctp-tools:sctp_test fails when not using sock_stream
Message-Id: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,
 in our setup, i am trying out sctp tests using lksctp tools between
two hosts connected back to back.

H1(5.5.5.8)  --------------   H2 (5.5.5.5)


following are the commands i used.

Case 1:
====client:
sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s

server:
sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l


This test case fails, with client sending a abort after INIT/INIT-ACK.

If i run same test case with "-T" option, it is successful.

i,e
Case 2:
====
client:
sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -T

server:
sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l




i observed that in case 1, sctp_test never calls "connect", why is it
so? shouldnt a connect be called.


I modified the code as follows to make sure a connect is issued. After
this everything works fine.

Please confirm.

1386c1386
<         if (socket_type = SOCK_STREAM || connectx_count = 0)
---
>         if (socket_type = SOCK_STREAM && connectx_count = 0)



Thank you,
Prashanth
