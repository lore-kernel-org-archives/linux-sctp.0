From: Andreas Fink <afink@list.fink.org>
Date: Wed, 16 May 2018 17:17:07 +0000
Subject: Re: SCTP nailed down connections trouble
Message-Id: <D600D73A-3E25-4D82-A447-72419F16C52B@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
In-Reply-To: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> On 16 May 2018, at 18:29, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> 
> Hi,
> 
> On Wed, May 16, 2018 at 02:02:46PM +0200, Andreas Fink wrote:
>> Under FreeBSD and MacOS, the sctp_connectx returns without an error
>> (as its a non blocking socket) and my subsequent code then calls
>> poll to wait for events or data to be delivered with a follow up
>> call to sctp_recvmsg to process that data and/or events
>> I would expect  a SCTP UP message  to appear after the other side
>> has done the same after the SCTP handshake completes.
>> 
>> Under Linux however sctp_connectx does immediately return with
>> connection refused and we are stuck.
> 
> Right. This (the returning) is because on Linux the connect operation
> always blocks, even if the socket is configured to not do so. It's a
> known issue, we're working on it. Xin Long has some patches already
> and hopefully we can post them soon.
> 
> On the simultaenous open, when you connect to Cisco ITP or the others,
> doesn't it send an Abort right after the INIT request reaches it? If
> they don't, I find it odd.

actually I played around with my test programm and figured I had the block/no block logic inverted by mistake.
Right now I have sctp_connectx returning error 115 (EINPROGRESS) in errno which is not 0 as on MacOS X or FreeBSD but at least it can be handled properly.
The second problem I spotted was that poll was returning data and a error at the same time. pollfds[0].revents = 9 is what I saw. Because my code bails out if it sees bit 8 set (POLLERR), it never got to the point to actually read and process the data. And because errno was actually set to 0, my code was thinking its time to immediately read again, creating a busy loop. poll returns instantly, not after timeout.
I'm just changing that. I however find it odd that poll can return an error flag ,errno being 0 and data. Somehow this doesn't make much sense to me. But it could be related to the fact that EINPROGRESS was set before maybe?


>> I have not figured out how this can be achieved reliably. constantly
>> calling sctp_connectx can not be the solution as it would create a
>> busy loop and probably a packet storm.
> 
> Maybe by using some iptables rule to drop Abort chunks, using a socket
> filter (SO_ATTACH_FILTER) to do it (I never did it, btw, just sharing
> ideas).
> 

Uh that would be a quite ugly hack :)
The ABORT's seem however to be no longer be the issue once the socket is in non blocking.

> ...
>> A second area where I found issues is on how to configure a specific
>> port to be used for multiple connections. For example my local port
>> 2000 can be used for a connection to host 1 or to host 2 and the
>> individual sessions which are created as above will however not
>> allow me to use the same port in a second socket even though the
>> bind is not follwed with a listen and the sctp_connectx goes to  a
>> different port. Workaround to this is to use different ports for
>> every connection (which is not really nice). Maybe there's another
>> way?
> 
> Needs to check on this.

Could that be related to the missing SCTP_REUSE_PORT socket option?

> 
>  Marcelo


