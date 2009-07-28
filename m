From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 28 Jul 2009 16:09:28 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <4A6F22B8.3050506@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> On Tue, Jul 28, 2009 at 11:13:05AM -0400, Vlad Yasevich wrote:
>> Doug Graham wrote:
>>> Hello,
>>>
>>> I have a little test that simply has a client send 32 bytes of data to
>>> server, which then replies back with the same data.  What doesn't look
>>> right to me is that I never see piggybacked ACKs.  I see the client
>>> send 32 bytes, then the server reply in a packet containing a single
>>> DATA chunk of 32 bytes, and then 200ms later both SACKs are sent.
>> Piggybacked ACKs will not be sent every packet.  Looks like you are hitting
>> the typical single packet request-response senario.
>>
>> I'd recommend you read RFC 4960 section 6.2.
>>
>> Now, it's possible to do some piggy-backing when bulk data is flowing in
>> both directions, but that would different then you proposal below.
> 
> I did a fairly quick scan of section 6.2 in RFC 4960, and I'm not sure
> what I'm supposed to see in there that would clear this up.  I still
> think that section 6.1 applies:
> 
>    Before an endpoint transmits a DATA chunk, if any received DATA
>    chunks have not been acknowledged (e.g., due to delayed ack), the
>    sender should create a SACK and bundle it with the outbound DATA
>    chunk, as long as the size of the final SCTP packet does not exceed
>    the current MTU.  See Section 6.2.
> 

Section 6.2 are specific guidelines of when one should generate SACKs.
Specifically, SACKs are generate every other packet or within 200 ms of
unacknowledged DATA, which-ever is faster.

What you are proposing is that SACKs are generated for every packet and
well short of the 200 ms delay limit, which is definitely more aggressive.
This is explicitly a MUST NOT.

> I still don't understand what "a_rwnd > rwnd" has to do with whether or
> not a SACK should be appended.  Could you tell me specifically which part
> of section 6.2 you think should prevent SACKs from being piggybacked in
> a single packet request-response scenario?  Note that I've also run my
> simple test program on the only other implementation of SCTP that I have
> access to, that on FreeBSD 7.2, and it does piggyback SACKS in the way
> I expect.  To me, it makes no sense to ever skip the piggybacking of a
> SACK if you've got one to send.  The whole point of delayed SACKs is to
> make this possible, and thus avoid sending a SACK in a separate packet.

But in you example of single message request-response, there is no SACK to
send.   Not sure if BSD 7.2 implements immediate SACK draft (it might), but
that would allow one to do what you ask.

> 
> Here's one case where this lack of SACK piggybacking can have a big
> performance impact.  Suppose C(lient) and S(erver) are sending small
> requests and replies between each other as quickly as possible.  ie:
> S sends a reply as soon as it gets a request from C, and C sends another
> request as soon as it gets the previous reply from S.  If Nagle is not
> disabled, what happens is this:
> 
>   C sends request DATA to S
>   S sends reply DATA to C
>   C and S send SACKs to each other after 200ms
> 
>   After the 200ms delay introduced above, A finally has the SACK to
>   its first request, and only now, by the rules of Nagle, can it send
>   another request.
> 
> So there's a delay of 200ms in request/reply cycle.  If S had piggybacked
> a SACK on the DATA it sent to C, then C would have its SACK when it got
> S's reply and could send another request immediately after receiving the
> reply to the first.  And if C piggybacks a SACK onto its second request,
> then S doesn't need to wait for a SACK timeout before it can send the
> second reply.

This is a well known problem with SCTP and 'immidiate sack' draft tries to solve
it.  However, changing the code the way you suggesting will not fully correct
the problem.  LKSCTP is notorious for not bundling SACKS.

What we need to do is deffer SACKS for very short amount of type when they need
to be sent, so that they might be bundled with other chunks.  However, if the
user application happened to stall, the SACKs should still be sent.  This timer
should be on the order of microseconds.  This way we would more likely bundle
SACKs.

-vlad

> 
> There's also bandwidth wasted by sending separate SACK packets.
> 
> Thanks for your reply,
> Doug.
> 

