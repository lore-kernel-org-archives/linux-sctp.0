From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 03 Sep 2018 13:03:22 +0000
Subject: Re: [PATCH net] sctp: hold transport before accessing its asoc in sctp_transport_get_next
Message-Id: <20180903130322.GA31019@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <607dd2950d09fc83404d670a73099523087d4963.1535366311.git.lucien.xin@gmail.com>
 <20180827130803.GA12418@hmswarspite.think-freely.org>
 <CADvbK_f7+UqMqm-ZzEwSz92Joxx_46a1kBrwNbpAi52Qkk=FuQ@mail.gmail.com>
 <20180829113532.GA21923@hmswarspite.think-freely.org>
 <CADvbK_dnuFTbF7xwHS=ZtywPpuC08X13goA26C5qqhOnrFwSLA@mail.gmail.com>
 <20180831120323.GA2960@hmswarspite.think-freely.org>
In-Reply-To: <20180831120323.GA2960@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Fri, Aug 31, 2018 at 08:03:23AM -0400, Neil Horman wrote:
> On Fri, Aug 31, 2018 at 03:09:05PM +0800, Xin Long wrote:
> > On Wed, Aug 29, 2018 at 7:36 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Wed, Aug 29, 2018 at 12:08:40AM +0800, Xin Long wrote:
> > > > On Mon, Aug 27, 2018 at 9:08 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > >
> > > > > On Mon, Aug 27, 2018 at 06:38:31PM +0800, Xin Long wrote:
> > > > > > As Marcelo noticed, in sctp_transport_get_next, it is iterating over
> > > > > > transports but then also accessing the association directly, without
> > > > > > checking any refcnts before that, which can cause an use-after-free
> > > > > > Read.
> > > > > >
> > > > > > So fix it by holding transport before accessing the association. With
> > > > > > that, sctp_transport_hold calls can be removed in the later places.
> > > > > >
> > > > > > Fixes: 626d16f50f39 ("sctp: export some apis or variables for sctp_diag and reuse some for proc")
> > > > > > Reported-by: syzbot+fe62a0c9aa6a85c6de16@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > ---
> > > > > >  net/sctp/proc.c   |  4 ----
> > > > > >  net/sctp/socket.c | 22 +++++++++++++++-------
> > > > > >  2 files changed, 15 insertions(+), 11 deletions(-)
> > > > > >
> > > > > > diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> > > > > > index ef5c9a8..4d6f1c8 100644
> > > > > > --- a/net/sctp/proc.c
> > > > > > +++ b/net/sctp/proc.c
> > > > > > @@ -264,8 +264,6 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
> > > > > >       }
> > > > > >
> > > > > >       transport = (struct sctp_transport *)v;
> > > > > > -     if (!sctp_transport_hold(transport))
> > > > > > -             return 0;
> > > > > >       assoc = transport->asoc;
> > > > > >       epb = &assoc->base;
> > > > > >       sk = epb->sk;
> > > > > > @@ -322,8 +320,6 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
> > > > > >       }
> > > > > >
> > > > > >       transport = (struct sctp_transport *)v;
> > > > > > -     if (!sctp_transport_hold(transport))
> > > > > > -             return 0;
> > > > > >       assoc = transport->asoc;
> > > > > >
> > > > > >       list_for_each_entry_rcu(tsp, &assoc->peer.transport_addr_list,
> > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > index e96b15a..aa76586 100644
> > > > > > --- a/net/sctp/socket.c
> > > > > > +++ b/net/sctp/socket.c
> > > > > > @@ -5005,9 +5005,14 @@ struct sctp_transport *sctp_transport_get_next(struct net *net,
> > > > > >                       break;
> > > > > >               }
> > > > > >
> > > > > > +             if (!sctp_transport_hold(t))
> > > > > > +                     continue;
> > > > > > +
> > > > > >               if (net_eq(sock_net(t->asoc->base.sk), net) &&
> > > > > >                   t->asoc->peer.primary_path = t)
> > > > > >                       break;
> > > > > > +
> > > > > > +             sctp_transport_put(t);
> > > > > >       }
> > > > > >
> > > > > >       return t;
> > > > > > @@ -5017,13 +5022,18 @@ struct sctp_transport *sctp_transport_get_idx(struct net *net,
> > > > > >                                             struct rhashtable_iter *iter,
> > > > > >                                             int pos)
> > > > > >  {
> > > > > > -     void *obj = SEQ_START_TOKEN;
> > > > > > +     struct sctp_transport *t;
> > > > > >
> > > > > > -     while (pos && (obj = sctp_transport_get_next(net, iter)) &&
> > > > > > -            !IS_ERR(obj))
> > > > > > -             pos--;
> > > > > > +     if (!pos)
> > > > > > +             return SEQ_START_TOKEN;
> > > > > >
> > > > > > -     return obj;
> > > > > > +     while ((t = sctp_transport_get_next(net, iter)) && !IS_ERR(t)) {
> > > > > > +             if (!--pos)
> > > > > > +                     break;
> > > > > > +             sctp_transport_put(t);
> > > > > > +     }
> > > > > > +
> > > > > > +     return t;
> > > > > >  }
> > > > > >
> > > > > >  int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
> > > > > > @@ -5082,8 +5092,6 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
> > > > > >
> > > > > >       tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
> > > > > >       for (; !IS_ERR_OR_NULL(tsp); tsp = sctp_transport_get_next(net, &hti)) {
> > > > > > -             if (!sctp_transport_hold(tsp))
> > > > > > -                     continue;
> > > > > >               ret = cb(tsp, p);
> > > > > >               if (ret)
> > > > > >                       break;
> > > > > > --
> > > > > > 2.1.0
> > > > > >
> > > > > >
> > > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > > >
> > > > > Additionally, its not germaine to this particular fix, but why are we still
> > > > > using that pos variable in sctp_transport_get_idx?  With the conversion to
> > > > > rhashtables, it doesn't seem particularly useful anymore.
> > > > For proc, seems so, hti is saved into seq->private.
> > > > But for diag, "hti" in sctp_for_each_transport() is a local variable.
> > > > do you think where we can save it?
> > > >
> > > Sorry, wasn't suggesting that it had to be removed from sctp_for_each_trasnport,
> > > its clearly used as both an input and output there.  All I was sugesting was
> > > that, in sctp_transport_get_idx, the pos variable might no longer be needed
> > > there specifically, as sctp_transprt_get_next should terminate the loop on its
> > > own.  Or is there another purpose for that positional variable I am missing
> > Yes, Neil, all transports/asocs could not be dumped once as one buffer/rtnl msg
> > is not big enough for them. when coming into proc/diag again, it needs to start
> > from the *next* one, and 'pos' is used to save its position.
> > 
> > Without 'pos', it would always start from the first one and dump the duplicate
> > ones in the next times. Make sense?
> > 
> You're missing what I'm trying to say.  I'm speaking specifically about
> sctp_transport_get_idx here.  In that function, pos is passed by value, and has
> no bearing on if sctp_transport_get_idx starts at the beginning of the list, or
> not, thats in control of the iterator entirely here. If we remove pos from the
> parameter list, at worst, the iterator continues until the end of the list,
> which I think is fine.
> 
> No?
> Neil
> 

Sorry, slight correction here, I see what you were trying to say.  You're saying
that the one user of sctp_for_each_transport (sctp_diag_dump), uses the pos
variable to start at a point other than the head of the list, because the
netlink protocol that uses that allows you to index into it that way.  Sorry
about that.

That said, thats....odd.  Its certainly no in keeping with the other _for_each
methods the kernel has.  The for_each construct typically iterates over the
entire list regardless, and leaves filtering up to the caller.  I'd suggest we
do the same, by not requireing a positional argument, and instead checking that
positional argument in the callback.  I'll write a patch for it this week

Neil

> > >
> > > Neil
> > >
> > 
> 
