From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sat, 14 Dec 2013 18:47:03 +0000
Subject: Re: undetected closed apps
Message-Id: <0D65C16F-D417-40EB-81DB-E8ADD5A5626F@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Dec 14, 2013, at 7:35 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> 
> Tried using close - no luck. I may have observed maybe 1 out
> 100 runs where a proper shutdown was sent - which maybe an
> an improvement, but i could be imagining that.
OK. What happens when the shutdown guard timer runs off
(it should be around 180 seconds)?
> If it is any help: I am using epoll via libev but i dont
> think thats the problem because it works 100% on older kernels.
No idea...

Best regards
Michael
> 
> cheers,
> jamal
> 
> On 12/14/13 12:36, Jamal Hadi Salim wrote:
>> On 12/14/13 12:23, Michael Tuexen wrote:
>> 
>> 
>>> OK. This should trigger the SHUTDOWN procedure, but leave the socket
>>> alive.
>>> Any reason why you can't try close() instead?
>> 
>> I cant remember the reason - but there was one in the past. I will give
>> close a try. I can access the machine with problematic kernel
>> in about 1 hour from now and will post.
>> 
>> The question is: Why does this work with older kernels.
>> Or even more with the same kernel if the client doesnt
>> send very fast.
>> 
>> cheers,
>> jamal
>> 
>>> Best regards
>>> Michael
>>>> 
>>>> cheers,
>>>> jamal
>>>> 
>>> 
>>> 
>>> 
>> 
> 
> 

