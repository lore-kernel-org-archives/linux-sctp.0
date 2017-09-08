From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Sep 2017 09:37:18 +0000
Subject: RE: Multiple connections from the same source address.
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD0071357@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
> Sent: 08 September 2017 10:30
> > On 8. Sep 2017, at 11:03, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > Can anyone think how to create multiple outgoing connections
> > from the same subset of local IP addresses and the same port?
> >
> > We bind() to the first IP address and port, then use
> > SCTP_SOCKOPT_BINDX_ADD to add the second IP address.
> > But even with IP_REUASADDR set you can't repeat that on
> > a second socket.
> >
> > It is possible to bind a second socket by reversing the
> > order of the IP addresses (this might be deemed to be a bug!)
> >
> > If you bind to IN_ADDR_ANY then a second socket can be bound
> > to the same port once the outgoing connection has been made
> > (and the actual local address assigned).
> > This works for TCP, but for SCTP you almost always need to
> > constrain the local addresses advertised on the connection.
> >
> > Ideas?
> Why not use a 1-to-many style socket?

Because we don't know until we try to make a connection
that the local addresses match an existing one.
And it would complicate the code horribly.

In principle it could be a completely separate application.
(Although in our case it is a kernel M3UA driver.)

	David

