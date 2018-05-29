From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 29 May 2018 15:45:14 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <20180529154514.GC3788@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
 <20180525191319.GB392@hmswarspite.think-freely.org>
 <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <20180527010059.GA15798@neilslaptop.think-freely.org>
 <20180528194315.GB3788@localhost.localdomain>
 <20180529114111.GA24144@hmswarspite.think-freely.org>
 <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
In-Reply-To: <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <michael.tuexen@lurchi.franken.de>
Cc: Neil Horman <nhorman@tuxdriver.com>, Dmitry Vyukov <dvyukov@google.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, syzkaller <syzkaller@googlegroups.com>

On Tue, May 29, 2018 at 03:06:06PM +0200, Michael Tuexen wrote:
> > On 29. May 2018, at 13:41, Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > On Mon, May 28, 2018 at 04:43:15PM -0300, Marcelo Ricardo Leitner wrote:
> >> On Sat, May 26, 2018 at 09:01:00PM -0400, Neil Horman wrote:
> >>> On Sat, May 26, 2018 at 05:50:39PM +0200, Dmitry Vyukov wrote:
> >>>> On Sat, May 26, 2018 at 5:42 PM, Michael Tuexen
> >>>> <michael.tuexen@lurchi.franken.de> wrote:
> >>>>>> On 25. May 2018, at 21:13, Neil Horman <nhorman@tuxdriver.com> wrote:
> >>>>>> 
> >>>>>> On Sat, May 26, 2018 at 01:41:02AM +0800, Xin Long wrote:
> >>>>>>> syzbot reported a rcu_sched self-detected stall on CPU which is caused
> >>>>>>> by too small value set on rto_min with SCTP_RTOINFO sockopt. With this
> >>>>>>> value, hb_timer will get stuck there, as in its timer handler it starts
> >>>>>>> this timer again with this value, then goes to the timer handler again.
> >>>>>>> 
> >>>>>>> This problem is there since very beginning, and thanks to Eric for the
> >>>>>>> reproducer shared from a syzbot mail.
> >>>>>>> 
> >>>>>>> This patch fixes it by not allowing to set rto_min with a value below
> >>>>>>> 200 msecs, which is based on TCP's, by either setsockopt or sysctl.
> >>>>>>> 
> >>>>>>> Reported-by: syzbot+3dcd59a1f907245f891f@syzkaller.appspotmail.com
> >>>>>>> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >>>>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>>>>>> ---
> >>>>>>> include/net/sctp/constants.h |  1 +
> >>>>>>> net/sctp/socket.c            | 10 +++++++---
> >>>>>>> net/sctp/sysctl.c            |  3 ++-
> >>>>>>> 3 files changed, 10 insertions(+), 4 deletions(-)
> >>>>>>> 
> >>>>>>> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> >>>>>>> index 20ff237..2ee7a7b 100644
> >>>>>>> --- a/include/net/sctp/constants.h
> >>>>>>> +++ b/include/net/sctp/constants.h
> >>>>>>> @@ -277,6 +277,7 @@ enum { SCTP_MAX_GABS = 16 };
> >>>>>>> #define SCTP_RTO_INITIAL     (3 * 1000)
> >>>>>>> #define SCTP_RTO_MIN         (1 * 1000)
> >>>>>>> #define SCTP_RTO_MAX         (60 * 1000)
> >>>>>>> +#define SCTP_RTO_HARD_MIN   200
> >>>>>>> 
> >>>>>>> #define SCTP_RTO_ALPHA          3   /* 1/8 when converted to right shifts. */
> >>>>>>> #define SCTP_RTO_BETA           2   /* 1/4 when converted to right shifts. */
> >>>>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >>>>>>> index ae7e7c6..6ef12c7 100644
> >>>>>>> --- a/net/sctp/socket.c
> >>>>>>> +++ b/net/sctp/socket.c
> >>>>>>> @@ -3029,7 +3029,8 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
> >>>>>>> * be changed.
> >>>>>>> *
> >>>>>>> */
> >>>>>>> -static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
> >>>>>>> +static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval,
> >>>>>>> +                               unsigned int optlen)
> >>>>>>> {
> >>>>>>>     struct sctp_rtoinfo rtoinfo;
> >>>>>>>     struct sctp_association *asoc;
> >>>>>>> @@ -3056,10 +3057,13 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
> >>>>>>>     else
> >>>>>>>             rto_max = asoc ? asoc->rto_max : sp->rtoinfo.srto_max;
> >>>>>>> 
> >>>>>>> -    if (rto_min)
> >>>>>>> +    if (rto_min) {
> >>>>>>> +            if (rto_min < SCTP_RTO_HARD_MIN)
> >>>>>>> +                    return -EINVAL;
> >>>>>>>             rto_min = asoc ? msecs_to_jiffies(rto_min) : rto_min;
> >>>>>>> -    else
> >>>>>>> +    } else {
> >>>>>>>             rto_min = asoc ? asoc->rto_min : sp->rtoinfo.srto_min;
> >>>>>>> +    }
> >>>>>>> 
> >>>>>>>     if (rto_min > rto_max)
> >>>>>>>             return -EINVAL;
> >>>>>>> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> >>>>>>> index 33ca5b7..7ec854a 100644
> >>>>>>> --- a/net/sctp/sysctl.c
> >>>>>>> +++ b/net/sctp/sysctl.c
> >>>>>>> @@ -52,6 +52,7 @@ static int rto_alpha_min = 0;
> >>>>>>> static int rto_beta_min = 0;
> >>>>>>> static int rto_alpha_max = 1000;
> >>>>>>> static int rto_beta_max = 1000;
> >>>>>>> +static int rto_hard_min = SCTP_RTO_HARD_MIN;
> >>>>>>> 
> >>>>>>> static unsigned long max_autoclose_min = 0;
> >>>>>>> static unsigned long max_autoclose_max > >>>>>>> @@ -116,7 +117,7 @@ static struct ctl_table sctp_net_table[] = {
> >>>>>>>             .maxlen         = sizeof(unsigned int),
> >>>>>>>             .mode           = 0644,
> >>>>>>>             .proc_handler   = proc_sctp_do_rto_min,
> >>>>>>> -            .extra1         = &one,
> >>>>>>> +            .extra1         = &rto_hard_min,
> >>>>>>>             .extra2         = &init_net.sctp.rto_max
> >>>>>>>     },
> >>>>>>>     {
> >>>>>>> --
> >>>>>>> 2.1.0
> >>>>>>> 
> >>>>>>> --
> >>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>>> 
> >>>>>> Patch looks fine, you probably want to note this hard minimum in man(7) sctp as
> >>>>>> well
> >>>>>> 
> >>>>> I'm aware of some signalling networks which use RTO.min of smaller values than 200ms.
> >>>>> So could this be reduced?
> >>>> 
> >>>> Hi Michael,
> >>>> 
> >>>> What value do they use?
> >>>> 
> >>>> Xin, Neil, is there more principled way of ensuring that a timer won't
> >>>> cause a hard CPU stall? There are slow machines and there are slow
> >>>> kernels (in particular syzbot kernel has tons of debug configs
> >>>> enabled). 200ms _should_ not cause problems because we did not see
> >>>> them with tcp. But it's hard to say what's the low limit as we are
> >>>> trying to put a hard upper bound on execution time of a complex
> >>>> section of code. Is there something like cond_resched for timers?
> >>> Unfortunately, Theres not really a way to do conditional rescheduling of timers,
> >>> additionally, we have a problem because the timer is reset as a side effect of
> >>> the SCTP state machine, and so the execution time between timer updates has a
> >>> signifcant amount of jitter (meaning its a pretty hard value to calibrate,
> >>> unless you just select a 'safe' large value for the floor).
> >>> 
> >>> What we might could do (though this might impact the protocol function is change
> >>> the timer update side effects to simply set a flag, and consistently update the
> >>> timers on exit from sctp_do_sm, so they don't re-arm until all state machine
> >>> processing is complete.  Anyone have any thoughts on that?
> >> 
> >> I was reviewing all this again and I'm thinking that we are missing
> >> the real point. With the parameters that reproducer [1] has, setting
> >> those very low RTO parameters, it causes the timer to actually
> >> busyloop on the heartbeats, as Xin had explained.
> >> 
> >> But thing is, it busy loops not just because RTO is too low, but
> >> because hbinterval was not accounted.
> >> 
> >> /* What is the next timeout value for this transport? */
> >> unsigned long sctp_transport_timeout(struct sctp_transport *trans)
> >> {
> >>        /* RTO + timer slack +/- 50% of RTO */
> >>        unsigned long timeout = trans->rto >> 1;  <-- [a]
> >> 
> >>        if (trans->state != SCTP_UNCONFIRMED &&
> >>            trans->state != SCTP_PF)             <--- [2]
> >>                timeout += trans->hbinterval;
> >> 
> >>        return timeout;
> >> }
> >> 
> >> The if() in [2] is to speed up path verification before using them, as
> >> per the commit changelog. Secondary paths added on processing the
> >> cookie are created with status SCTP_UNCONFIRMED, and HB timers are
> >> started in the sequence:
> >> sctp_sf_do_5_1D_ce
> >>   -> sctp_process_init
> >>     |> sctp_process_param
> >>     | -> sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED)
> >>     '> sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
> >> 
> >> which starts the timer using only the small RTO for secondary paths:
> >> static void sctp_cmd_hb_timers_start(struct sctp_cmd_seq *cmds,
> >>                                     struct sctp_association *asoc)
> >> {
> >>        struct sctp_transport *t;
> >> 
> >>        /* Start a heartbeat timer for each transport on the association.
> >>         * hold a reference on the transport to make sure none of
> >>         * the needed data structures go away.
> >>         */
> >>        list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
> >>                sctp_transport_reset_hb_timer(t);
> >> }
> >> 
> >> But if the system is too busy generating HBs, it likely won't process
> >> incoming HB ACKs, which would stop the loop as it would mark the
> >> transport as Active.
> >> 
> >> I'm now thinking a better fix would be to have a specific way to
> >> kickstart these initial heartbeets, and then always use hbinterval on
> >> subsequent ones.
> >> 
> > I like the idea, but I don't think we can just use the hbinterval to set the
> > timeout.  That said, it seems like we should always be using the HB interval,
> > not just on unconfirmed or partially failed transports.  From the RFC:
> > 
> > On an idle destination address that is allowed to heartbeat, it is
> >   recommended that a HEARTBEAT chunk is sent once per RTO of that
> >   destination address plus the protocol parameter 'HB.interval', with
> >   jittering of +/- 50% of the RTO value, and exponential backoff of the
> >   RTO if the previous HEARTBEAT is unanswered
> Aren't we talking about the path confirmation procedure?
> This is described in https://tools.ietf.org/html/rfc4960#section-5.4
> where it is stated:
> 
>    In each RTO, a probe may be sent on an active UNCONFIRMED path in an
>    attempt to move it to the CONFIRMED state.  If during this probing
>    the path becomes inactive, this rate is lowered to the normal
>    HEARTBEAT rate.  At the expiration of the RTO timer, the error
>    counter of any path that was probed but not CONFIRMED is incremented
>    by one and subjected to path failure detection, as defined in Section 8.2.
>    When probing UNCONFIRMED addresses, however, the association
>    overall error count is NOT incremented.
> 
> So during path confirmation there is no requirement to add HB.interval.

Right.

> 
> Best regards
> Michael
> > 
> > It seems like we should be adding it to the timer expiration universally.  By my
> > read, we've never done this quite right.  And yes, I agree, if we account this
> > properly, we will avoid this issue.
> > 
> > Its also probably important to note here, that, like RTO.min currently, there is
> > no hard floor to the heartbeat interval, and the RFC is silent on what it should
> > be.  So it would be possible to still find ourselves in this situation if we set
> > the interval to 0 from userspace.  Is it worth considering a floor on the
> > minimum hb interval of the rto is to have no floor?

Seems so, yes. I was discussing this with Xin Long offline and he
suggested that we can add a floor to hb timeouts (not interval) with
this:

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 47f82bd..9f66708 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -634,7 +634,7 @@ unsigned long sctp_transport_timeout(struct sctp_transport *trans)
 	    trans->state != SCTP_PF)
 		timeout += trans->hbinterval;

-	return timeout;
+	return max_t(unsigned long, timeout, HZ/5);
 }

 /* Reset transport variables to their initial values */

This avoids the issue at hand and without forcing a rto_min value.

But as you were anticipating, there are other vectors that can be
exploited to trigger something like this. The one I could think of, is
to set rto_min=1 rto_max=2 and pathmaxrxt=<large value>. This is
likely to get us into rtxing the same packet over and over based on
timer/softirq, and it doesn't even need root for that.
 
Seems a more complete fix is:
- patch1 - fix issue at hand
  - Use the max_t above
- patch2 - fix rtx attack vector
  - Add the floor value to rto_min to HZ/20 (which fits the values
    that Michael shared on the other email)
- patch3 - speed up initial HB again
  - change sctp_cmd_hb_timers_start() so hb timers are kickstarted
    when the association is established. AFAICT RFC doesn't specify
    when these initial ones should be sent, and I see no issues with
    speeding them up.

WDYT?

Michael, what is the lowest heartbeat interval you have ever seen?
Hopefully it's bigger than 200ms. :)

Best,
  Marcelo
