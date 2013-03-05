From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Date: Tue, 05 Mar 2013 21:04:05 +0000
Subject: Re: [PATCH] SCTP: Free the per-net sysctl table on net exit. v2
Message-Id: <51365DC5.5010003@fold.natur.cuni.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <87libe3w69.fsf@xmission.com> <87obgayoo8.fsf_-_@xmission.com> <5135B542.8020905@fold.natur.cuni.cz> <20130305.143233.739103204837913775.davem@davemloft.net>
In-Reply-To: <20130305.143233.739103204837913775.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, stable@kernel.org

David Miller wrote:
> From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
> Date: Tue, 05 Mar 2013 10:05:06 +0100
> 
>>   this is to let you know that this patch is still not in stable.
>> I just fetched 3.7.10 and reproduced the original problem.
> 
> 3.7.x is end of life and no longer being actively maintained.

??? 3.7.10 was released on 2013-02-27.

I disagree with making a kernel line 3.7 released on 2012-12-11 unsupported
while 3.8.0 was released just on 2013-02-18. That is way too new. Sorry
to say that but I don't expect 3.8 to be tested properly like 3.7.4 was
NOT in January 2013 when I reported the particular sctp bug, and several
others in USB, pci/e hotplug, etc. Now, with 3.8.2 being out one day
already I will hit for sure other bugs. I really want something stable.
For USB3.0 I need 3.2.x at least, actually 3.5 for some better URB handling
... The already buggy (in 3.2.x PCI/e hotplug) got reworked in about 3.5
into another buggy behavior so another workaround had to be invented.

Of course I do appreciate your work but if somebody bothered to report a bug
and some devs bothered to provide patches, you should let the fix go into life.
It is waiting in the patchwork since 1,5 month. By that time, 3.7.x was the
current, latest&greatest stable. I just don't agree.

Sorry for such a rant, I couldn't resist. ;)
Martin
