From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 14 Dec 2013 17:36:37 +0000
Subject: Re: undetected closed apps
Message-Id: <52AC9725.8020002@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/14/13 12:23, Michael Tuexen wrote:


> OK. This should trigger the SHUTDOWN procedure, but leave the socket alive.
> Any reason why you can't try close() instead?

I cant remember the reason - but there was one in the past. I will give 
close a try. I can access the machine with problematic kernel
in about 1 hour from now and will post.

The question is: Why does this work with older kernels.
Or even more with the same kernel if the client doesnt
send very fast.

cheers,
jamal

> Best regards
> Michael
>>
>> cheers,
>> jamal
>>
>
>
>

