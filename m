From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 04 Aug 2009 14:16:32 +0000
Subject: Re: [PATCHv2] sctp: Do not create SACK chunk if the final packet
Message-Id: <4A7842C0.4030402@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A72C518.20200@cn.fujitsu.com>
In-Reply-To: <4A72C518.20200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Doug Graham wrote:
>> Hi Vlad,
>>
>>> The only thing that I find slightly odd about this behavior is that
>>> the bundling
>>> occurs at the end of message and so I asked myself why aren't we
>>> accounting
>>> for SACK chunk at segmentation time?
>>>
>>> We could simply do something like this (completely not tested):
>>>
>>> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
>>> index 1748ef9..3bca0a2 100644
>>> --- a/net/sctp/chunk.c
>>> +++ b/net/sctp/chunk.c
>>> @@ -193,6 +193,15 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct
>>> sctp_association *asoc,
>>>                                             hmac_desc->hmac_len);
>>>         }
>>>
>>> +       /* Check to see if we have a pending SACK and try to let it
>>> be bundled
>>> +        * with this message.  Do this if we don't have any data to
>>> send.  To
>>> +        * check that, look at out_qlen and retransmit list.
>>> +        */
>>> +       if (timer_pending(&asoc->timers[SCTP_EVENT_TIMEOUT_SACK]) &&
>>> +           asoc->outqueue.out_qlen = 0 &&
>>> +           list_empty(&asoc->outqueue.retransmit))
>>> +               max -= WORD_ROUND(sizeof(sctp_sack_chunk_t));
>>> +
>>>         whole = 0;
>>>         first_len = max;
>>>
>>>   
>> Doesn't this reduce the  size of all chunks in a message?  You've
>> descremented "max", which I think
>> is the maximum size of all chunks in the message.  I could see maybe
>> doing this to leave space
>> in only the first chunk (ie: just decrement first_len by
>> sizeof(sctp_sack_chunk_t), but even that
>> doesn't buy much I think.  It wouldn't reduce the number of packets
>> sent, it would only mean
>> that the SACK is bundled with the first fragment, and then an extra
>> DATA fragment would need
>> to be created to send the last sizeof(sctp_sack_chunk_t) bytes of
>> DATA.   Example:
>>
>> Assume that the PMTU is 1000, that the user is sending a message of
>> 1990 bytes,  and
>> that sizeof(sctp_sack_chunk_t) is 16.  With my scheme, we'd send this:
>>
>>  DATA (1000 bytes)
>>  SACK
>>  DATA (990 bytes)
>>
>> with your scheme exactly as you propose it, we'd send
>>
>>  SACK + DATA (1000 - 16 = 984 bytes)
>>  DATA  (984 bytes)
>>  DATA  (22 bytes)
>>
>> If the scheme is modified to only reduce the size of the first
>> fragment, we'd send:
>>
>>  SACK + DATA (984 bytes)
>>  DATA  (1000 bytes)
>>  DATA  (6 bytes)
>>
>> The main point being that if a SACK won't fit in the last chunk of a
>> message, then your scheme
>> would just push all the data down so that a new DATA chunk has to be
>> sent to send the last
>> few bytes of data,

One thing to mention is that a generally accepted practice is send control
chunks first, be it bundled or separate.  This why BSD ends up sending SACK
first when it can't bundle it with outgoing data.  Additionally, the way
the code is now, we might end up sending a SACK even when sending DATA is
prohibited via congestion or receive window.   Should we still be doing it
even if we do not send DATA?


>>
>> I don't think there's any real advantage in sending the SACK in the
>> first packet rather than the
>> last one, but I agree that  it seems to make more sense.  It does seem
>> to complicate the
>> code a bit though.  At the moment, all the code related to
>> piggybacking SACKs is in
>> one place, whereas with this patch it'd be spread out to seemingly
>> unrelated code.

Well, this is something that we already have wrt AUTH and COOKIE-ECHO chunks.
It has to do with where we end up segmenting.  If we want the ability to bundle,
we either need to size the data appropriately (this patch) or try to find the
chunk that we can bundle with (your patch).

My personal opinion is that sizing things properly from the beginning is the
right approach.  Note that this will only happen when we have no data queued up
so will not effect applications that try to do bulk transfers, where as you
patch might impact those applications unnecessarily, since they behave much
better with a delayed ACK behavior.

-vlad
> 
> I think Vlad's patch should be like this:
> 
>         whole = 0;
>         first_len = max;
>         ~~~~~~~~~~~~~~~~~~~~
> 
> +       /* Check to see if we have a pending SACK and try to let it be bundled
> +        * with this message.  Do this if we don't have any data to send.  To
> +        * check that, look at out_qlen and retransmit list.
> +        */
> +       if (timer_pending(&asoc->timers[SCTP_EVENT_TIMEOUT_SACK]) &&
> +           asoc->outqueue.out_qlen = 0 &&
> +           list_empty(&asoc->outqueue.retransmit))
> +               first_len -= WORD_ROUND(sizeof(sctp_sack_chunk_t));
>                 ~~~~~~~~~~~~~~
> ......
> 

Yes.  It should really only change the first segment size.


