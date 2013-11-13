From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 13 Nov 2013 19:10:59 +0000
Subject: Re: [PATCH 1/1] net: sctp: bug fixing when sctp path recovers
Message-Id: <5283CEC3.4050507@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1384306486-31345-1-git-send-email-changxiangzhong@gmail.com> <5282E5F9.5000506@gmail.com> <5282E9EC.3090307@gmail.com> <52833BD3.4040003@redhat.com> <5283CDD1.3090309@gmail.com>
In-Reply-To: <5283CDD1.3090309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chang <changxiangzhong@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dreibh@simula.no

On 11/13/2013 08:06 PM, Chang wrote:
> On 11/13/2013 09:44 AM, Daniel Borkmann wrote:
>> On 11/13/2013 03:54 AM, Chang wrote:
>>> On 11/13/2013 03:37 AM, Vlad Yasevich wrote:
>>>> On 11/12/2013 08:34 PM, Chang Xiangzhong wrote:
>>>>> Look for the __two__ most recently used path/transport and set to active_path
>>>>> and retran_path respectively
>>
>> Please also for the log, elaborate a bit more, explaining what currently
>> happens, and what the effects of this bug are, so that later when people
>> are looking through the Git log they can easily get what problem you are
>> trying to fix; and if possible, add:
>>
>> Fixes: <12 digits SHA1> ("<commit title>")
>>
> Yeah, sure, I'll elaborate that more specifically.

Thanks !

> I assume the 12-digit SHA1 is the revision number. But may I ask where and how shall I add the tag "Fixes" tag? The revision number is generated after "git commit", how can I know that in advance?

Nope, it's the affected commit id from the current git log that
your patch fixes.

Have a look for example at commit:

98bbc06aabac5a2 ("net: x86: bpf: don't forget to free sk_filter (v2)")
