From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 17 Dec 2013 13:49:11 +0000
Subject: Re: undetected closed apps
Message-Id: <52B05657.8010901@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/16/13 10:19, Vlad Yasevich wrote:
> On 12/14/2013 10:04 AM, Jamal Hadi Salim wrote:

> Hi Jamal
>
> The only thing I can think off that may be causing this is the
> rcu-fication of the transport list in the associations.
>
> You might be able to test by reverting:
>    771085d6bf3c52de29fc213e5bad07a82e57c23e
>    8c98653f05534acd1cb07ea4929702a3659177d1
>    45122ca26ced7fae41049326a3797a73f961db2e


Thanks Vlad. I will try newer kernels and revert these changes
incrementally and see if there's improvement.

BTW: What tools are useful to monitor sctp behavior?
For this case I have been watching activity using
/proc/net/sctp/assocs, strace and tcpdump.

cheers,
jamal

PS: I currently have no choice on what kernels already deployed
that need the software feature but can make recommendations
for future upgrades. It would be good to narrow it down.
