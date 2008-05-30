From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 30 May 2008 20:23:34 +0000
Subject: Re: receiver window questions
Message-Id: <20080530202334.GA1885@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, May 30, 2008 at 05:08:10PM +0200, Michael Tuexen wrote:
> Hi Vlad,
>
> is there any description available how the auto-tuning works?
> But even with auto-tuning you still have the a_rwnd you report
> to the outside world (in SACKs) and an internal value which
> you use for tracking you buffer, right?
>


As Vlad said, there is no formal description available, but if you want a
functional overview, the sk_mem_schedule api is the place to look to understand
how thresholds, and memory pressure detection work

Regards
Neil


> Best regards
> Michael
>
> On May 30, 2008, at 3:02 PM, Vlad Yasevich wrote:
>
>> Neil Horman wrote:
>>> On Thu, May 29, 2008 at 11:50:56AM -0400, Vlad Yasevich wrote:
>>>> Neil Horman wrote:
>>>>> On Thu, May 29, 2008 at 11:06:11AM -0400, Vlad Yasevich wrote:
>>>> I think this is hitting a condition where the receiver buffer is 
>>>> exhausted prior
>>>> to rwnd.  We generally mark the TSN as received prior to attempting an 
>>>> internal allocation to carry the data.  Thus, if this allocation fails, 
>>>> we'll continue
>>>> reporting the tsn as received and move the cum-tsn if appropriate.
>>>>
>>>> We've been trying to figure out what the correct way to solve this 
>>>> condition is
>>>> and so far haven't come up with a workable solution.
>>>>
>>> You're right it does sound like that.  You know, I haven't visited that 
>>> code
>>> since we rewrote the receive buffer management code to expand according 
>>> to
>>> available memory with the sk_mem_schedule api.  Do you think this could 
>>> be as
>>> simple as removing this drop point?
>>
>> The problem is that if the user sets the buffer size, we don't auto-tune 
>> it.
>> This is what happened in this case.  However, even with auto-tunning, this
>> still shows up with 1 byte data chunks.
>>
>> So, 2 things need to happen:
>> 	1)  when we drop the chunk due to allocation failure, we have to remove
>> 	    the tsn from the map.  This one is easy
>>
>> 	2)  We need to properly detect SWS.  I haven't looked fully at this, but
>>            it feels a bit more involved.  Implementing something like what 
>> BSD
>> 	    has would also work, i.e. reducing a_rwnd 1 when receive buffer is
>> 	    about to be exhausted.
>>
>> -vlad
>>

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
