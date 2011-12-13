From: Xi Wang <xi.wang@gmail.com>
Date: Tue, 13 Dec 2011 22:00:27 +0000
Subject: Re: [PATCH RESEND] sctp: fix incorrect overflow check on autoclose
Message-Id: <702540E4-9FD3-4B71-B53A-FE5D4323A898@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323393883-3759-1-git-send-email-xi.wang@gmail.com> <4EE2478B.5010409@hp.com> <8EEC521A-CA38-4CE9-BCFD-BA6FC9A85D18@gmail.com> <4EE67DC6.3000500@hp.com>
In-Reply-To: <4EE67DC6.3000500@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>, "David S. Miller" <davem@davemloft.net>

On Dec 12, 2011, at 5:18 PM, Vladislav Yasevich wrote:
> Hm..  this is a bit strange.  This makes it so that on 32 bit platforms
> we have one upper bound for autoclose and on 64 we have another even though
> the type is platform dependent.  This could be considered a regression by
> applications.

Either looks good to me.  Timeout limit is essentially different on 32/64
platforms.

Another (probably uglier) option is to limit the value on 32-bit platform
only, like sock_setsockopt() in net/core/sock.c.

#if (BITS_PER_LONG = 32)
	if (sp->autoclose > MAX_SCHEDULE_TIMEOUT / HZ)
		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ;
#endif

> In addition this would result in confusion to user since the values
> between setsockopt() and getsockopt() for autoclose would be different.

Are you suggesting to reject the value and return -EINVAL, rather than
silently limiting the autoclose value?

- xi
