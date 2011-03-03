From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 09:27:12 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <4D6F5EF0.50301@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> More read about the ethreal captures.
>
> The peer shutdown association 6 seconds after it missed the
> retransmittion of sctp.data_tsn = 447375618. During the 6 seconds,
> the peer sent a lot of SACKs but Linux did not retransmit the chunk.
>
> Could someone look at it?

I will post a patch about this, can you try it and tell us whether
the patch can fix your problem?

> Great thanks!
>
> 2011/3/3 Mingyuan Zhu <liyha.zhu@gmail.com>:
>> I attached more capture packets.
>> From the ethreal file, I found some chunks are retransmitted the
>> second time after 3 seconds. The peer does not shutdown the
>> association. But sometimes the peer shutdown the association.
>> For example:
>> sctp.data_tsn = 447375491 or sctp.data_tsn = 447375492 are
>> retransmitted 3 seconds after the first retransmittion.
>>
>> And sctp.data_tsn = 447375618, the peer shutdown association before
>> the 2nd retransmittion.
>>
>> So comes the question, why doesn't sctp retransmit immediately when it
>> receives SACK, instead it retransmit after 3 seconds?
>>
>> 2011/3/1 Mingyuan Zhu <liyha.zhu@gmail.com>:
>>> My test is working on kernel 2.6.34-4.
>>>
>>> 2011/3/1 Wei Yongjun <yjwei@cn.fujitsu.com>:
>>>>> I searched the src code. We did not use sinfo_timetolive.
>>>> I guess there were some retransmit issues in 2.6.31 and
>>>> latest kernel hit the rwnd limit, I will try to reproduce it
>>>> and fix it. wait some time since I have other work to do now.
>>>>
>>>>> 2011/3/1 Wei Yongjun <yjwei@cn.fujitsu.com>:
>>>>>> Did you using sinfo_timetolive when you send sctp message?
>>>>>> There is a bug when we handle sinfo_timetolive, I will fix this later.
>>>>>>
>>>>>>> Mingyuan Zhu wrote, at 02/22/2011 09:14 PM:
>>>>>>>> What kind of test tool you used for the testing?
>>>>>>> No test tool can directly test your case.
>>>>>>> But SCTP Conformance Test Suite Project can help you.
>>>>>>> See: http://networktest.sourceforge.net/
>>>>>>>
>>>>>>> Your case is not in the tool, so you need to write your case by yourself.
>>>>>>> data#22 has similar test procedure, see
>>>>>>> http://networktest.sourceforge.net/log/2.6.29-rc4/IPv4/data/22.html
>>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
