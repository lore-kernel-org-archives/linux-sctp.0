From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 14 Apr 2014 19:46:47 +0000
Subject: Re: Is SCTP throughput really this low compared to TCP?
Message-Id: <534C3B27.3070706@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31B23A@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 04/14/2014 08:54 PM, Matija Glavinic Pecotic wrote:
> Hello,
>
> On 04/14/2014 06:45 PM, ext Daniel Borkmann wrote:
>> Ok, thanks! I'll send out a revert for now today as this is otherwise
>> catastrophic ... when that is done, we/the developer from NSN can still
>> think about his patch and how to solve that differently.
>
> Thanks from my side as well, I will for sure look into it. Congestion control seems to be completely broken. Seems stack doesnt like the new way how rwnd is calculated. Dependency to ipv4 is also interesting.
>
> I also wasnt able to reproduce with my laptop/desktop, it seems some higher processing power is also needed to hit the case.

Posted here, Peter: http://patchwork.ozlabs.org/patch/339046/

Thanks for reporting and testing!
