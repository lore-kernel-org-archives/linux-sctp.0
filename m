From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 18 Dec 2013 17:58:56 +0000
Subject: Re: undetected closed apps
Message-Id: <52B1E260.9040601@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/18/2013 07:30 AM, Jamal Hadi Salim wrote:
> On 12/17/13 10:11, Vlad Yasevich wrote:
> 
>> That's about it.  You can also use stap.  It's on the project
>> todo list to provide some good stap scripts.
>>
> 
> Maybe a little overkill for me for now.
> 
>> The other thing that is useful for debugging things like this is
>> the object counting in SCTP (CONFIG_SCTP_DBG_OBJCNT), but it's a
>> kernel config option so not sure how easily you'd be able to use
>> it.
>>
> 
> Not easy - but for newer kernels i could do this.
> 
> 
>>
>> The initial commit 45122ca26ced7fae41049326a3797a73f961db2e was
>> added to 3.8.  In 3.9 we fixed a bug where the association closures
>> were being delayed too long and were preventing socket rebinding
>> (commit 8c98653f05534acd1cb07ea4929702a3659177d1).
>>
> 
> It was a bit of a merge nightmare trying to revert the three individual
> patches yesterday, so i am abandoning that effort for now.
> I will try to find time over the holidays to do git bisect.
> 
> cheers,
> jamal

Jamal

could you post an output for /proc/net/sctp/assocs for the association
in this bad state?

Thanks
-vlad

