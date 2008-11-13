From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 13 Nov 2008 12:19:03 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081113121903.GF5549@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu 06-11-08 12:05:57, Michal Hocko wrote:
> Hi,
> we are experiencing BUG and hang conditions with simple echo client-server 
> SCTP application.  It looks like a race condition which is rather hard to 
> trigger. 
> 
> BUG traces come usually with sctp code in the code paths (see traces attached) 
> but sometimes the machine simply hangs without any traces at all. It 
> obviously depends on the kernel configuration and HW (different machines 
> comes with different traces).
> 
> Initial report of this issue was against SLES10SP2 (2.6.16.60) kernel but we 
> were able to reproduce with upstream Linus tree as well (2.6.
> {25,26,27,75fa67706cce5272bcfc51ed646f2da21f3bdb6e}).
> We were able to reproduce _only_ with 2 _directly_ connected machines with 
> 1GiB wired ethernet connection. (no BUG condition occurred on the single HW 
> nor with connection through at least one switch or 100MB). 

Our later testing shows that also switches in the path don't prevent
from the crash. It just takes longer.
This means that this is no more artificial configuration problem, but
may be vulnerable also remotely when attacker has a quick connection and
enough time&patience.

> Original report states that it takes from minutes to hours to trigger
> this issue but it takes hours in my testing environment.

> 
> At first we thought that this can be caused by SO_REUSEADDR used by server 
> application, but I was able to reproduce also without it.
> We are also not 100% sure that the sctp is culprit here, but almost all traces 
> contain some sctp paths so it smells suspicious.
> 
> This may have security implications so I am not attaching the crash 
> application directly into this email (please write me and I will send it 
> directly or let me know if it is safe to publish it publicly in the mailing 
> list).
> 
> Thanks for any help/hints and let me know if you need some more information or 
> test some patches.
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
