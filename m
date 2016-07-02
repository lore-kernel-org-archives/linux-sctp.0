From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Sat, 02 Jul 2016 13:11:55 +0000
Subject: Re: sctp and tail loss recovery
Message-Id: <CB096E48-71A5-4DB1-A625-CE6D198C6C49@fh-muenster.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
In-Reply-To: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 30 Jun 2016, at 21:18, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> 
> Hi Michael,
> 
> Long story short, I'm chasing a performance issue on linux implementation and I think that TLR is the right fix for it. The receive operation is way more expensive than transmit and this causes its buffer to fill up, up to reach 0 window situation. Then, as the RFC allows, sender keeps sending 1 data chunk at a time, as a probe for possible unnoticed window updates due to SACK loss. But if the peer couldn't free any window in time, it will drop that chunk, and will cause a RTO.
OK.

So I think there a better handling of SWS might help:

What method of SWS does Linux use on the receiver side? On FreeBSD we announce the a_rwnd as
is actually is until it is less that a threshold. Then we announce a_rwnd = 1. This slows
down the sender but still allow the receiver to accept the data. This does avoid an RTO.
> 
> I'm not seeing anything in the specs that would prevent this situation other than a TLR would do. Or I missed it?
I would think that TLR is trying to address the case where a packet at the end of a batch is lost
due to congestion in the network.

Best regards
Michael
> 
> On TLR, the most updated info I could find, is already (recently) expired and archived: https://datatracker.ietf.org/doc/draft-nielsen-tsvwg-sctp-tlr/
> I could find Karen's email https://www.ietf.org/mail-archive/web/tsvwg/current/msg13703.html
> But then nothing else. Do you know what happened?
> 
> Thanks,
> Marcelo

