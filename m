From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 30 May 2008 13:02:56 +0000
Subject: Re: receiver window questions
Message-Id: <483FFB00.6050507@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <483EC663.1070805@hp.com>
In-Reply-To: <483EC663.1070805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Neil Horman wrote:
> On Thu, May 29, 2008 at 11:50:56AM -0400, Vlad Yasevich wrote:
>> Neil Horman wrote:
>>> On Thu, May 29, 2008 at 11:06:11AM -0400, Vlad Yasevich wrote:
>> I think this is hitting a condition where the receiver buffer is exhausted 
>> prior
>> to rwnd.  We generally mark the TSN as received prior to attempting an 
>> internal allocation to carry the data.  Thus, if this allocation fails, 
>> we'll continue
>> reporting the tsn as received and move the cum-tsn if appropriate.
>>
>> We've been trying to figure out what the correct way to solve this 
>> condition is
>> and so far haven't come up with a workable solution.
>>
> You're right it does sound like that.  You know, I haven't visited that code
> since we rewrote the receive buffer management code to expand according to
> available memory with the sk_mem_schedule api.  Do you think this could be as
> simple as removing this drop point?
> 

The problem is that if the user sets the buffer size, we don't auto-tune it.
This is what happened in this case.  However, even with auto-tunning, this
still shows up with 1 byte data chunks.

So, 2 things need to happen:
	1)  when we drop the chunk due to allocation failure, we have to remove
	    the tsn from the map.  This one is easy

	2)  We need to properly detect SWS.  I haven't looked fully at this, but
             it feels a bit more involved.  Implementing something like what BSD
	    has would also work, i.e. reducing a_rwnd 1 when receive buffer is
	    about to be exhausted.

-vlad
