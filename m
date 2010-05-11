From: Georgios Cheimonidis <gche@kth.se>
Date: Tue, 11 May 2010 18:45:31 +0000
Subject: Re: Gap not retransmitted after switchover
Message-Id: <4BE9A5CB.5090707@kth.se>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BE95C1C.4050902@hp.com>
In-Reply-To: <4BE95C1C.4050902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad!

I will compile it now and test it tomorrow morning. I will let you know 
as soon as I have the results.

Thanks!
/George

On 05/11/2010 05:35 PM, Vlad Yasevich wrote:
>
>
> Vlad Yasevich wrote:
>>
>> Georgios Cheimonidis wrote:
>>> Hi Vlad!
>>>
>>> I have repeated the test with the net-next kernel tree. It seems that
>>> the problem persists. Below, I summarize what I observed from the
>>> capture at the server side (the client's capture agrees with these
>>> observations). Although the timing differs somewhat from the previous
>>> test, the basic observation is still the same. After the server switches
>>> primary address and removes the previous primary from the association,
>>> some unacknowledged DATA packets that were transmitted to the previous
>>> primary (after it became unreachable) are never retransmitted to the new
>>> one.
>>>
>>
>> Thanks for testing.  I am looking to see what can be happening.
>>
>> -vlad
>>
>
> Hi George.
>
> I figured out why there were no retransmits.  Because you changed primary
> path, you kicked in the SFR-CACC algorithm, and our implementation didn't
> deal properly with the fact that some chunks may have moved from the old
> primary to the new one without going though a retransmit.
>
> There are really 2 ways to deal with this:
> 	1).  If we are deleting a transport that had outstanding data,
> 	automatically retransmit the data on the new transport.
>
> 	or.
>
> 	2) Under the same condition as above, move the data to the new primary
> 	destination and let fast-recovery take care of the issue.
>
> Linux implemented (2) from above, and thus this bug surfaced.
>
> Try the attached patch, and let me know if it fixes it for you.
>
> -vlad

