From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 04 Aug 2009 16:54:00 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet size exceed current MTU
Message-Id: <20090804165400.GA4941@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Aug 04, 2009 at 10:16:32AM -0400, Vlad Yasevich wrote:
> >> The main point being that if a SACK won't fit in the last chunk of a
> >> message, then your scheme
> >> would just push all the data down so that a new DATA chunk has to be
> >> sent to send the last
> >> few bytes of data,
> 
> One thing to mention is that a generally accepted practice is send control
> chunks first, be it bundled or separate.  This why BSD ends up sending SACK
> first when it can't bundle it with outgoing data.  Additionally, the way
> the code is now, we might end up sending a SACK even when sending DATA is
> prohibited via congestion or receive window.   Should we still be doing it
> even if we do not send DATA?

I don't think BSD is doing this deliberately.  BSD is behaving exactly how
lksctp would have behaved after my very first patch and before Wei noticed
the bit in the RFC about only appending the SACK if it doesn't cause the MTU
to be exceeded.  So I think that when the SACK is too big to be bundled in
the first fragment of a message, BSD is sending the SACK in separate packet
before the DATA more or less by accident.

I don't think the SACK needs to be sent immediately if sending DATA
is prohibited; the normal delay of 200ms should be fine in that case.
The case we're trying to opimize (I think) is when a client is sending
requests and receiving responses as fast as possible from a server.
So we just want to ensure that when a message is sent in either direction,
that it includes a SACK to the message that triggered the request/reply
it's just about to send.  That way, nobody ever has to stop and wait for
a SACK before sending their next request or response.  If the congestion
window prevents the sending of a request from C to S, there's no rush
to send a SACK to S because it hasn't received the request yet, and so
probably isn't going to need a send a reply anytime soon.

--Doug.
