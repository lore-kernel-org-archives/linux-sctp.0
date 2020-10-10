From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Oct 2020 02:35:22 +0000
Subject: Re: sctp discarding received data chunks
Message-Id: <CADvbK_farVU-bB9NeLSDfmCgPcdG2Oe44-odeU0o+b2BwfRA0g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
In-Reply-To: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Oct 9, 2020 at 9:03 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: David Laight
> > Sent: 09 October 2020 12:14
> >
> > From: Andreas Fink
> > > Sent: 09 October 2020 08:25
> > >
> > > Can you see this issue with the 5.4 kernel too?
> > >
> > > I did yesterday some testing by upgrading kernel from 5.4 to 5.7 and I run into all sorts of links
> > > going off after a while so I had to revert back.
> > > 5.4 is stable for me. 5.7 is not. And I have lots of M2PA and M3UA connections like you
> >
> > I've just spent hours digging through my traces.
> > It is only some messages through the connection that get lost!
> >
> > Now SCTP_MIN_IN_DATA_CHUNK_DISCARDS is only incremented in two
> > adjacent places in sm_statefuncs.c.
> >
> > Either for bad TSN (unlikely when everything is using "lo")
> > and bad STREAM.
> > I suspect it is the 'bad stream' case.
> > I've not double-checked but I bet the discarded packets
> > all have a large stream number.
> ...
>
> If I dump out /proc/net/sctp/assocs and look way over to the right
> (on the next monitor but 1) there are two columns INS and OUTS.
> I've just realised that these are the number of streams.
> Now all my connections are loopback - so I see both sockets for each.
> So I'd expect the INS to match the OUTS of the peer.
> This isn't true.
> When the value should be negotiated down the OUTS value is unchanged.
> So the kernel is sending packets with illegal stream numbers.
> These are acked and then silently discarded.
did it do addstream reconfig or receive any duplicate COOKIE-ECHO in your case?
