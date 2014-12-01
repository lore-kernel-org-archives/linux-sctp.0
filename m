From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 01 Dec 2014 18:08:35 +0000
Subject: Re: panic in skb_push via sctp
Message-Id: <547CAEA3.3090906@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com> <547CA719.6060101@redhat.com> <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
In-Reply-To: <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, vyasevich@gmail.com

On 12/01/2014 07:02 PM, Robert Święcki wrote:
> Thanks for looking into it. I can try with your patch, but no
> guarantees that the fuzzer will hit the same condition in some
> reasonable time-frame. Will get back in some time with results.

Ok, thanks!

> PS. If you think it's possible to create a repro (userland code) which
> can trigger this, I can give it a try.

Did by accident trinity create tunnels? It looks that upper layer
protocols (except SCTP) all allocate and reserve MAX_HEADER to
accommodate enough head room in worst case for possible tunnels.

> 2014-12-01 18:36 GMT+01:00 Daniel Borkmann <dborkman@redhat.com>:
>> On 12/01/2014 05:49 PM, Robert Święcki wrote:
>>>
>>> I don't have much more, cause my kernel is kASLRNized and gdb cannot
>>> handle that, but pasting output from kdb. Maybe somebody will be able
>>> to see something obvious.
>>>
>>>    <0>[93699.703244] skbuff: skb_under_panic: text:ffffffff83cff03e
>>> len:104 put:56 head:ffff8803bd804ec0 data:ffff8803bd804ebc tail:0x64
>>> end:0xc0 dev:<NULL>
>>
>>
>> Thanks for the report!
>>
>> On a first view, it looks like we should be using MAX_HEADER instead
>> of LL_MAX_HEADER here, could you try with the following patch:
>>
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index 42dffd4..fc5e45b 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -401,12 +401,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>>          sk = chunk->skb->sk;
>>
>>          /* Allocate the new skb.  */
>> -       nskb = alloc_skb(packet->size + LL_MAX_HEADER, GFP_ATOMIC);
>> +       nskb = alloc_skb(packet->size + MAX_HEADER, GFP_ATOMIC);
>>          if (!nskb)
>>                  goto nomem;
>>
>>          /* Make sure the outbound skb has enough header room reserved. */
>> -       skb_reserve(nskb, packet->overhead + LL_MAX_HEADER);
>> +       skb_reserve(nskb, packet->overhead + MAX_HEADER);
>>
>>          /* Set the owning socket so that we know where to get the
>>           * destination IP address.
