From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 07:54:28 +0000
Subject: Re: [PATCH] sctp: fix the check for path failure detection
Message-Id: <4A924734.6000702@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1250838275-7444-1-git-send-email-chunbo.luo@windriver.com>	 <4A8F15F5.3020901@hp.com> <1251080117.6513.11.camel@pek-cluo-desktop>
In-Reply-To: <1251080117.6513.11.camel@pek-cluo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Luo Chunbo <chunbo.luo@windriver.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Luo Chunbo =D0=B4=B5=C0:
> On Fri, 2009-08-21 at 17:47 -0400, Vlad Yasevich wrote:
>  =20
>> Chunbo Luo wrote:
>>    =20
>>> The transport is marked DOWN immediately after sending the max+1 HB,
>>> which is equal to not sending the max+1 HB at all. We should wait
>>> a next period and make sure the last HB is not acknowledged.
>>>
>>>      =20
>> I don't think this code does what you want either...
>>
>> Let's say path_max_rxt =3D 2.  What we'll get is:
>> 	timeout:
>> 		err++ (1)
>> 		if (err > 2) false
>> 		send HB
>> 		reset timer
>> 	timeout:
>> 		err++ (2)
>> 		if (err > 2) false
>> 		send HB
>> 		reset timer
>> 	timeout:
>> 		err++ (3)
>> 		if (err > 2)
>> 			set transport DOWN
>> 		send HB
>> 		reset timer.
>>
>> We only had 2 unacknowledged HB when we should have had 3.
>>    =20
>
> The error count is increment after the HB was sent, and the error count
> check is before sending HB.
>
> Let's say path_max_rxt =3D2 . What we really get is:
>
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (1)
> 	reset timer
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (2)
> 	reset timer
> timeout:
> 	if( err > 2) false
> 	send HB
> 	err++ (3)
> 	reset timer
> timeout:
> 	if( err > 2)
> 		set transport DOWN
> 	send HB
> 	reset timer
>
> Here We had 3 unacknowledged HBs


But with Vlad's advice, you just need to do little change to the kernel
codes, may be two lines's patch, and it can do the same thing.



