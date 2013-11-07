From: tsoi andrew <tsoiandrew@gmail.com>
Date: Thu, 07 Nov 2013 02:43:06 +0000
Subject: Re: Multi-homing question
Message-Id: <CAJ0j_BamEiY4qMM4WNPOcSTU+OMnQ52Xxxfg_RCCkYwE=E_1=Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
In-Reply-To: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

 Dear Neil,

For more information, our secondary IP doesn't response COOKIE_ECHO
also. Only our primary IP can response COOKIE_ECHO with COOKIE_ACK.

Regards,
Andrew

On Thu, Nov 7, 2013 at 10:36 AM, tsoi andrew <tsoiandrew@gmail.com> wrote:
> Dear Neil,
>
> Please find my network diagram first.
> Now at server side, can't see our lksctp client 4 connection but only
> 2 2 connection.  The reason is that heartbeat ACK not found.
>
> Regards,
> Andrew
>
> On Mon, Nov 4, 2013 at 8:09 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Mon, Nov 04, 2013 at 09:59:44AM +0800, tsoi andrew wrote:
>>> Dear Sir,
>>>
>>> I got a problem when set multi-homing to active/active.
>>> That mean, It is expected that our lksctp server have 2 IP to connect
>>> 2 IP of destination client with total 4 connections.
>>> The flow is that client send "INIT" message with 2 (primary and
>>> secondary) IP to our server and lksctp server return INIT_ACK. But
>>> when second client send 'heartbeat' to us, lksctp server cannot return
>>> ACK.
>>> Moreover, we already proved our connectivity correct because when our
>>> lksctp server send heartbeat to both destination client and they can
>>> return ACK.
>>> Would you mind sharing if lksctp lib already configure those
>>> multi-homing purpose.
>>>
>> Can you provide a network diagram and a tcpdump of your connection?
>> Neil
>>
>>>
>>>
>>> Best Regards,
>>> Andrew Tsoi
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
