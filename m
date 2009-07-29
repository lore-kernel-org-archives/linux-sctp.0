From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 29 Jul 2009 18:14:30 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <4A709186.9090303@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> 
> Oh yeah, I should also mention that I still don't understand what the
> original 'asoc->a_rwnd > asoc->rwnd' condition was all about.  I replaced
> that condition with timer_pending(), but if the original condition really
> does have something to with sending window updates as you mentioned,
> it's possible that it should be left in as well.  ie:
> 
>    if ((asoc->a_rwnd > asoc->rwnd) || timer_pending(timer))
> 
> but then keep in mind that the body of that if block has been rewritten
> to assume that the timer is pending if the block is executed.  If the
> block can be entered as a result of either of these two conditions,
> that assumption may no longer be true.

I just re-read this code and it looks like it's trying to catch a condition when
a new packet was given to the socket, but the socket issued a write instead of
a read.

In this case, the timer solution would do the same thing.

During loss, there is no timer as gaps are reported immediately.  Upon loss
recovery, there is timer, but the notification shouldn't be delayed (this is a
bug) and this corrects that as well.

I'll run this through it's paces to see if anything breaks, but I think it
should be good.

-vlad

> 
> --Doug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

