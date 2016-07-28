From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 28 Jul 2016 19:06:31 +0000
Subject: Re: sctp and tail loss recovery
Message-Id: <20160728190631.GA2967@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
In-Reply-To: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Jul 02, 2016 at 03:11:55PM +0200, Michael Tuexen wrote:
> > On 30 Jun 2016, at 21:18, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > Hi Michael,
> > 
> > Long story short, I'm chasing a performance issue on linux implementation and I think that TLR is the right fix for it. The receive operation is way more expensive than transmit and this causes its buffer to fill up, up to reach 0 window situation. Then, as the RFC allows, sender keeps sending 1 data chunk at a time, as a probe for possible unnoticed window updates due to SACK loss. But if the peer couldn't free any window in time, it will drop that chunk, and will cause a RTO.
> OK.
> 
> So I think there a better handling of SWS might help:
> 
> What method of SWS does Linux use on the receiver side? On FreeBSD we announce the a_rwnd as

Sorry the delay Michael, I wanted to re-read the code on this.

We don't do much, sender or receiver side.

We will accept data and reduce a_rwnd accordingly, till it reaches 0.
Then we keep announcing as 0 while allowing some overshoot.

When some space is freed, we will only announce it if it's bigger than a
threshold. But if we have to bundle a sack, we will also update it,
regardless of a threshold. Hmm now writting the email seems that this
update on bundled sack should also respect the threshold. 

> is actually is until it is less that a threshold. Then we announce a_rwnd = 1. This slows
> down the sender but still allow the receiver to accept the data. This does avoid an RTO.

On RFC 4960, it says:

6.1.  Transmission of DATA Chunks
...
   A) At any given time, the data sender MUST NOT transmit new data to
      any destination transport address if its peer's rwnd indicates
      that the peer has no buffer space (i.e., rwnd is 0; see Section
      6.2.1).  However, regardless of the value of rwnd (including if it
      is 0), the data sender can always have one DATA chunk in flight to
      the receiver if allowed by cwnd (see rule B, below).  This rule
      allows the sender to probe for a change in rwnd that the sender
      missed due to the SACK's having been lost in transit from the data
      receiver to the data sender.

it's saying the sender *can* send a chunk at any given time, but not
meaning that it should abuse of that. Now I'm thinking, this is our
problem, and that's why it's enough to slow down your sender:

We don't really respect the 0 window situation. The only difference is
that we start sending chunk by chunk, regardless of their
interval/a_rwnd, because "the data sender can always have one DATA chunk
in flight to the receiver if allowed by cwnd". Then a packet drop
happens, as the window is very overshot already, and the sender won't
retransmit even after the window update because there was a packet drop.

So after sending the first chunk in 0-window situation, if the reply
still comes with 0-window, we should not send a new chunk, but wait for
either the window update or RTO. If we keep hammering it, the receiver
will have a harder time to re-open the window, and we have a SWS issue.

We do it like "Are we there yet? Are we there yet? Are we there yet?"
</donkey, shrek movie> hehe ;-)

Makes sense?
 
> > 
> > I'm not seeing anything in the specs that would prevent this situation other than a TLR would do. Or I missed it?
> I would think that TLR is trying to address the case where a packet at the end of a batch is lost
> due to congestion in the network.

Agreed. Better thinking, even if TLP would help it, it's not the right
fix, as it would be same as saying that some packet drops are expected.

Thanks,
Marcelo

> 
> Best regards
> Michael
> > 
> > On TLR, the most updated info I could find, is already (recently) expired and archived: https://datatracker.ietf.org/doc/draft-nielsen-tsvwg-sctp-tlr/
> > I could find Karen's email https://www.ietf.org/mail-archive/web/tsvwg/current/msg13703.html
> > But then nothing else. Do you know what happened?
> > 
> > Thanks,
> > Marcelo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
