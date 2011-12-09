From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 09 Dec 2011 18:04:34 +0000
Subject: Re: [PATCH RESEND] sctp: fix incorrect overflow check on autoclose
Message-Id: <8EEC521A-CA38-4CE9-BCFD-BA6FC9A85D18@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323393883-3759-1-git-send-email-xi.wang@gmail.com> <4EE2478B.5010409@hp.com>
In-Reply-To: <4EE2478B.5010409@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrei Pelinescu-Onciul <andrei@iptel.org>, "David S. Miller" <davem@davemloft.net>

On Dec 9, 2011, at 12:38 PM, Vladislav Yasevich wrote:
> I think this should be u32 since that's what sp->autoclose is.

Do you mean something like this?

	min_t(u32, sp->autoclose, MAX_SCHEDULE_TIMEOUT / HZ)

On 64-bit platform this would limit autoclose for no good
reason to

	(u32)(MAX_SCHEDULE_TIMEOUT / HZ),

which is basically 0x978d4fdf (assuming HZ is 250).  I guess the
intention was to allow autoclose to be any u32 on 64-bit platform.

- xi
