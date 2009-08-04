From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 04 Aug 2009 14:50:18 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A784AAA.4000009@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> Wei Yongjun wrote:
>> Doug Graham wrote:
>>  
>>> Oops.  Sent the last one in HTML,  so the mailing list rejected it.
>>> Damned GUI email
>>> clients!
>>>
>>> Wei Yongjun wrote:
>>>    
>>>> Doug Graham wrote:
>>>>  
>>>>      
>>>>> On Fri, Jul 31, 2009 at 12:21:15PM +0800, Wei Yongjun wrote:
>>>>>             
>>>>>> Doug Graham wrote:
>>>>>>                   
>>>>>>>  13 2.002632    10.0.0.15   10.0.0.11   DATA (1452 bytes data)  14
>>>>>>> 2.203092    10.0.0.11   10.0.0.15   SACK  15 2.203153  
>>>>>>> 10.0.0.15   10.0.0.11   DATA (2 bytes data)
>>>>>>>  16 2.203427    10.0.0.11   10.0.0.15   SACK  17 2.203808  
>>>>>>> 10.0.0.11   10.0.0.15   DATA (1452 bytes data)
>>>>>>>  18 2.403524    10.0.0.15   10.0.0.11   SACK  19 2.403686  
>>>>>>> 10.0.0.11   10.0.0.15   DATA (2 bytes data)
>>>>>>>  20 2.603285    10.0.0.15   10.0.0.11   SACK
>>>>>>> What bothers me about this is that Nagle seems to be introducing a
>>>>>>> delay
>>>>>>> here.  The first DATA packets in both directions are MTU-sized
>>>>>>> packets,
>>>>>>> yet both the Linux client and the BSD server wait 200ms until they
>>>>>>> get
>>>>>>> the SACK to the first fragment before sending the second fragment.
>>>>>>> The server can't send its reply until it gets both fragments, and
>>>>>>> the
>>>>>>> client can't reassemble the reply until it gets both fragments, so
>>>>>>> from
>>>>>>> the application's point of view, the reply doesn't arrive until
>>>>>>> 400ms
>>>>>>> after the request is sent.  This could probably be fixed by
>>>>>>> disabling
>>>>>>> Nagle with SCTP_NODELAY, but that shouldn't be required.  Nagle is
>>>>>>> only
>>>>>>> supposed to prevent multiple outstanding *small* packets.
>>>>>>>                             
>>>>>> I think you hit the point which Nagle's algorithm should be not used.
>>>>>>
>>>>>> Can you try the following patch?
>>>>>>
>>>>>> [PATCH] sctp: do not used Nagle algorithm while fragmented data is
>>>>>> transmitted
>>>>>>
>>>>>> If fragmented data is sent, the Nagle's algorithm should not be
>>>>>> used. In special case, if only one large packet is sent, the delay
>>>>>> send of fragmented data will cause the receiver wait for more
>>>>>> fragmented data to reassembe them and not send SACK, but the sender
>>>>>> still wait for SACK before send the last fragment.
>>>>>>                     
>>>>> [patch deleted]
>>>>>
>>>>> This patch seems to work quite well, but I think disabling Nagle
>>>>> completely for large messages is not quite the right thing to do.
>>>>> There's a draft-minshall-nagle-01.txt floating around that describes a
>>>>> modified Nagle algorithm for TCP.  It appears to have been implemented
>>>>> in Linux TCP even though the draft has expired.  The modified
>>>>> algorithm
>>>>> is how I thought Nagle had always worked to begin with.  From the
>>>>> draft:
>>>>>
>>>>>         "If a TCP has less than a full-sized packet to transmit,
>>>>>         and if any previously transmitted less than full-sized
>>>>>         packet has not yet been acknowledged, do not transmit
>>>>>         a packet."
>>>>>
>>>>> so in the case of sending a fragmented SCTP message, all but the last
>>>>> fragment will be full-sized and will be sent without delay.  The last
>>>>> fragment will usually not be full-sized, but it too will be sent
>>>>> without
>>>>> delay because there are no outstanding non-full-sized packets.
>>>>>
>>>>> The difference between this and your method is that yours would
>>>>> allow many small fragments of big messages to be outstanding, whereas
>>>>> this one would only allow the first big message to be sent in its
>>>>> entirety, followed by the full-sized fragments of the next big
>>>>> message.  When it came time to send the second small fragment,
>>>>> Nagle would force it to wait for an ACK for the first small fragment.
>>>>> I'm not convinced that the difference is all that important,
>>>>> but who knows.
>>>>>
>>>>> Here's my attempt at implementing the modified Nagle algorithm
>>>>> described
>>>>> in draft-minshall-nagle-01.txt.  It should be applied instead of your
>>>>> patch, not on top of it.  If (q->outstanding_bytes % asoc->frag_point)
>>>>> is zero, no delay is introduced.  The assumption is that this means
>>>>> that
>>>>> all outstanding packets (if any) are full-sized.
>>>>>
>>>>> Signed-off-by: Doug Graham <dgraham@nortel.com>
>>>>>
>>>>> ---
>>>>> --- linux-2.6.29/net/sctp/output.c    2009/08/02 00:47:44    1.3
>>>>> +++ linux-2.6.29/net/sctp/output.c    2009/08/02 00:51:18
>>>>> @@ -717,7 +717,8 @@ static sctp_xmit_t sctp_packet_append_da
>>>>>       * unacknowledged.
>>>>>       */
>>>>>      if (!sp->nodelay && sctp_packet_empty(packet) &&
>>>>> -        q->outstanding_bytes && sctp_state(asoc, ESTABLISHED)) {
>>>>> +        (q->outstanding_bytes % asoc->frag_point) != 0 &&
>>>>> +        sctp_state(asoc, ESTABLISHED)) {
>>>>>          unsigned len = datasize + q->out_qlen;
>>>>>  
>>>>>          /* Check whether this chunk and all the rest of pending
>>>>>               
>>>> Seem good! But it may be broken the small packet transmit which can be
>>>> used Nagle algorithm.
>>>> Such as this:
>>>>
>>>> Endpoint A                Endpint B
>>>>           <-------------  DATA (size52/2) delay send
>>>>           <-------------  DATA (size52/2) send immediately
>>>>           <-------------  DATA (size52/2) send immediately ** broken
>>>>           <-------------  DATA (size52/2) delay send
>>>>           <-------------  DATA (size52/2) send immediately
>>>>           <-------------  DATA (size52/2) send immediately ** broken
>>>>
>>>>
>>>> Can you try this one?
>>>>
>>>>
>>>>         
>>> I would, except I don't understand what you're getting at.  Does this
>>> mean to send a total of
>>> 6 1454 byte messages from B to A?  If so, why would the first one be
>>> delayed?
>>>     
>>
>> Oh, no, six 726 bytes(1452/2) messages, may be the 1st and 2nd are
>> bundled in one packet,
>> the 3rd is a single packet, the 4th, 5th are bundled, the 6th is single.
>> I have no test it.
>>
>>   
> Ah, so that / meant *division*!  I thought that was your notation
> meaning that the
> packets were fragmented into a 1452 byte chunk and a 2 byte chunk!
> Makes more sense now :-)
> 
> I admit that I didn't study too closely exactly what
> q->outstanding_bytes represents.  I assumed
> it meant the number of bytes that had been sent on the wire, but not yet
> acknowledged.
> Any bytes that were delayed because of Nagle would not be counted in
> outstanding_bytes
> (I assume).  So the first send of 726 would get sent immediately and
> counted in
> outstanding_bytes.  The second one would get delayed by Nagle and not
> counted
> in outstanding_bytes.  All the later ones would also get delayed by
> Nagle because
> outstanding_bytes is still 726.
> 
> I do think that using outstanding_bytes the way I did is probably an
> ugly kludge, and
> there's hopefully a better way.  But the right way will probably involve
> adding
> some more state to each association (the snd.sml variable mentioned in
> the minshall
> draft at the very least).  I'm not sure that using asoc->frag_point the
> way I did is correct
> either, because I think the frag_point can change during the lifetime of
> an association.

Using division in such a hot path is a non-starter to begin with, so we
definitely need to find a better way.

Using frag_point is not the right way to do it either since it's effected by
MTU and user API.

I think we can add something to sctp_outq structure to properly track this.

-vlad


> 
> --Doug
> 

