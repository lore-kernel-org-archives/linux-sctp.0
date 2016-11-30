From: tsoi andrew <tsoiandrew@gmail.com>
Date: Wed, 30 Nov 2016 10:48:32 +0000
Subject: multihoming client question
Message-Id: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Sir,

It is found that IP X haven't replied heartbeat Ack to IP A but our
client will not try another path B->Y.  Would you advise how B->Y path
can be enable?

lksctp client IP info:
Primary IP: A
Secondary IP: B

Server primary IP: X
Server secondary IP: Y

Regards,
Andrew
