From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 16 May 2018 16:29:05 +0000
Subject: Re: SCTP nailed down connections trouble
Message-Id: <20180516162905.GC5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
In-Reply-To: <F7A4BA05-180B-4762-A4CD-3348DC41364F@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Wed, May 16, 2018 at 02:02:46PM +0200, Andreas Fink wrote:
> Under FreeBSD and MacOS, the sctp_connectx returns without an error
> (as its a non blocking socket) and my subsequent code then calls
> poll to wait for events or data to be delivered with a follow up
> call to sctp_recvmsg to process that data and/or events
> I would expect  a SCTP UP message  to appear after the other side
> has done the same after the SCTP handshake completes.
>
> Under Linux however sctp_connectx does immediately return with
> connection refused and we are stuck.

Right. This (the returning) is because on Linux the connect operation
always blocks, even if the socket is configured to not do so. It's a
known issue, we're working on it. Xin Long has some patches already
and hopefully we can post them soon.

On the simultaenous open, when you connect to Cisco ITP or the others,
doesn't it send an Abort right after the INIT request reaches it? If
they don't, I find it odd.

> I have not figured out how this can be achieved reliably. constantly
> calling sctp_connectx can not be the solution as it would create a
> busy loop and probably a packet storm.

Maybe by using some iptables rule to drop Abort chunks, using a socket
filter (SO_ATTACH_FILTER) to do it (I never did it, btw, just sharing
ideas).

...
> A second area where I found issues is on how to configure a specific
> port to be used for multiple connections. For example my local port
> 2000 can be used for a connection to host 1 or to host 2 and the
> individual sessions which are created as above will however not
> allow me to use the same port in a second socket even though the
> bind is not follwed with a listen and the sctp_connectx goes to  a
> different port. Workaround to this is to use different ports for
> every connection (which is not really nice). Maybe there's another
> way?

Needs to check on this.

  Marcelo
