From: tsoi andrew <tsoiandrew@gmail.com>
Date: Mon, 04 Nov 2013 01:59:44 +0000
Subject: Multi-homing question
Message-Id: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Sir,

I got a problem when set multi-homing to active/active.
That mean, It is expected that our lksctp server have 2 IP to connect
2 IP of destination client with total 4 connections.
The flow is that client send "INIT" message with 2 (primary and
secondary) IP to our server and lksctp server return INIT_ACK. But
when second client send 'heartbeat' to us, lksctp server cannot return
ACK.
Moreover, we already proved our connectivity correct because when our
lksctp server send heartbeat to both destination client and they can
return ACK.
Would you mind sharing if lksctp lib already configure those
multi-homing purpose.



Best Regards,
Andrew Tsoi
