From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 20 Dec 2013 12:29:00 +0000
Subject: Re: undetected closed apps
Message-Id: <52B4380C.9020108@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/19/13 13:16, Vlad Yasevich wrote:

>
> So, I took another look and it looks like there is an issue when the
> chunks are being abandoned in sctp_outq_flush().  We simply delete
> the chunks and it is possible that we can drain our queue without
> ever setting the empty state.  Since we didn't sent anything, we
> wouldn't get any SACKs, thus the queue would never be set as empty
> and we would be stuck in the SHUTDOWN_PENDING state, just like you
> observe.
>

Thanks Vlad.

> Can you try this patch to see if it resolves things.  Can play with
> netem values on lo to trigger PR faster.
>

Oh, I have many ways to trigger it - never thought of netem.


I will let you know how it went with the patch later today. Hoping
the linger on client side would resolve it for me so i dont depend
on a specific patch.

cheers,
jamal
