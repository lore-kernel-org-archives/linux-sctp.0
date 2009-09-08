From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 08 Sep 2009 20:21:53 +0000
Subject: Re: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <20090908202152.GB13376@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Sep 08, 2009 at 03:31:02PM -0400, Vlad Yasevich wrote:
> > You're right about the reasons for the two SACKs.  An odd
> > number of chunks still doesn't result in any piggybacking though
> > (see trace below).  Every even chunk is SACKed because of the
> > ack-every-second-packet rule, and the last chunk always results in a
> > window update SACK being sent when the app reads the data.  So I'm
> > not sure that all the fancy footwork to try to piggyback SACKs on
> > fragmented messages is buying much, at least not in the case where
> > client and server are sending each other messages of the same size.
> 
> Yeah, I realized shortly after sending a reply.  Well, in this case
> there is really no opportunity to piggy-back the SACK on anything
> since we don't have any pending DATA.

One thing I did notice when running tests between net-next and FreeBSD
is that BSD does not send a window update every time the windows opens
by a single MTU.  Instead, it only sends a window update if the window
has opened by 1/8th of the total rwin size since the last SACK was sent
(or something like that).  RFC1122 says to use the minimum of half
the total receive buffer size and the MSS, but I don't think many TCP
implementations stick to the letter of that law these days, nor it seems
does BSD's SCTP implementation.   I'm not sure why these implementations
are not following the letter of the RFC, but I'd guess it's an attempt
to send fewer window updates at the possible cost of slightly reduced
throughput.

> The intent was to not fragment if it was not fragmented before.
> That intent came from the Nagle kicking in on the second small fragment.
> I was getting abysmal results when I was fragmenting and hitting Nagle.
> 
> So, the code essentially says that if we are going to fragment anyway,
> then allow SACKs into the first fragment.  If we are not fragmenting, then
> SACK will be bundled on best effort basis.  That's what bundling is all about
> it, anyway.  It's best effort.

Ah, ok this makes sense.  I thought that the you'd intended the same
behaviour when the data size is just less than one MTU as when it's
just less than 2, 3, 4, ...  MTUs, but I think it does make sense not
to fragment if the the message hasn't already been fragmented.

> Making Nagle not applicable to fragments didn't make sense since that would
> allow you to effectively disable Nagle by setting a SCTP_MAXSEG to 1/2 your
> message size and then sending small messages.
> 
> So, now Nagle doesn't apply to messages that would fill the mtu.  I think I can
> do this a little bit better though...
> 
> Try attached patch on top of the net-next tree.
> 
> It give me the following pattern with 1444 byte payload:
> 
> DATA (1444) -------->
>             <-------   SACK + DATA(1436)
>             <-------   DATA (8)
> SACK        -------->
> DATA (1444) -------->
>             <-------   SACK + DATA(1436)
>             <-------   DATA (8)
> 
> 
> Not sure if this better then a pattern of:
> 
> DATA    -------->
>         <--------  SACK
>         <-------   DATA
> SACK    -------->
> DATA    -------->
>         <-------- SACK
>         <-------- DATA

I think you're starting to lose me.  I thought the first pattern above
was what you were trying to avoid (fragmenting messages that didn't
previously need to be fragmented), but I'm not following how this all
ties into Nagle possibly being defeated.  Perhaps it'll become clear
when I study your patch.  Anyway, I don't see any real advantage to the
first pattern above compared to the second.  The only reason I brought
it up is that I thought you'd intended the first.

--Doug.
