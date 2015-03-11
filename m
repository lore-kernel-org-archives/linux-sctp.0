From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 11 Mar 2015 02:55:01 +0000
Subject: Source IP address of SCTP INIT chunk and the IPv4 address parameter inside SCTP INIT chunk
Message-Id: <CAFXGftK0QQiazx3MCdz+8rXosOLbXS0E52DyTjwDGiYZzTB8GQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi

I would like to ask about the IP address on dource IP address of SCTP
INIT chunk and the IPv4 address parameter inside SCTP INIT chunk.

If the source IP of the SCTP INIT chunk is 10.1.1.84, but the IP
address INSIDE the INIT chunk, i.e. the IPv4 address parameter, is
using a different IP address, says 192.1.1.84, what will be happened?

I did a testing on a SCTP server and client environment, and it seems
the SCTP server tried to send INIT_ACK back to the source IP to the
client, i.e. the destination IP address is 10.1.1.84. but somehow, the
SCTP server generate two HEARTBEAT request, one to 10.1.1.84 and one
to 192.1.1.84.

is it a problem on our SCTP server application?

any idea on this?

Thanks

- RBK
