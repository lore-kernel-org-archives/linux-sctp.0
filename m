From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 10 Jul 2008 14:18:56 +0000
Subject: Re: SCTP memory pressure
Message-Id: <20080710141856.GC18527@hmsendeavour.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <487608FC.8020601@hp.com>
In-Reply-To: <487608FC.8020601@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 10, 2008 at 09:05:00AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
> >On Wed, Jul 09, 2008 at 04:24:47PM -0400, Vlad Yasevich wrote:
> >>Frank.Uretschlaeger@t-online.de wrote:
> >>>Sorry,
> >>>forgot to mention, the last test was done with Neils latest private SCTP
> >>>branch, which was merged with Vlads latest re-transmission fixes.
> >>>Best regards,
> >>>Frank
> >>>
> >>>
> >>Hi Frank
> >>
> >>I've been taking a very hard look at the current accounting code and we
> >>definitely don't do thinks correctly...  In fact we allow for so much 
> >>memory
> >>to be consumed that it's not surprising that we run into this problem.
> >>
> >>Currently, if you do not set the SO_RCVBUF, we will allow you to consume
> >>sk_rcvbuf + sctp_mem[1] memory which is just a total overkill.  If you
> >>have a lot of sockets, which I think you do based on what I remember,
> >>each socket can consume it's full receive buffer without triggering
> >>any memory pressure.  Only once the all of the receive buffer is consumed,
> >>will we start counting memory allocations towards the memory pressure 
> >>condition.
> >>
> >
> >This isn't quite correct, we use the sk_wmem_schedule api to do our memory
> >accounting, which accounts memory on a semi global basis.  The sctp_mem 
> >array is
> >compared to the total amount of allocated memory for all sctp sockets (see
> >__sk_mem_schedule, where all this math happens).  So we enter memory 
> >pressure as
> >soon as all the sctp sockets in aggregate allocate more than 
> >sysctl_sctp_mem[1]
> >bytes.
> 
> Well,  yes what I said isn't quite correct for the case of a ton of 
> sockets, but
> it is still correct for as single socket case.
> 
> Looking at what's currently in the mainline, we do not call 
> sk_rmem_schedule()
> until after we've exceeded our receive buffer.
> 
>         if (rx_count >= asoc->base.sk->sk_rcvbuf) {
> 
>                 if ((asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK) ||
>                     (!sk_rmem_schedule(asoc->base.sk, 
>                     chunk->skb->truesize)))
>                         goto fail;
>         }
> 
> This means, that while we are below sk_recbuf, we do not account our memory
> allocations against prot->memory_allocated (which is the total allocations 
> against SCTP memory pool).  We only start counting once we exceed the 
> default
> receive buffer.
> 
Ouch, you're right, that should be done every time.  Thank you for the
clarification.

> So, for a single socket case, we can allocate sk_recvbuf + sctp_mem[1] and
> only then do we enter memory pressure.
> 
Yeah, we should schedule every allocation.

> For the case of multiple socket, every socket is allowed to fully consume
> there specified sk_rcvbuf and none of those allocations count against
> prot->memory_allocated.
> 
> So, in Frank's case, he could conceivably create 10000 sockets and would 
> allocate 10000 * rmem_default without triggering memory pressure conditions
> because we would never call sk_rmem_schedule.
> 
Yeah, badness ensues.  I'll fix that in my branch and see how it goes.

> >
> >That being said, I agree that we're clearly using too much memory in Franks
> >environment.  The fixes in my branch that Frank has been using addresses 
> >several
> >points at which we fail to use the sk_*_schedule api.  I'm sure there are 
> >more
> >that I'm missing, and additionally there are other things that we can 
> >likely do
> >to conserve memory when we enter pressure.
> >
> >>I am trying to see what we can do.  Still need to find time to look at 
> >>Neil's changes.
> >>
> >Looking forward to your thoughts.  Not sure if its ready for inclusion 
> >yet, but
> >I think at least some bits are correct.  Let me know what you think!
> >
> 
> Right now, I've changed the above quoted code to do this:
> 
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -687,6 +687,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct 
> sctp_association *asoc,
>         struct sk_buff *skb;
>         size_t padding, len;
>         int rx_count;
> +       int have_mem;
> 
>         /*
>          * check to see if we need to make space for this
> @@ -698,10 +699,15 @@ struct sctp_ulpevent 
> *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
>         else
>                 rx_count = atomic_read(&asoc->base.sk->sk_rmem_alloc);
> 
> -       if (rx_count >= asoc->base.sk->sk_rcvbuf) {
> -
> -               if ((asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK) ||
> -                   (!sk_rmem_schedule(asoc->base.sk, 
> chunk->skb->truesize)))
> +       have_mem = sk_rmem_schedule(asoc->base.sk, chunk->skb->truesize);
> +       if (rx_count >= asoc->base.sk->sk_rcvbuf || !have_mem) {
> +               /* if we are still allowed to make allocations
> +                * see if we can adjust the receive buffer.
> +                */
> +               if (have_mem) {
> +                       if (!sctp_recvbuf_adjust())
> +                               goto fail;
> +               } else
>                         goto fail;
>         }
> 
> It's still a work in progress...
> 
> The idea is that if sk_rmem_schedule tells us that we still have memory to 
> allocated, go ahead and allow allocations.  However, if sk_rmem_shedule 
> tells
> us no, even if we have not consumed all of our receive buffer, we still 
> can't
> allocate requested memory.
> 
I'll add this into my branch shortly.

> Other pieces of code that would have to go in are receive buffer adjustments
> (similar to tcp_rcv_space_adjust) as well as a_rwnd manipulations to make
> sure we close the window appropriately.
> 
I still need to look at doing this.
Neil

> -vlad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
