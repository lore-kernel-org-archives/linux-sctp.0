From: David Miller <davem@davemloft.net>
Date: Thu, 19 Dec 2019 17:52:08 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191219.095208.349922153806345978.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
        <20191219131700.GA1159@hmswarspite.think-freely.org>
        <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
In-Reply-To: <CAKD1Yr2wyWbwCGP=BNqAfsGu9cjgjD12-ePjs648Or-FjqHyBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lorenzo@google.com
Cc: nhorman@tuxdriver.com, zenczykowski@gmail.com, maze@google.com, netdev@vger.kernel.org, stranche@codeaurora.org, subashab@codeaurora.org, edumazet@google.com, linux-sctp@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>
Date: Thu, 19 Dec 2019 23:02:32 +0900

> But in any case, the result would be more complicated to use and
> maintain, and it would likely also be less realistic, such that a
> sophisticated conformance test might still find that the port was
> actually bound. Other users of the kernel wouldn't get to use this
> sysctl, and the userspace code can't be easily reused in other
> open-source projects, so the community gets nothing useful. That
> doesn't seem great.

The same argument can be made about kernel changes that are only
needed by Android because they refuse to use a userspace solution that
frankly can do the job.

Can you see why these Android special case discussions are so
frustrating for kernel devs?

And using the "we'll just have a local kernel change in the Android
kernel" threat as leverage in the discussion... yeah very unpleasant
indeed.
