From: Michael Tuexen <michael.tuexen@lurchi.franken.de>
Date: Tue, 29 May 2018 13:06:06 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
 <20180525191319.GB392@hmswarspite.think-freely.org>
 <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <20180527010059.GA15798@neilslaptop.think-freely.org>
 <20180528194315.GB3788@localhost.localdomain>
 <20180529114111.GA24144@hmswarspite.think-freely.org>
In-Reply-To: <20180529114111.GA24144@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, syzkaller <syzkaller@googlegroups.com>

> On 29. May 2018, at 13:41, Neil Horman <nhorman@tuxdriver.com> wrote:
>=20
> On Mon, May 28, 2018 at 04:43:15PM -0300, Marcelo Ricardo Leitner wrote:
>> On Sat, May 26, 2018 at 09:01:00PM -0400, Neil Horman wrote:
>>> On Sat, May 26, 2018 at 05:50:39PM +0200, Dmitry Vyukov wrote:
>>>> On Sat, May 26, 2018 at 5:42 PM, Michael Tuexen
>>>> <michael.tuexen@lurchi.franken.de> wrote:
>>>>>> On 25. May 2018, at 21:13, Neil Horman <nhorman@tuxdriver.com> wrote:
>>>>>>=20
>>>>>> On Sat, May 26, 2018 at 01:41:02AM +0800, Xin Long wrote:
>>>>>>> syzbot reported a rcu_sched self-detected stall on CPU which is cau=
sed
>>>>>>> by too small value set on rto_min with SCTP_RTOINFO sockopt. With t=
his
>>>>>>> value, hb_timer will get stuck there, as in its timer handler it st=
arts
>>>>>>> this timer again with this value, then goes to the timer handler ag=
ain.
>>>>>>>=20
>>>>>>> This problem is there since very beginning, and thanks to Eric for =
the
>>>>>>> reproducer shared from a syzbot mail.
>>>>>>>=20
>>>>>>> This patch fixes it by not allowing to set rto_min with a value bel=
ow
>>>>>>> 200 msecs, which is based on TCP's, by either setsockopt or sysctl.
>>>>>>>=20
>>>>>>> Reported-by: syzbot+3dcd59a1f907245f891f@syzkaller.appspotmail.com
>>>>>>> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>>>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>>>>>> ---
>>>>>>> include/net/sctp/constants.h |  1 +
>>>>>>> net/sctp/socket.c            | 10 +++++++---
>>>>>>> net/sctp/sysctl.c            |  3 ++-
>>>>>>> 3 files changed, 10 insertions(+), 4 deletions(-)
>>>>>>>=20
>>>>>>> diff --git a/include/net/sctp/constants.h b/include/net/sctp/consta=
nts.h
>>>>>>> index 20ff237..2ee7a7b 100644
>>>>>>> --- a/include/net/sctp/constants.h
>>>>>>> +++ b/include/net/sctp/constants.h
>>>>>>> @@ -277,6 +277,7 @@ enum { SCTP_MAX_GABS =3D 16 };
>>>>>>> #define SCTP_RTO_INITIAL     (3 * 1000)
>>>>>>> #define SCTP_RTO_MIN         (1 * 1000)
>>>>>>> #define SCTP_RTO_MAX         (60 * 1000)
>>>>>>> +#define SCTP_RTO_HARD_MIN   200
>>>>>>>=20
>>>>>>> #define SCTP_RTO_ALPHA          3   /* 1/8 when converted to right =
shifts. */
>>>>>>> #define SCTP_RTO_BETA           2   /* 1/4 when converted to right =
shifts. */
>>>>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>>>>>> index ae7e7c6..6ef12c7 100644
>>>>>>> --- a/net/sctp/socket.c
>>>>>>> +++ b/net/sctp/socket.c
>>>>>>> @@ -3029,7 +3029,8 @@ static int sctp_setsockopt_nodelay(struct soc=
k *sk, char __user *optval,
>>>>>>> * be changed.
>>>>>>> *
>>>>>>> */
>>>>>>> -static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *o=
ptval, unsigned int optlen)
>>>>>>> +static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *o=
ptval,
>>>>>>> +                               unsigned int optlen)
>>>>>>> {
>>>>>>>     struct sctp_rtoinfo rtoinfo;
>>>>>>>     struct sctp_association *asoc;
>>>>>>> @@ -3056,10 +3057,13 @@ static int sctp_setsockopt_rtoinfo(struct s=
ock *sk, char __user *optval, unsigne
>>>>>>>     else
>>>>>>>             rto_max =3D asoc ? asoc->rto_max : sp->rtoinfo.srto_max;
>>>>>>>=20
>>>>>>> -    if (rto_min)
>>>>>>> +    if (rto_min) {
>>>>>>> +            if (rto_min < SCTP_RTO_HARD_MIN)
>>>>>>> +                    return -EINVAL;
>>>>>>>             rto_min =3D asoc ? msecs_to_jiffies(rto_min) : rto_min;
>>>>>>> -    else
>>>>>>> +    } else {
>>>>>>>             rto_min =3D asoc ? asoc->rto_min : sp->rtoinfo.srto_min;
>>>>>>> +    }
>>>>>>>=20
>>>>>>>     if (rto_min > rto_max)
>>>>>>>             return -EINVAL;
>>>>>>> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
>>>>>>> index 33ca5b7..7ec854a 100644
>>>>>>> --- a/net/sctp/sysctl.c
>>>>>>> +++ b/net/sctp/sysctl.c
>>>>>>> @@ -52,6 +52,7 @@ static int rto_alpha_min =3D 0;
>>>>>>> static int rto_beta_min =3D 0;
>>>>>>> static int rto_alpha_max =3D 1000;
>>>>>>> static int rto_beta_max =3D 1000;
>>>>>>> +static int rto_hard_min =3D SCTP_RTO_HARD_MIN;
>>>>>>>=20
>>>>>>> static unsigned long max_autoclose_min =3D 0;
>>>>>>> static unsigned long max_autoclose_max >>>>>>> @@ -116,7 +117,7 @@ =
static struct ctl_table sctp_net_table[] =3D {
>>>>>>>             .maxlen         =3D sizeof(unsigned int),
>>>>>>>             .mode           =3D 0644,
>>>>>>>             .proc_handler   =3D proc_sctp_do_rto_min,
>>>>>>> -            .extra1         =3D &one,
>>>>>>> +            .extra1         =3D &rto_hard_min,
>>>>>>>             .extra2         =3D &init_net.sctp.rto_max
>>>>>>>     },
>>>>>>>     {
>>>>>>> --
>>>>>>> 2.1.0
>>>>>>>=20
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sct=
p" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>=20
>>>>>> Patch looks fine, you probably want to note this hard minimum in man=
(7) sctp as
>>>>>> well
>>>>>>=20
>>>>> I'm aware of some signalling networks which use RTO.min of smaller va=
lues than 200ms.
>>>>> So could this be reduced?
>>>>=20
>>>> Hi Michael,
>>>>=20
>>>> What value do they use?
>>>>=20
>>>> Xin, Neil, is there more principled way of ensuring that a timer won't
>>>> cause a hard CPU stall? There are slow machines and there are slow
>>>> kernels (in particular syzbot kernel has tons of debug configs
>>>> enabled). 200ms _should_ not cause problems because we did not see
>>>> them with tcp. But it's hard to say what's the low limit as we are
>>>> trying to put a hard upper bound on execution time of a complex
>>>> section of code. Is there something like cond_resched for timers?
>>> Unfortunately, Theres not really a way to do conditional rescheduling o=
f timers,
>>> additionally, we have a problem because the timer is reset as a side ef=
fect of
>>> the SCTP state machine, and so the execution time between timer updates=
 has a
>>> signifcant amount of jitter (meaning its a pretty hard value to calibra=
te,
>>> unless you just select a 'safe' large value for the floor).
>>>=20
>>> What we might could do (though this might impact the protocol function =
is change
>>> the timer update side effects to simply set a flag, and consistently up=
date the
>>> timers on exit from sctp_do_sm, so they don't re-arm until all state ma=
chine
>>> processing is complete.  Anyone have any thoughts on that?
>>=20
>> I was reviewing all this again and I'm thinking that we are missing
>> the real point. With the parameters that reproducer [1] has, setting
>> those very low RTO parameters, it causes the timer to actually
>> busyloop on the heartbeats, as Xin had explained.
>>=20
>> But thing is, it busy loops not just because RTO is too low, but
>> because hbinterval was not accounted.
>>=20
>> /* What is the next timeout value for this transport? */
>> unsigned long sctp_transport_timeout(struct sctp_transport *trans)
>> {
>>        /* RTO + timer slack +/- 50% of RTO */
>>        unsigned long timeout =3D trans->rto >> 1;  <-- [a]
>>=20
>>        if (trans->state !=3D SCTP_UNCONFIRMED &&
>>            trans->state !=3D SCTP_PF)             <--- [2]
>>                timeout +=3D trans->hbinterval;
>>=20
>>        return timeout;
>> }
>>=20
>> The if() in [2] is to speed up path verification before using them, as
>> per the commit changelog. Secondary paths added on processing the
>> cookie are created with status SCTP_UNCONFIRMED, and HB timers are
>> started in the sequence:
>> sctp_sf_do_5_1D_ce
>>   -> sctp_process_init
>>     |> sctp_process_param
>>     | -> sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED)
>>     '> sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMERS_START, SCTP_NULL());
>>=20
>> which starts the timer using only the small RTO for secondary paths:
>> static void sctp_cmd_hb_timers_start(struct sctp_cmd_seq *cmds,
>>                                     struct sctp_association *asoc)
>> {
>>        struct sctp_transport *t;
>>=20
>>        /* Start a heartbeat timer for each transport on the association.
>>         * hold a reference on the transport to make sure none of
>>         * the needed data structures go away.
>>         */
>>        list_for_each_entry(t, &asoc->peer.transport_addr_list, transport=
s)
>>                sctp_transport_reset_hb_timer(t);
>> }
>>=20
>> But if the system is too busy generating HBs, it likely won't process
>> incoming HB ACKs, which would stop the loop as it would mark the
>> transport as Active.
>>=20
>> I'm now thinking a better fix would be to have a specific way to
>> kickstart these initial heartbeets, and then always use hbinterval on
>> subsequent ones.
>>=20
> I like the idea, but I don't think we can just use the hbinterval to set =
the
> timeout.  That said, it seems like we should always be using the HB inter=
val,
> not just on unconfirmed or partially failed transports.  From the RFC:
>=20
> On an idle destination address that is allowed to heartbeat, it is
>   recommended that a HEARTBEAT chunk is sent once per RTO of that
>   destination address plus the protocol parameter 'HB.interval', with
>   jittering of +/- 50% of the RTO value, and exponential backoff of the
>   RTO if the previous HEARTBEAT is unanswered
Aren't we talking about the path confirmation procedure?
This is described in https://tools.ietf.org/html/rfc4960#section-5.4
where it is stated:

   In each RTO, a probe may be sent on an active UNCONFIRMED path in an
   attempt to move it to the CONFIRMED state.  If during this probing
   the path becomes inactive, this rate is lowered to the normal
   HEARTBEAT rate.  At the expiration of the RTO timer, the error
   counter of any path that was probed but not CONFIRMED is incremented
   by one and subjected to path failure detection, as defined in Section 8.=
2.
   When probing UNCONFIRMED addresses, however, the association
   overall error count is NOT incremented.

So during path confirmation there is no requirement to add HB.interval.

Best regards
Michael
>=20
> It seems like we should be adding it to the timer expiration universally.=
  By my
> read, we've never done this quite right.  And yes, I agree, if we account=
 this
> properly, we will avoid this issue.
>=20
> Its also probably important to note here, that, like RTO.min currently, t=
here is
> no hard floor to the heartbeat interval, and the RFC is silent on what it=
 should
> be.  So it would be possible to still find ourselves in this situation if=
 we set
> the interval to 0 from userspace.  Is it worth considering a floor on the
> minimum hb interval of the rto is to have no floor?
>=20
> Neil
>=20
>=20
>> This would not only fix the issue, but also improve the time we need
>> to identify the transports as Active upon association start, which is
>> currently RTO/2 (equals to 500ms by default).
>>=20
>> While working on this, I got myself wondering how HZ can affect the
>> stack with such small RTO. If we have HZ%0, for example, we probably
>> should be careful when doing calcs such as in mark [a] to not let it
>> tend to 0. This should not be related to the reported issue as
>> syzkaller was using HZ=1000.
>>=20
>> (I didn't do any tests, this is only based on code review so far)
>>=20
>> 1. https://syzkaller.appspot.com/x/repro.syz?x=1079cf8f800000
>> 2. ad8fec1720e0 ("[SCTP]: Verify all the paths to a peer via heartbeat b=
efore using them.")
>> b. https://syzkaller.appspot.com/x/.config?x=F3b4e30da84ec1ed
>>=20

