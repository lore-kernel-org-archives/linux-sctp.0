From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 21 Nov 2018 18:52:27 +0000
Subject: Re: [PATCH net] sctp: hold transport before accessing its asoc in sctp_hash_transport
Message-Id: <20181121185227.GF3601@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <b1ff91726b33df038aa57cbb8103dee29436d349.1542712156.git.lucien.xin@gmail.com>
 <20181120125248.GA20562@hmswarspite.think-freely.org>
 <20181121004625.GC3601@localhost.localdomain>
 <20181121132721.GA11254@hmswarspite.think-freely.org>
In-Reply-To: <20181121132721.GA11254@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Wed, Nov 21, 2018 at 08:27:21AM -0500, Neil Horman wrote:
> On Tue, Nov 20, 2018 at 10:46:26PM -0200, Marcelo Ricardo Leitner wrote:
> > On Tue, Nov 20, 2018 at 07:52:48AM -0500, Neil Horman wrote:
> > > On Tue, Nov 20, 2018 at 07:09:16PM +0800, Xin Long wrote:
> > > > In sctp_hash_transport, it dereferences a transport's asoc only under
> > > > rcu_read_lock. Without holding the transport, its asoc could be freed
> > > > already, which leads to a use-after-free panic.
> > > > 
> > > > A similar fix as Commit bab1be79a516 ("sctp: hold transport before
> > > > accessing its asoc in sctp_transport_get_next") is needed to hold
> > > > the transport before accessing its asoc in sctp_hash_transport.
> > > > 
> > > > Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> > > > Reported-by: syzbot+0b05d8aa7cb185107483@syzkaller.appspotmail.com
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/sctp/input.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/sctp/input.c b/net/sctp/input.c
> > > > index 5c36a99..69584e9 100644
> > > > --- a/net/sctp/input.c
> > > > +++ b/net/sctp/input.c
> > > > @@ -896,11 +896,16 @@ int sctp_hash_transport(struct sctp_transport *t)
> > > >  	list = rhltable_lookup(&sctp_transport_hashtable, &arg,
> > > >  			       sctp_hash_params);
> > > >  
> > > > -	rhl_for_each_entry_rcu(transport, tmp, list, node)
> > > > +	rhl_for_each_entry_rcu(transport, tmp, list, node) {
> > > > +		if (!sctp_transport_hold(transport))
> > > > +			continue;
> > > >  		if (transport->asoc->ep = t->asoc->ep) {
> > > > +			sctp_transport_put(transport);
> > > >  			rcu_read_unlock();
> > > >  			return -EEXIST;
> > > >  		}
> > > > +		sctp_transport_put(transport);
> > > > +	}
> > > >  	rcu_read_unlock();
> > > >  
> > > >  	err = rhltable_insert_key(&sctp_transport_hashtable, &arg,
> > > > -- 
> > > > 2.1.0
> > > > 
> > > > 
> > > 
> > > something doesn't feel at all right about this.  If we are inserting a transport
> > > to an association, it would seem to me that we should have at least one user of
> > > the association (i.e. non-zero refcount).  As such it seems something is wrong
> > > with the association refcount here.  At the very least, if there is a case where
> > > an association is being removed while a transport is being added, the better
> > > solution would be to ensure that sctp_association_destroy goes through a
> > > quiescent point prior to unhashing transports from the list, to ensure that
> > > there is no conflict with the add operation above.
> > 
> > Consider that the rhl_for_each_entry_rcu() is traversing the global
> > rhashtable, and that it may operate on unrelated transports/asocs.
> > E.g., transport->asoc in the for() is potentially different from the
> > asoc under socket lock.
> > 
> Ah, ok, we're comparing associations that are not related to the association
> being searched for, that makes sense.
> 
> > The core of the fix is at:
> > +		if (!sctp_transport_hold(transport))
> > +			continue;
> > If we can get a hold, the asoc will be available for dereferencing in
> > subsequent lines. Otherwise, move on.
> > 
> > With that, the patch makes sense to me.
> > 
> Yes, I agree, but as you note below, this still seems like a lousy way to fix
> the problem.
> 
> > Although I would prefer if we come up with a better way to do this
> > jump, or even avoid the jump. We are only comparing pointers here and
> > if we had asoc->ep cached on sctp_transport itself, we could avoid the
> > atomics here.
> > 
> > This change, in the next patch on sctp_epaddr_lookup_transport, will
> > hurt performance as that is called in datapath. Rhashtable will help
> > on keeping entry lists to a size, but still.
> > 
> I still think the rcu_read_lock would be sufficient here, if we just ensured
> that removals from the list occured after a quiescent point.  The lookup is in

I'm not sure I follow.

> the datapath, but adds/removes can have a little more latency added to them, and
> if it removes the atomic operation from the fast path, I think thats a net win.

Agree.
