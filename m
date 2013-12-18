From: Vlad Yasevich <vyasevic@redhat.com>
Date: Wed, 18 Dec 2013 15:20:15 +0000
Subject: Re: Send fail notifications
Message-Id: <52B1BD2F.8070501@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B1AA25.3000700@mojatatu.com>
In-Reply-To: <52B1AA25.3000700@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/18/2013 09:06 AM, Jamal Hadi Salim wrote:
> 
> A little more info:
> - When i have MTU > 16K, no problem, 1 notification makes it through
> with an EOR and proper info
> EOR.
> - ssf_flags are always zero (thats one other place that may have carried
> such extra info)

meaning that chunks was unsent.

> - kernel 3.12.0 (with other non-sctp patches)
> 
> cheers,
> jamal
> 
> On 12/18/13 08:59, Jamal Hadi Salim wrote:
>>
>> Lets say  between server and client i have an MTU of 4K.
>> I send 16K with partial reliability setting.
>> If the data gets through the receiver sees (I think
>> SCTP_PARTIAL_DELIVERY_POINT may change this behavior but it probably
>> defaults to MTU):
>>
>> Msg1, 4k, !EOR
>> Msg2, 4k, !EOR
>> Msg3, 4k, !EOR
>> Msg4, 4k, EOR
>>
>> OTOH, at sender if the send fails because PR timeout on some data
>> chunk occurs i receive from the kernel not 1 but 4 notifications.
>> Msg1, 4k, Notification(send failed, ssf_length=4k), EOR
>> Msg2, 4k, Notification(send failed, ssf_length=4k), EOR
>> Msg3, 4k, Notification(send failed, ssf_length=4k), EOR
>> Msg4, 4k, Notification(send failed, ssf_length=4k), EOR
>> .... some last message here to account for notification overhead ....

You receive one notification per chunk.  This is the way lksctp
implemented failure notification.  Whether this is the right or
wrong way to do it may be up for debate.

As I said in the private thread that started this, current spec
is referring to messages when it talks about SEND_FAILED[_EVENT].
It covers the case where the whole message has failed and when
partial message has failed, but it misses the case where parts
of message failed for different reasons (SENT vs. UNSENT).  In
particular the setting sinfo_flags in the sndrcvinfo structure
aren't covered in this case.

So, even when talking about messages, it's feasible that you would
receive multiple notifications for the same message.  One may
specify things like:
   ssf_flags = SENT
   sinfo.sinfo_flags = DATA_FIRST_FRAG

the other may have:
  ssf_info = UNSENT
  sinfo.sinfo_flags = DATA_LAST_FRAG

The EOR flags would be sent on each notification if was received
by your application in full, since in this case EOR signals the
end of a particular notification, the the end of the user data
message we are reporting about.

>>
>> I was expecting only the last one to have an EOR or least the
>> ssf_length to be telling me there's more than 4K. Stoopid question:
>> Is there some  other field I should be looking at?

You could look at the sinfo_flags.  These flags will mirror the flags
from the chunk thus allowing you to kind-of reassemble the data.
The hitch here is the following text in the spec:
   ssf_info:  This field includes the ancillary data (struct
      sctp_sndrcvinfo) used to send the undelivered message
                     ^^^^^^^^^^^^^^^^^^^^^^^
lksctp follows that by simply copying the user supplied data, thus
missing things like chunk ssn, tsn and other fields that could
be useful in identifying this part of the message.

>>
>> The only way i could tell the 5 notifications are from the same
>> original message is when i provide a sinfo_context at sendmsg() time.
>>

That really is the only reliable way to tell if the parts came from the
same message.
In fact, if you look at the description of sinfo_context in Section
5.3.2, you'll see that this is exactly what it's there for.

-vlad

-vlad



