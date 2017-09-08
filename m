From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Sep 2017 09:03:31 +0000
Subject: Multiple connections from the same source address.
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Can anyone think how to create multiple outgoing connections
from the same subset of local IP addresses and the same port?

We bind() to the first IP address and port, then use
SCTP_SOCKOPT_BINDX_ADD to add the second IP address.
But even with IP_REUASADDR set you can't repeat that on
a second socket.

It is possible to bind a second socket by reversing the
order of the IP addresses (this might be deemed to be a bug!)

If you bind to IN_ADDR_ANY then a second socket can be bound
to the same port once the outgoing connection has been made
(and the actual local address assigned).
This works for TCP, but for SCTP you almost always need to
constrain the local addresses advertised on the connection.

Ideas?

I've not tried binding to IN_ADDR_ANY and using bindx to
add all the addresses.

	David

