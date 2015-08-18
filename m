From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 18 Aug 2015 15:35:24 +0000
Subject: Re: SCTP heartbeat transmission interval in not working as expected
Message-Id: <55D350BC.9010504@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
In-Reply-To: <f0156706abe9412c9d158cac2724d12a@BGHMBXV01.AD.ARICENT.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On 08/17/2015 04:06 PM, malc wrote:
> Hey Vlad, Ravi,
> 
> Pretty sure the initial confusion was around the first HB apparently
> not using HB.Interval + RTO.*Init* (=3s in the given scenario) +/-
> 50%. (I sent a message suggesting that this would not be the case if
> DATA/SACK had been exchanged causing an RTT calculation before the HB
> timer was started, but forgot to set plaintext so vger bounced me...)
> I am pretty sure this can happen if we bundle DATA with COOKIE ECHO,
> wasn't sure if we do an RTO calc for any of the initial handshake
> /without/ DATA being exchanged (spec doesn't say to afaik, but it
> doesn't say not to either...)

First HB on a non-primary path will be within an RTO without HB.Interval
as it would be a path confirmation probe HB.  Until the path is confirmed,
HBs are sent based on RTO only.  Once the path is confirmed, HB.Interval
takes effect.

-vlad

> 
> If Ravi can share wireshark traces - I guess it will make it most
> obvious exactly which scenario he is seeing. I can tell you that last
> time I tested with a 3rd party conformance tool (Testing Tech), albeit
> a while ago now - this was all working as I understood it should.
> 
> Cheers,
> malc.
> 
> On Mon, Aug 17, 2015 at 10:37 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>> On 08/17/2015 06:45 AM, Ravi Puttachannaiah wrote:
>>> Hi Michael,
>>>
>>> Thanks for your quick response. It will be helpful if you can explain why it should be 30.5 to 31.5.
>>>
>>> As per our understanding initially it should start with 33-seconds (30[HBInterval]+3[RTO initial]) right ?. Please correct me if my understanding is in-correct.
>>>
>>>
>>
>> So this is what the SCTP spec actually states:
>>
>>    On an idle destination address that is allowed to heartbeat, it is
>>    recommended that a HEARTBEAT chunk is sent once per RTO of that
>>    destination address plus the protocol parameterh 'HB.interval', with
>>    jittering of +/- 50% of the RTO value, and exponential backoff of the
>>    RTO if the previous HEARTBEAT is unanswered.
>>
>>
>> I can see how this could be interpreted as  RTO + HB.Interval +/- 50% RTO,
>> but that's not what should actually happen.
>>
>> The basis of the algorithm is that packet is sent once per RTO with an RTO
>> jittering of %50.  So, for the RTO of X, the base "once per RTO" transmission
>> is .5X - 1.5X.  Then you add to this the HB.Interval value.
>>
>> For your RTO values, with an RTO.min of 1sec, your RTO will most likely be clamped
>> at 1 sec (unless you really have very long RTO values).
>> This means that for HBs, your base RTO will vary between 0.5-1.5 sec.
>>
>> This should explain what you are actually seeing on the wire.
>>
>> -vlad
>>
>>> Regards,
>>>
>>> Ravi
>>>
>>>
>>> -----Original Message-----
>>> From: Michael Tuexen [mailto:Michael.Tuexen@lurchi.franken.de]
>>> Sent: Monday, August 17, 2015 6:43 PM
>>> To: Ravi Puttachannaiah
>>> Cc: linux-sctp@vger.kernel.org
>>> Subject: Re: SCTP heartbeat transmission interval in not working as expected
>>>
>>>> On 17 Aug 2015, at 13:45, Ravi Puttachannaiah <ravi.puttachannaiah@aricent.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>>                We are using LKSCTP (ver 1.0.16) and we observe that the SCTP heartbeat transmission interval in not working as expected. Following is the SCTP configuration settings we are using (applied using setsockopt()).
>>>>
>>>>
>>>> hbinterval0-sec
>>>> RTO initial=3-sec
>>>> RTO min=1-sec
>>>> RTO max`-sec
>>>>
>>>>                As per our understanding the SCTP heartbeat transmission interval value should be between 31.5 to 34.5 seconds as per the calculation "RTO+HBInterval+delta(Âą0.5ofRTO)" but we are always seeing the value in-between 30.6 to 31.5 seconds.
>>> Assuming that the RTO is 1 second (after an RTT measurement this is true, I guess), you would get HBs every
>>> 30.5 and 31.5 seconds. Seems to be about what you measure.
>>>
>>> Best regards
>>> Michael
>>>>
>>>>                Could somebody confirm if this is an issue or not and in-case of an issue how we can resolve.
>>>>
>>>>                We are using LKSCTP version 1.0.16 and 1.0.7 and in both the versions we are observing the same behavior.
>>>>
>>>>
>>>> Regards,
>>>>
>>>> Raviâ€‹
>>>>
>>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>>> N‹§ēæėrļ›yúčšØbēXŽķĮ§vØ^–)Þš{.nĮ+‰·ĨŠ{ąąËiŠ{ayš Ę‡Ú™ë,j
>>> ­ĒfĢĒ·hš‹āzđ ŪwĨĒļ
>>> Ē·Ķj:+v‰ĻŠwčjØmķŸĸū
>>> Ŧ‘ęįzZ+ƒųšˇŠÝĒj"¯ú!
>>>
>>> "DISCLAIMER: This message is proprietary to Aricent and is intended solely for the use of the individual to whom it is addressed. It may contain privileged or confidential information and should not be circulated or used for any purpose other than for what it is intended. If you have received this message in error, please notify the originator immediately. If you are not the intended recipient, you are notified that you are strictly prohibited from using, copying, altering, or disclosing the contents of this message. Aricent accepts no responsibility for loss or damage arising from the use of the information transmitted by this email including damage from virus."
>>> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���i�{ay� ʇڙ�,j ��f���h���z� �w��� ���j:+v���w�j�m���� ����zZ+�����ݢj"��!tml>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

