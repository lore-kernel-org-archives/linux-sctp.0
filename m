From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 19 Apr 2008 05:45:59 +0000
Subject: Re: [PATCH] SCTP: Fix DATA retransmit after fast retransmit
Message-Id: <48098717.4010006@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48085441.2030904@cn.fujitsu.com>
In-Reply-To: <48085441.2030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad:

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>> If DATA chunk is resend by fast retransmit, and no SACK is received, 
>> this DATA chunk can not be send again after T3 timeout.
>>
>> This is because chunk->sent_at will be update after chunk is 
>> transmitted, but after fast retransmit, T3 timer will not be reset, 
>> so sctp_retransmit_mark() can not mark this chunk for retransmit, and 
>> will never sent again because not T3 timer is running.
>>
>> You can test this by following data transmit:
>>
>> Endpoint A                    Endpoint B
>>
>>              <--------------  DATA1
>>              <--------------  DATA2
>>              <--------------  DATA3
>>              <--------------  DATA4
>>              <--------------  DATA5
>> SACK(1,2)    --------------->
>> SACK(1,3)    --------------->
>> SACK(1,3,4)  --------------->
>> SACK(1,3,4,5)--------------->
>>              <--------------  DATA2 (Fast retransmit)
>> NO SACK is sent, DATA2 will never be send again.
>
> The problem with this patch is that a fast retransmitted chunk ends up 
> being
> retransmitted again too early.
>
> There is text in 4960 that I am really trying to understand the 
> intention of:
>
>   4)  Restart the T3-rtx timer only if the last SACK acknowledged the
>       lowest outstanding TSN number sent to that address, or the
>       endpoint is retransmitting the first outstanding DATA chunk sent
>       to that address.
>
Following is my understand:

1. Restart the T3-rtx timer only if the last SACK acknowledged the 
lowest outstanding TSN number sent to that address. SACK4 as following 
acknowledged the lowest outstanding TSN number.

Endpoint A                    Endpoint B
             <--------------  DATA1 (TSN=1)
             <--------------  DATA2 (TSN=2)
             <--------------  DATA3 (TSN=3)
             <--------------  DATA4 (TSN=4)
             <--------------  DATA5 (TSN=5)
SACK1(1,2)(TSN=0)  --------------->
SACK2(1,3)(TSN=0)  --------------->
SACK3(1,3,4)(TSN=0)--------------->
SACK4(3,4,5)(TSN=1)--------------->  (*)
             <--------------  DATA2 (Fast retransmit)


2. The endpoint is retransmitting the first outstanding DATA chunk sent 
to that address.

Endpoint A                    Endpoint B
             <--------------  DATA1 (TSN=1)
             <--------------  DATA2 (TSN=2)
             <--------------  DATA3 (TSN=3)
             <--------------  DATA4 (TSN=4)
             <--------------  DATA5 (TSN=5)
SACK1(1,2)(TSN=0)    --------------->
SACK2(2,3)(TSN=0)    --------------->
SACK3(2,3,4)(TSN=0)  --------------->
SACK4(2,3,4,5)(TSN=0)--------------->
             <--------------  DATA1 (Fast retransmit)


T3-rtx timer will be restart only in the two case above.

> In particular the send part of the above sentence.
>
> Is the meaning that when fast retransmitting the earliest outstanding 
> DATA,
> we should restart T3-RTX?
>
> If that's the case, then when we fast-rtx DATA2 above, we should restart
> t3-rtx timer.
T3-rtx timer will not be restart, since it the last SACK not 
acknowledged the lowest outstanding TSN number.

So i think check for "!chunk->fast_retransmit" is correct in my patch. 
And fast retransmit also need some check to restart T3-rtx in the two 
case above.

Is it my understand correct?

Wei Yongjun
