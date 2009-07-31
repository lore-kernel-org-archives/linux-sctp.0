From: =?ISO-8859-1?Q?Michael_T=FCxen?= <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 31 Jul 2009 07:34:35 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <FBAB91DB-7481-4560-84D2-3E46B616635C@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Jul 31, 2009, at 3:43 AM, Doug Graham wrote:

> On Fri, Jul 31, 2009 at 08:53:55AM +0800, Wei Yongjun wrote:
>> Doug Graham wrote:
>>> The largest amount of data I can send and still have the BSD  
>>> server bundle
>>> a SACK with the response is 1436 bytes.  The total ethernet frame  
>>> size
>>> at that point is 1514 bytes, so this seems correct.  I've attached
>>> wireshark captures with data sizes of 1436 bytes and 1438 bytes.
>>> It's interesting to note that if BSD decides not to bundle a SACK,
>>> it instead sends a separate SACK packet immediately; it does not  
>>> wait
>>> for the SACK timer to timeout.  It first sends the SACK, then the  
>>> DATA
>>> immediately follows. I don't think Wei's patch would do this; I  
>>> think
>>> that if his patch determined that bundling a SACK would cause the  
>>> packet
>>> to exceed the MTU, then the behaviour will revert to what it was  
>>> before
>>> my patch is applied: ie the SACK will not be sent for 200ms.
>>>
>>
>> Before my patch, SACK sent on linux is the same as BSD.
>
> I had it in my head that without your patch, the combined DATA+SACK  
> packet
> would have been fragmented at the IP level, but that's very likely my
> unfamiliarity with the code kicking in.
>
>> But... BSD's
>> implemention is really correct?
>>
>> RFC said:
>>
>> the sender should create a SACK and bundle it with the outbound DATA
>> chunk, as long as the size of the final SCTP packet does not exceed
>> the current MTU.
>>
>> So, we just need create a SACK only if the final packet size does not
>> exceed the MTU. Always send SACK may cause lower performance.
>
> I agree that this section of the RFC implies that if the SACK won't
> fit, it simply shouldn't be sent at this point.  Which would make
> BSD's behaviour incorrect.  But to my mind, it makes sense to send it,
> although I'm not sure I could make a strong case for that.
>
> But consider that in the case of a client and server sending equal- 
> sized
> messages to each other (to keep it simple), there will be a message
> size at which the behaviour changes noticably.  Small messages will
> be SACK'd immediately.  Messages slightly smaller than the MTU will
> not be SACK'd until the delayed ACK timer expires.  Messages slightly
> larger than the MTU will again be SACKED immediately because the  
> second
> fragment in the response will have space for a SACK (assuming that the
> Nagle problem I mentioned in my last email really is a problem that
> needs to be fixed).
>
> Perhaps Michael could explain which is the correct behaviour.
As said in my earlier mail:
I have seen this multiple times: for one packet size the app
runs find, make the packet size larger (1 byte enough) and
your throughput drops to 5 packets/requests per second (assuming
a 200ms delayed ack timer).

I agree that this is something the kernel should take care of
and i think draft-tuexen-tsvwg-sctp-sack-immediately-02 is
the way to go...
>
> --Doug.
>

