From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 30 Nov 2018 12:32:36 +0000
Subject: Re: [PATCHv2 net] sctp: hold transport before accessing its asoc in sctp_epaddr_lookup_transport
Message-Id: <20181130123236.GB24285@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
 <20181129205144.GC14550@hmswarspite.think-freely.org>
 <CADvbK_dYtWeftJEkL-acWqts+0V47bMJeMi4iY0Vq0rJyMSjYQ@mail.gmail.com>
In-Reply-To: <CADvbK_dYtWeftJEkL-acWqts+0V47bMJeMi4iY0Vq0rJyMSjYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Fri, Nov 30, 2018 at 02:04:16PM +0900, Xin Long wrote:
> On Fri, Nov 30, 2018 at 5:52 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Thu, Nov 29, 2018 at 02:44:07PM +0800, Xin Long wrote:
> > > Without holding transport to dereference its asoc, a use after
> > > free panic can be caused in sctp_epaddr_lookup_transport. Note
> > > that a sock lock can't protect these transports that belong to
> > > other socks.
> > >
> > > A similar fix as Commit bab1be79a516 ("sctp: hold transport
> > > before accessing its asoc in sctp_transport_get_next") is
> > > needed to hold the transport before accessing its asoc in
> > > sctp_epaddr_lookup_transport.
> > >
> > > Note that this extra atomic operation is on the datapath,
> > > but as rhlist keeps the lists to a small size, it won't
> > > see a noticeable performance hurt.
> > >
> > > v1->v2:
> > >   - improve the changelog.
> > >
> > > Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> > > Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/sctp/input.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > > index 5c36a99..ce7351c 100644
> > > --- a/net/sctp/input.c
> > > +++ b/net/sctp/input.c
> > > @@ -967,9 +967,15 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
> > >       list = rhltable_lookup(&sctp_transport_hashtable, &arg,
> > >                              sctp_hash_params);
> > >
> > > -     rhl_for_each_entry_rcu(t, tmp, list, node)
> > > -             if (ep = t->asoc->ep)
> > > +     rhl_for_each_entry_rcu(t, tmp, list, node) {
> > > +             if (!sctp_transport_hold(t))
> > > +                     continue;
> > > +             if (ep = t->asoc->ep) {
> > > +                     sctp_transport_put(t);
> > >                       return t;
> > > +             }
> > > +             sctp_transport_put(t);
> > > +     }
> > >
> > >       return NULL;
> > >  }
> >
> > Wait a second, what if we just added an rcu_head to the association structure
> > and changed the kfree call in sctp_association_destroy to a kfree_rcu call
> > instead?  That would force the actual freeing of the association to pass through
> > a grace period, during which any in flight list traversal in
> > sctp_epaddr_lookup_transport could complete safely.  Its another two pointers
> We discussed this in last thread:
> https://www.spinics.net/lists/netdev/msg535191.html
> 
> It will cause closed sk to linger longer.
> 
Yes, but we never really got resolution on that topic.  I don't see that a
socket lingering for an extra grace period is that big a deal.  I also don't see
how sending the actual kfree through a grace period is going to cause the socket
to linger.  If you look at sctp_association_destroy, we call sock_put prior to
calling kfree at the end of the function.  All I'm looking for here is for the
memory free to wait until any list traversal in sctp_epaddr_lookup_transport is
done, which is what you are trying to do with your atomics.

As for your comment regarding sctp_transport_destroy_rcu, yes, that forces a
grace period when a transport is being destroyed, which will protect against
list corruption of the transport list here.  Thats good, but isn't what you are
trying to fix.  Your initial claim was that the asoc pointer for a given
transport was no longer valid, because it was getting freed while the transport
was still on the list.  That can clearly happen as we release all the transports
in sctp_association_free prior to calling what ostensibly is the last refrence
to their parent association at the end of that function, but its only the
transports that pass through a grace period before getting freed, the
association happens synchrnously, ignoring any grace period, and thats what we
need to change.

The more I look at it the more I'm convinced. What you're doing here is
definately overkill.  You need to add an rcu_head to the association and just do
the kfree of its memory after a grace period.  Its actually only a single grace
period as well.  If someone is traversing the transport list, both the transport
and association rcu callbacks will get run once the rcu_read_lock is released.


Nak to this patch
Neil

> > worth of space in the association, but I think that would be a worthwhile
> > tradeoff for not having to do N atomic adds/puts every time you wanted to
> > receive or send a frame.
> N is not a big value, as rhlist itself keeps lists in a size.
> 
> >
> > Neil
> >
> > > --
> > > 2.1.0
> > >
> > >
> 
