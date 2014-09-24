From: VARUN BHATIA <varuninbharti@gmail.com>
Date: Wed, 24 Sep 2014 12:56:51 +0000
Subject: SCTP Multihoming Always sending primary interface ip I
Message-Id: <CAFi7Gbw8e8_y-fmMNPW482os9gq+Y+psf6XyJaq1jm1_1UJt0A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

We have developed multihomed application now while testing my setup is:

Eth4  as primary interface connected back to back to another machine.
Eth5 as secondary interface connected back to back to another machine.

I make my porimary interface down now when the INIT is been sent it
reaches to peer machine seems using secondary interface but the source
ip address kept is of primary interface only due to which when peer
machine tries to respond INIT_ACK it tries to send on primary
interface ip which is down and due to ICMP it drops the packet.

I am not too good in Routing but it seems that some routing has not
been configuered properly, why is it always using primary ip ?

I have tested the same part when I have connected my primary &
secondary interface through router but facrd the same issue.

Any inputs are appreciated as I am stuck in it since last 2 days.


-- 
Regards,
Varun Bhatia
