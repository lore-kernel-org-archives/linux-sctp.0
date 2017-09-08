From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 08 Sep 2017 15:28:58 +0000
Subject: Re: Multiple connections from the same source address.
Message-Id: <7B717DB7-EDDE-44D0-859C-0D1DA761316D@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 8. Sep 2017, at 11:37, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Michael Tuexen
>> Sent: 08 September 2017 10:30
>>> On 8. Sep 2017, at 11:03, David Laight <David.Laight@ACULAB.COM> wrote:
>>> 
>>> Can anyone think how to create multiple outgoing connections
>>> from the same subset of local IP addresses and the same port?
>>> 
>>> We bind() to the first IP address and port, then use
>>> SCTP_SOCKOPT_BINDX_ADD to add the second IP address.
>>> But even with IP_REUASADDR set you can't repeat that on
>>> a second socket.
>>> 
>>> It is possible to bind a second socket by reversing the
>>> order of the IP addresses (this might be deemed to be a bug!)
>>> 
>>> If you bind to IN_ADDR_ANY then a second socket can be bound
>>> to the same port once the outgoing connection has been made
>>> (and the actual local address assigned).
>>> This works for TCP, but for SCTP you almost always need to
>>> constrain the local addresses advertised on the connection.
>>> 
>>> Ideas?
>> Why not use a 1-to-many style socket?
> 
> Because we don't know until we try to make a connection
> that the local addresses match an existing one.
> And it would complicate the code horribly.
OK, I see. I just double checked. If Linux follows RFC 6458,
it should be possible to do
fd = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
setsockopt(fd, IPPROTO_SCTP, SCTP_REUSE_PORT, &on, sizeof(int));
and then call bind().

I can run this kind of program on FreeBSD multiple times in
parallel, each one talking to a different end-point.
I'm not sure if Linux supports SCTP_REUSE_PORT.

Best regards
Michael
> 
> In principle it could be a completely separate application.
> (Although in our case it is a kernel M3UA driver.)
> 
> 	David
> 

