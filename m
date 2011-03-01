From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 08:26:58 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <4D6CADD2.4000200@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> I searched the src code. We did not use sinfo_timetolive.

I guess there were some retransmit issues in 2.6.31 and
latest kernel hit the rwnd limit, I will try to reproduce it
and fix it. wait some time since I have other work to do now.

> 2011/3/1 Wei Yongjun <yjwei@cn.fujitsu.com>:
>> Did you using sinfo_timetolive when you send sctp message?
>> There is a bug when we handle sinfo_timetolive, I will fix this later.
>>
>>> Mingyuan Zhu wrote, at 02/22/2011 09:14 PM:
>>>> What kind of test tool you used for the testing?
>>> No test tool can directly test your case.
>>> But SCTP Conformance Test Suite Project can help you.
>>> See: http://networktest.sourceforge.net/
>>>
>>> Your case is not in the tool, so you need to write your case by yourself.
>>> data#22 has similar test procedure, see
>>> http://networktest.sourceforge.net/log/2.6.29-rc4/IPv4/data/22.html
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
