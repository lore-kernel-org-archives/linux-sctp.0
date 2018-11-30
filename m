From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 30 Nov 2018 14:18:52 +0000
Subject: Re: [PATCHv2 net] sctp: hold transport before accessing its asoc in sctp_epaddr_lookup_transport
Message-Id: <20181130141852.GS30481@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
 <20181129205144.GC14550@hmswarspite.think-freely.org>
 <CADvbK_dYtWeftJEkL-acWqts+0V47bMJeMi4iY0Vq0rJyMSjYQ@mail.gmail.com>
 <20181130123236.GB24285@hmswarspite.think-freely.org>
 <20181130133315.GR30481@localhost.localdomain>
 <20181130140506.GE24285@hmswarspite.think-freely.org>
In-Reply-To: <20181130140506.GE24285@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>

On Fri, Nov 30, 2018 at 09:05:06AM -0500, Neil Horman wrote:
> On Fri, Nov 30, 2018 at 11:33:15AM -0200, Marcelo Ricardo Leitner wrote:
> > On Fri, Nov 30, 2018 at 07:32:36AM -0500, Neil Horman wrote:
> > > On Fri, Nov 30, 2018 at 02:04:16PM +0900, Xin Long wrote:
> > > > On Fri, Nov 30, 2018 at 5:52 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > >
> > > > > On Thu, Nov 29, 2018 at 02:44:07PM +0800, Xin Long wrote:
> > > > > > Without holding transport to dereference its asoc, a use after
> > > > > > free panic can be caused in sctp_epaddr_lookup_transport. Note
> > > > > > that a sock lock can't protect these transports that belong to
> > > > > > other socks.
> > > > > >
> > > > > > A similar fix as Commit bab1be79a516 ("sctp: hold transport
> > > > > > before accessing its asoc in sctp_transport_get_next") is
> > > > > > needed to hold the transport before accessing its asoc in
> > > > > > sctp_epaddr_lookup_transport.
> > > > > >
> > > > > > Note that this extra atomic operation is on the datapath,
> > > > > > but as rhlist keeps the lists to a small size, it won't
> > > > > > see a noticeable performance hurt.
> > > > > >
> > > > > > v1->v2:
> > > > > >   - improve the changelog.
> > > > > >
> > > > > > Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> > > > > > Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > ---
> > > > > >  net/sctp/input.c | 10 ++++++++--
> > > > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > > > > > index 5c36a99..ce7351c 100644
> > > > > > --- a/net/sctp/input.c
> > > > > > +++ b/net/sctp/input.c
> > > > > > @@ -967,9 +967,15 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
> > > > > >       list = rhltable_lookup(&sctp_transport_hashtable, &arg,
> > > > > >                              sctp_hash_params);
> > > > > >
> > > > > > -     rhl_for_each_entry_rcu(t, tmp, list, node)
> > > > > > -             if (ep = t->asoc->ep)
> > > > > > +     rhl_for_each_entry_rcu(t, tmp, list, node) {
> > > > > > +             if (!sctp_transport_hold(t))
> > > > > > +                     continue;
> > > > > > +             if (ep = t->asoc->ep) {
> > > > > > +                     sctp_transport_put(t);
> > > > > >                       return t;
> > > > > > +             }
> > > > > > +             sctp_transport_put(t);
> > > > > > +     }
> > > > > >
> > > > > >       return NULL;
> > > > > >  }
> > > > >
> > > > > Wait a second, what if we just added an rcu_head to the association structure
> > > > > and changed the kfree call in sctp_association_destroy to a kfree_rcu call
> > > > > instead?  That would force the actual freeing of the association to pass through
> > > > > a grace period, during which any in flight list traversal in
> > > > > sctp_epaddr_lookup_transport could complete safely.  Its another two pointers
> > > > We discussed this in last thread:
> > > > https://www.spinics.net/lists/netdev/msg535191.html
> > > > 
> > > > It will cause closed sk to linger longer.
> > > > 
> > > Yes, but we never really got resolution on that topic.  I don't see that a
> > 
> > Fair point. We should have brought back the discussion online.
> > 
> > > socket lingering for an extra grace period is that big a deal.  I also don't see
> > 
> > What we really don't want is to bring back
> > 8c98653f0553 ("sctp: sctp_close: fix release of bindings for deferred call_rcu's").
> > (more below). That's where our fear lies.
> > 
> > > how sending the actual kfree through a grace period is going to cause the socket
> > > to linger.  If you look at sctp_association_destroy, we call sock_put prior to
> > > calling kfree at the end of the function.  All I'm looking for here is for the
> > > memory free to wait until any list traversal in sctp_epaddr_lookup_transport is
> > > done, which is what you are trying to do with your atomics.
> > > 
> > > As for your comment regarding sctp_transport_destroy_rcu, yes, that forces a
> > > grace period when a transport is being destroyed, which will protect against
> > > list corruption of the transport list here.  Thats good, but isn't what you are
> > > trying to fix.  Your initial claim was that the asoc pointer for a given
> > > transport was no longer valid, because it was getting freed while the transport
> > > was still on the list.  That can clearly happen as we release all the transports
> > > in sctp_association_free prior to calling what ostensibly is the last refrence
> > > to their parent association at the end of that function, but its only the
> > > transports that pass through a grace period before getting freed, the
> > > association happens synchrnously, ignoring any grace period, and thats what we
> > > need to change.
> > > 
> > > The more I look at it the more I'm convinced. What you're doing here is
> > > definately overkill.  You need to add an rcu_head to the association and just do
> > > the kfree of its memory after a grace period.  Its actually only a single grace
> > > period as well.  If someone is traversing the transport list, both the transport
> > > and association rcu callbacks will get run once the rcu_read_lock is released.
> > 
> > Ok, delaying *just* the kfree works too. It wouldn't bring back the
> > issue I mentioned above.
> > 
> > We have basically 3 options then:
> > 
> > 1) your proposal above
> >    extends sctp_association by rcu_head
> >    delays the assoc kfree by a grace period, but just the kfree
> > 2) the atomics, patch above
> >    no struct growth
> >    datapath atomics, but with no measurable impacts (kudos to rhlist)
> > 3) cache ep pointer in sctp_transport
> >    extends sctp_transport by a pointer
> >    avoids double deref (t->asoc->ep)
> >    this should work because we are only comparing ep pointers in
> >      there and not using it after that.
> >    might be tricky considering peeloff operation, but shouldn't be
> >      much different from what we already have today with the asoc
> >      migration itself.
> > 
> > Considering 2 is a no go, we have the other 2 options. Between 1 and
> > 3, WDYT?
> > 
> I think that option (1) is the correct philisophical approach.  If we have
> pointers that are accessed with the expectation of safety from rcu traversal, we
> should bind the addition and removal of those data structures to rcu semantics.
> Given that we are using rcu list traversal to walk through the transport list,
> it seems to me we are implying rcu semantics.

rcu doesn't have to be like a plague that spreads around, but I guess
I see your point.

> 
> That said, Option 3 works too, and might offer superior performance (in fact it
> likely will), but I don't like the idea of caching the ep pointer.  We would be
> doing so as much for safety as for performance, and I would be concerned that
> caching that pointer opens up the possibility of likely bugs down the road (such
> a cached pointer could only be used for comparison, and not for derefence, which
> is wierd to say the least).

Good point, agree.

> 
> I would vote for option 1

Xin?

  Marcelo

> 
> Neil
> 
> > > 
> > > 
> > > Nak to this patch
> > > Neil
> > > 
> > > > > worth of space in the association, but I think that would be a worthwhile
> > > > > tradeoff for not having to do N atomic adds/puts every time you wanted to
> > > > > receive or send a frame.
> > > > N is not a big value, as rhlist itself keeps lists in a size.
> > > > 
> > > > >
> > > > > Neil
> > > > >
> > > > > > --
> > > > > > 2.1.0
> > > > > >
> > > > > >
> > > > 
> > 
