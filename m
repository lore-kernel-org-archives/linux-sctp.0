From: =?ISO-8859-1?Q?Michael_T=FCxen?= <Michael.Tuexen@lurchi.franken.de>
Date: Tue, 28 Jul 2009 21:18:05 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <0F2B885E-F259-4B31-AE21-1759816C2B36@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Jul 28, 2009, at 10:45 PM, Doug Graham wrote:

> Also copying Michael, since he seems interested, except he's  
> interested on
> the wrong mailing list :-).  Some of what I'm replying to here is  
> from the
> other mailing list, but since you prefer to use this one, I'll reply  
> here.
>
> On Tue, Jul 28, 2009 at 12:09:28PM -0400, Vlad Yasevich wrote:
>> Doug Graham wrote:
>>> On Tue, Jul 28, 2009 at 11:13:05AM -0400, Vlad Yasevich wrote:
>>>> Doug Graham wrote:
>>>>>
>>>>> I have a little test that simply has a client send 32 bytes of  
>>>>> data to
>>>>> server, which then replies back with the same data.  What  
>>>>> doesn't look
>>>>> right to me is that I never see piggybacked ACKs.  I see the  
>>>>> client
>>>>> send 32 bytes, then the server reply in a packet containing a  
>>>>> single
>>>>> DATA chunk of 32 bytes, and then 200ms later both SACKs are sent.
>>>>>
>>>> Piggybacked ACKs will not be sent every packet.  Looks like you  
>>>> are hitting
>>>> the typical single packet request-response senario.
>>>>
>>>> I'd recommend you read RFC 4960 section 6.2.
>>>>
>>>> Now, it's possible to do some piggy-backing when bulk data is  
>>>> flowing in
>>>> both directions, but that would different then you proposal below.
>>>
>>> I did a fairly quick scan of section 6.2 in RFC 4960, and I'm not  
>>> sure
>>> what I'm supposed to see in there that would clear this up.  I still
>>> think that section 6.1 applies:
>>>
>>>   Before an endpoint transmits a DATA chunk, if any received DATA
>>>   chunks have not been acknowledged (e.g., due to delayed ack), the
>>>   sender should create a SACK and bundle it with the outbound DATA
>>>   chunk, as long as the size of the final SCTP packet does not  
>>> exceed
>>>   the current MTU.  See Section 6.2.
>>>
>>
>> Section 6.2 are specific guidelines of when one should generate  
>> SACKs.
>> Specifically, SACKs are generate every other packet or within 200  
>> ms of
>> unacknowledged DATA, which-ever is faster.
This is the way it should work...
>
> I think this is a misinterpretation of the RFC.  Otherwise, what could
> that paragraph from section 6.1 possibly mean?  I read section 6.2 to
> mean that a SACK should be generated for *at least* every second  
> packet,
> and that a SACK should be sent within 200ms.  The RFC only prohibits
> more than one SACK from being sent for every incoming DATA packet;
> it doesn't say that a SACK can *only* be be sent for every second  
> packet.
>
>> What you are proposing is that SACKs are generated for every packet  
>> and
>> well short of the 200 ms delay limit, which is definitely more  
>> aggressive.
>> This is explicitly a MUST NOT.
>
> I don't think that's what the RFC says, but I guess only the  
> author(s) of
> the RFC could tell us what they really meant.  Your interpretation  
> doesn't
> make any sense to.
Let us see the tracefile and I can tell you if that behaviour is the
one the authors of the RFC intended...
>
>> But in you example of single message request-response, there is no  
>> SACK to
>> send.
>
> I don't know what you mean by this.  A SACK needs to be sent for both
> the request and the reply.  Or perhaps you meant that since there's  
> only
> one DATA packet in each direction, the conjectured "SACK only every  
> two
> packets" rule kicks in.  But as I mention, I very much doubt that  
> that's
> what the RFC actually means to say.
>
>> Not sure if BSD 7.2 implements immediate SACK draft (it might), but
>> that would allow one to do what you ask.
I looked in the svn repository and the code made in into 7.2...
>
> That's not what I saw BSD do.  As I read
> http://tools.ietf.org/html/draft-tuexen-tsvwg-sctp-sack-immediately-02
> it specifies a way for a data sender to request that the receiver  
> send a
> SACK immediately upon receipt of the DATA.  ie: it disables delayed- 
> ACK
> for a DATA chunk with the proposed I bit set.  This would result in a
> SACK being sent by the receiver immediately after it receives the  
> DATA,
> and would prevent piggybacking in my scenario.  The reason it would
> prevent piggybacking is that at the time the receiving SCTP gets the
> DATA packet and is required to send a SACK, it has no DATA to send  
> yet,
> and so nothing to piggyback the SACK on.  In BSD's case, I *did* see  
> it
> piggyback the SACK.
I guess you did not specify SCTP_DATA_SACK_IMMEDIATELY in the send()  
call...
>
> I'll send pcap traces from BSD and Linux later today.
>
>
>>> Here's one case where this lack of SACK piggybacking can have a big
>>> performance impact.  Suppose C(lient) and S(erver) are sending small
>>> requests and replies between each other as quickly as possible.  ie:
>>> S sends a reply as soon as it gets a request from C, and C sends  
>>> another
>>> request as soon as it gets the previous reply from S.  If Nagle is  
>>> not
>>> disabled, what happens is this:
>>>
>>>  C sends request DATA to S
>>>  S sends reply DATA to C
>>>  C and S send SACKs to each other after 200ms
>>>
>>>  After the 200ms delay introduced above, A finally has the SACK to
>>>  its first request, and only now, by the rules of Nagle, can it send
>>>  another request.
>>>
>>> So there's a delay of 200ms in request/reply cycle.  If S had  
>>> piggybacked
>>> a SACK on the DATA it sent to C, then C would have its SACK when  
>>> it got
>>> S's reply and could send another request immediately after  
>>> receiving the
>>> reply to the first.  And if C piggybacks a SACK onto its second  
>>> request,
>>> then S doesn't need to wait for a SACK timeout before it can send  
>>> the
>>> second reply.
>>
>> This is a well known problem with SCTP and 'immidiate sack' draft  
>> tries to solve
>> it.  However, changing the code the way you suggesting will not  
>> fully correct
>> the problem.  LKSCTP is notorious for not bundling SACKS.
>
> It's not clear to me why my proposed fix would not solve the  
> problem, unless you
> mean that it would violate a clause in the RFC (which I still don't  
> agree with).
> The 'immediate SACK' draft would also solve my problem, except it  
> would do so
> at the expense of an extra SACK packet.  ie: it prevents  
> piggybacking when the
> receiver has no DATA to send immediately, so a separate SACK would  
> need to be
> sent.  With my fix, the receiver would delay the SACK as usual, but  
> then a short
> time after, it would be given DATA to send back, and would piggyback  
> the SACK
> on that.
>
> From your other email:
>
>>> I think this logic is wrong.  I don't think the decision as to  
>>> whether
>>> or not to piggyback a SACK on a DATA packet should have anything  
>>> to do
>>> with the receive window.  If there is unacknowledged data, then the
>>> SACK should be sent, regardless of the state of the receive window.
>>
>> This test is there to catch potential window update SACK that can  
>> be bundled
>> with any outgoing data.  It is not there for immediate SACKs.
>
> That's not what the comment above the code says.  The comment says
>
>        /* If sending DATA and haven't aleady bundled a SACK, try to
>         * bundle one in to the packet.
>         */
>
> If this code is just there to generate window updates, where is the
> code to implement the clause from section 6.1 that I included above,
> and provide again here?:
>
>    Before an endpoint transmits a DATA chunk, if any received DATA
>    chunks have not been acknowledged (e.g., due to delayed ack), the
>    sender should create a SACK and bundle it with the outbound DATA
>    chunk, as long as the size of the final SCTP packet does not exceed
>    the current MTU.  See Section 6.2.
>
> --Doug.
>

