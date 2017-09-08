From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 08 Sep 2017 14:49:30 +0000
Subject: Re: Multiple connections from the same source address.
Message-Id: <20170908144929.GA4529@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 08, 2017 at 09:03:31AM +0000, David Laight wrote:
> Can anyone think how to create multiple outgoing connections
> from the same subset of local IP addresses and the same port?
> 
> We bind() to the first IP address and port, then use
> SCTP_SOCKOPT_BINDX_ADD to add the second IP address.
> But even with IP_REUASADDR set you can't repeat that on
> a second socket.

When did you set IP_REUSEADDR? Checking the code, seems you have to set
it before any binding, because then the port entry will be created and
such flag will be initialized with that state.

> 
> It is possible to bind a second socket by reversing the
> order of the IP addresses (this might be deemed to be a bug!)

Interesting. It does seem like a bug. Probably related to the above
behavior.

> 
> If you bind to IN_ADDR_ANY then a second socket can be bound
> to the same port once the outgoing connection has been made
> (and the actual local address assigned).
> This works for TCP, but for SCTP you almost always need to
> constrain the local addresses advertised on the connection.
> 
> Ideas?
> 
> I've not tried binding to IN_ADDR_ANY and using bindx to
> add all the addresses.
> 
> 	David
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
