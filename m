From: Xi Wang <xi.wang@gmail.com>
Date: Thu, 15 Dec 2011 22:13:28 +0000
Subject: Re: [PATCH v2] sctp: fix incorrect overflow check on autoclose
Message-Id: <0BF79838-C86F-4C3F-8D51-4223D579764C@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323393883-3759-1-git-send-email-xi.wang@gmail.com> <4EE919B5.3090901@gmail.com> <4EEA6176.9020704@hp.com>
In-Reply-To: <4EEA6176.9020704@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>, "David S. Miller" <davem@davemloft.net>

On Dec 15, 2011, at 4:07 PM, Vlad Yasevich wrote:
> I think it would be better to keep this value in seconds and get rid
> of division in the setsockopt code.  We could then have a min and max
> values where max value could be something like 2 days.  I really don't
> see an autoclose value that is bigger then that being very useful.  In
> fact, most of the time these values are very small as one wants to close
> out idle associations.

Now I start to think exposing a new sysctl option might be a little
overkill since autoclose is often small.

How about this?

1) Simply store autoclose in seconds in setsockopt.

2) Avoid overflow in associola.c.

	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] 		(sp->autoclose > MAX_SCHEDULE_TIMEOUT / HZ)
		? MAX_SCHEDULE_TIMEOUT
		: (unsigned long)sp->autoclose * HZ;

Or we could use INT_MAX instead of MAX_SCHEDULE_TIMEOUT if you want to
keep that value consistent across 32/64 bits.

- xi
