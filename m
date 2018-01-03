From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 03 Jan 2018 15:31:17 +0000
Subject: Re: [PATCH net] sctp: fix handling of ICMP Frag Needed for too small MTUs
Message-Id: <CADvbK_fEziqWGay51uTsnB6PLNbO+qguzDO28WN2_t-3thSHBg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <bc48ba9bc70796eb309a28b83f7fcf986ad13211.1514928667.git.marcelo.leitner@gmail.com>
 <CADvbK_cCftba3-O+Hub29sx6K8jWsvROhMiRLgdHg9tYi6wskg@mail.gmail.com> <20180103133513.GA727@localhost.localdomain>
In-Reply-To: <20180103133513.GA727@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Wed, Jan 3, 2018 at 9:35 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Wed, Jan 03, 2018 at 03:31:00PM +0800, Xin Long wrote:
>> On Wed, Jan 3, 2018 at 5:44 AM, Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>> > syzbot reported a hang involving SCTP, on which it kept flooding dmesg
>> > with the message:
>> > [  246.742374] sctp: sctp_transport_update_pmtu: Reported pmtu 508 too
>> > low, using default minimum of 512
>> >
>> > That happened because whenever SCTP hits an ICMP Frag Needed, it tries
>> > to adjust to the new MTU and triggers an immediate retransmission. But
>> > it didn't consider the fact that MTUs smaller than the SCTP minimum MTU
>> > allowed (512) would not cause the PMTU to change, and issued the
>> > retransmission anyway (thus leading to another ICMP Frag Needed, and so
>> > on).
>> >
>> > The fix is to disable Path MTU discovery for such transport and to skip
>> > the retransmission in such cases. By doing this, SCTP will do the
>> > backoff retransmissions as needed and will likely switch to another
>> > transport if available.
>> >
>> > See-also: https://lkml.org/lkml/2017/12/22/811
>> > Reported-by: syzbot <syzkaller@googlegroups.com>
>> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>> > ---
>> >  net/sctp/input.c     | 5 ++++-
>> >  net/sctp/transport.c | 2 ++
>> >  2 files changed, 6 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/sctp/input.c b/net/sctp/input.c
>> > index 621b5ca3fd1c17c3d7ef7bb1c7677ab98cebbe77..a24658c6f181e03d85f12dbe929c8bb4abaefcbd 100644
>> > --- a/net/sctp/input.c
>> > +++ b/net/sctp/input.c
>> > @@ -412,8 +412,11 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
>> >          * Needed will never be sent, but if a message was sent before
>> >          * PMTU discovery was disabled that was larger than the PMTU, it
>> >          * would not be fragmented, so it must be re-transmitted fragmented.
>> > +        * If the new PMTU is invalid, we will keep getting ICMP Frag
>> > +        * Needed. In this case, simply avoid the retransmit.
>> >          */
>> > -       sctp_retransmit(&asoc->outqueue, t, SCTP_RTXR_PMTUD);
>> > +       if (pmtu >= SCTP_DEFAULT_MINSEGMENT)
>> > +               sctp_retransmit(&asoc->outqueue, t, SCTP_RTXR_PMTUD);
>> >  }
>> >
>> >  void sctp_icmp_redirect(struct sock *sk, struct sctp_transport *t,
>> > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
>> > index 1e5a22430cf56e40a6f323081beb97836b506384..fbd9fe25764d4d98f93c60a48eccefd9cc6b4165 100644
>> > --- a/net/sctp/transport.c
>> > +++ b/net/sctp/transport.c
>> > @@ -259,6 +259,8 @@ void sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
>> >                  * pmtu discovery on this transport.
>> >                  */
>> >                 t->pathmtu = SCTP_DEFAULT_MINSEGMENT;
>> > +               t->param_flags = (t->param_flags & ~SPP_PMTUD) |
>> > +                                SPP_PMTUD_DISABLE;
>> It seems that once it hits here,  this transport will have the minimum pmtu
>> forever, even after t->dst has expired. It means this tx path will not come
>> back to normal any more even when it gets a needfrag with reasonable
>> pmtu.  is it too harsh to this transport ?
>
> That was the idea. That is what the comment above these lines is
> describing already. Though I missed 06ad391919b2 ("[SCTP] Don't
> disable PMTU discovery when mtu is small") and yes, too harsh.
>
>>
>> Another thing is on sctp_sendmsg, it also checks pmtu_pending that may
>> be set by needfrag, and goes to sctp_assoc_sync_pmtu to trigger this
>> warning again.
>
> That is true but that's not an issue, is it? We are not trying to get
> ride of the warning, instead we want to not cause a flood of
> bogus retransmissions (which led to the flood of warnings).
Right, I guess that the flood of warnings mostly came from that
sctp_retransmit() in sctp_icmp_frag_needed().
Otherwise, that transport should be marked as 'unreachable'
or the asoc should abort after so many times rtx.

>
> By not disabling PMTU discovery (as above) we will have such warning
> every now and then again for the same transport. We may add
> _ratelimited to it, that would help in the case of we have like a
> thousand transports suddenly being affected by such small MTU, but
> won't omit it completely.
If it can't be avoided only with the check 'pmtu >= SCTP_DEFAULT_MINSEGMENT',
yeah, _ratelimited looks good. :-)

>
> I'll spin a v2, thanks.
>
>>
>> >         } else {
>> >                 t->pathmtu = pmtu;
>> >         }
>> > --
>> > 2.14.3
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
