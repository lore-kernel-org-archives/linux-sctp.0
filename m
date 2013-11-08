From: tsoi andrew <tsoiandrew@gmail.com>
Date: Fri, 08 Nov 2013 03:35:51 +0000
Subject: Re: Multi-homing question
Message-Id: <CAJ0j_BbL7tdo9u8+OAPFSEBnYjaVWSCUTkab40y8Q5JREsUW0Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
In-Reply-To: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Neil,

The 176 routing is ok because when I shift 172.28.129.176 to primary address.
The 176 can be establish but 48 failed.
I guess it is related to primary and secondary setting.  Can secondary
IP be established also?

sctp                172.28.129.176:9082
     LISTEN
                    172.28.129.48:9082

sctp       0      0 172.28.129.176:9082         10.82.29.240:9082
     ESTABLISHED
Regards,
Andrew

On Thu, Nov 7, 2013 at 10:16 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Thu, Nov 07, 2013 at 11:45:25AM +0800, tsoi andrew wrote:
>> Dear Neil,
>>
>> Attached file is our tcpdump.
>> Now our secondary IP doesn't work.
>> Please advise. Thanks.
>>
>> IP info:
>> lksctp primary IP is 172.28.129.49
>> lksctp secondary IP is 172.28.129.176
>>
>> Client IP is 10.82.29.240/10.82.29.241
>>
>>
>  I think you mean the lksctp primary is 172.28.129.48, not 49, but no matter.
>
> Looking at this, its not just heartbeats that arent getting answered, nothing is
> getting responded to via the 176 address.  The only data that I see come out of
> that address are two abort frames (not sure what the cause is there yet).
>
> I would start by verifying basic connectivity via that address.  I'd try
> something like:
> ping -I 172.28.129.176 10.82.29.240
> and
> ping -I 172.28.129.176 10.82.29.241
>
> while running a tcpdump on the interface that holds the 176 address specifically
> to make sure that you're routing tables locally and network in generally can
> pass traffic over that address
>
> Neil
>
>>
>>
>>
>> Regards,
>> Andrew
>>
>> On Thu, Nov 7, 2013 at 10:43 AM, tsoi andrew <tsoiandrew@gmail.com> wrote:
>> >  Dear Neil,
>> >
>> > For more information, our secondary IP doesn't response COOKIE_ECHO
>> > also. Only our primary IP can response COOKIE_ECHO with COOKIE_ACK.
>> >
>> > Regards,
>> > Andrew
>> >
>> > On Thu, Nov 7, 2013 at 10:36 AM, tsoi andrew <tsoiandrew@gmail.com> wrote:
>> >> Dear Neil,
>> >>
>> >> Please find my network diagram first.
>> >> Now at server side, can't see our lksctp client 4 connection but only
>> >> 2 2 connection.  The reason is that heartbeat ACK not found.
>> >>
>> >> Regards,
>> >> Andrew
>> >>
>> >> On Mon, Nov 4, 2013 at 8:09 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >>> On Mon, Nov 04, 2013 at 09:59:44AM +0800, tsoi andrew wrote:
>> >>>> Dear Sir,
>> >>>>
>> >>>> I got a problem when set multi-homing to active/active.
>> >>>> That mean, It is expected that our lksctp server have 2 IP to connect
>> >>>> 2 IP of destination client with total 4 connections.
>> >>>> The flow is that client send "INIT" message with 2 (primary and
>> >>>> secondary) IP to our server and lksctp server return INIT_ACK. But
>> >>>> when second client send 'heartbeat' to us, lksctp server cannot return
>> >>>> ACK.
>> >>>> Moreover, we already proved our connectivity correct because when our
>> >>>> lksctp server send heartbeat to both destination client and they can
>> >>>> return ACK.
>> >>>> Would you mind sharing if lksctp lib already configure those
>> >>>> multi-homing purpose.
>> >>>>
>> >>> Can you provide a network diagram and a tcpdump of your connection?
>> >>> Neil
>> >>>
>> >>>>
>> >>>>
>> >>>> Best Regards,
>> >>>> Andrew Tsoi
>> >>>> --
>> >>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >>>> the body of a message to majordomo@vger.kernel.org
>> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>>>
>
>
