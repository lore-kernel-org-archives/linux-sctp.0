From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Sep 2017 15:01:22 +0000
Subject: RE: Multiple connections from the same source address.
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD00716BE@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 08 September 2017 15:50
> On Fri, Sep 08, 2017 at 09:03:31AM +0000, David Laight wrote:
> > Can anyone think how to create multiple outgoing connections
> > from the same subset of local IP addresses and the same port?
> >
> > We bind() to the first IP address and port, then use
> > SCTP_SOCKOPT_BINDX_ADD to add the second IP address.
> > But even with IP_REUASADDR set you can't repeat that on
> > a second socket.
> 
> When did you set IP_REUSEADDR? Checking the code, seems you have to set
> it before any binding, because then the port entry will be created and
> such flag will be initialized with that state.

Indeed, otherwise it has no effect.

The point is that (IIRC) IP_REUSEADDR only lets you bind the same
port number to 2 sockets - the IP addresses have to be different.
Code that does this for TCP (like the old ftp data connection)
only worked because the address it was binding was IN_ADDR_ANY
and the existing socket had a local IP address.
It always had to retry because two sockets couldn't be bound to
the port and IN_ADDR_ANY either.

> > It is possible to bind a second socket by reversing the
> > order of the IP addresses (this might be deemed to be a bug!)
> 
> Interesting. It does seem like a bug. Probably related to the above
> behavior.

More likely the duplicate check is in some generic code that
doesn't look at the extra addresses.

	David

