From: Fabian Bergmark <fabian.bergmark@gmail.com>
Date: Tue, 19 Jul 2016 10:15:47 +0000
Subject: packet->transport->asoc = NULL in sctp_packet_transmit
Message-Id: <CAG=SMqbHGWu8eg4+ufcz5m2zbozjBGnvOPmvkTCMwWZbk5x8fA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I'm adding experimental support for UDP encapsulation of SCTP packets.
I got most of if working well. However, I noticed a NULL pointer
dereference in sctp_packet_transmit as I assumed that
packet->transport->asoc weren't NULL so I tried to access tunneling
information that I store in packet->transport->asoc->ep->base. In what
circumstances is asoc NULL in sctp_packet_transmit?
