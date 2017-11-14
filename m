From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 14 Nov 2017 18:44:20 +0000
Subject: Re: [PATCH net] sctp: add wait_buf flag in asoc to avoid the peeloff and wait sndbuf race
Message-Id: <20171114184420.GH3675@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <b6b9359b3f45a81d00f2ae108e871b2f1113f87a.1510552078.git.lucien.xin@gmail.com>
 <20171113152300.GC7876@hmswarspite.think-freely.org>
 <CADvbK_cE=Lb43O67J+bPBf9JVOK+dcx=Xa9YNXSWMbWH7ODwXg@mail.gmail.com>
 <CADvbK_fQjTCES2dSsrsQAvF9bPCB9x=YMis8eV3j+F1CjExo+g@mail.gmail.com>
 <20171114143158.GC21954@hmswarspite.think-freely.org>
 <CADvbK_eXNYH6zVk0Z+u8EA-XSB68e_RaX29TN0HvEcLxiN4ORw@mail.gmail.com>
 <20171114150636.GD21954@hmswarspite.think-freely.org>
In-Reply-To: <20171114150636.GD21954@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>

On Tue, Nov 14, 2017 at 10:06:36AM -0500, Neil Horman wrote:
> On Tue, Nov 14, 2017 at 10:46:34PM +0800, Xin Long wrote:
> > On Tue, Nov 14, 2017 at 10:31 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > > On Mon, Nov 13, 2017 at 11:49:28PM +0800, Xin Long wrote:
> > >> On Mon, Nov 13, 2017 at 11:40 PM, Xin Long <lucien.xin@gmail.com> wrote:
> > >> > On Mon, Nov 13, 2017 at 11:23 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > >> >> On Mon, Nov 13, 2017 at 01:47:58PM +0800, Xin Long wrote:
> > >> >>> Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
> > >> >>> sleeping on it") fixed the race between peeloff and wait sndbuf by
> > >> >>> checking waitqueue_active(&asoc->wait) in sctp_do_peeloff().
> > >> >>>
> > >> >>> But it actually doesn't work as even if waitqueue_active returns false
> > >> >>> the waiting sndbuf thread may still not yet hold sk lock.
> > >> >>>
> > >> >>> This patch is to fix this by adding wait_buf flag in asoc, and setting it
> > >> >>> before going the waiting loop, clearing it until the waiting loop breaks,
> > >> >>> and checking it in sctp_do_peeloff instead.
> > >> >>>
> > >> >>> Fixes: dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads sleeping on it")
> > >> >>> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > >> >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >> >>> ---
> > >> >>>  include/net/sctp/structs.h | 1 +
> > >> >>>  net/sctp/socket.c          | 4 +++-
> > >> >>>  2 files changed, 4 insertions(+), 1 deletion(-)
> > >> >>>
> > >> >>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> > >> >>> index 0477945..446350e 100644
> > >> >>> --- a/include/net/sctp/structs.h
> > >> >>> +++ b/include/net/sctp/structs.h
> > >> >>> @@ -1883,6 +1883,7 @@ struct sctp_association {
> > >> >>>
> > >> >>>       __u8 need_ecne:1,       /* Need to send an ECNE Chunk? */
> > >> >>>            temp:1,            /* Is it a temporary association? */
> > >> >>> +          wait_buf:1,
> > >> >>>            force_delay:1,
> > >> >>>            prsctp_enable:1,
> > >> >>>            reconf_enable:1;
> > >> >>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > >> >>> index 6f45d17..1b2c78c 100644
> > >> >>> --- a/net/sctp/socket.c
> > >> >>> +++ b/net/sctp/socket.c
> > >> >>> @@ -4946,7 +4946,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
> > >> >>>       /* If there is a thread waiting on more sndbuf space for
> > >> >>>        * sending on this asoc, it cannot be peeled.
> > >> >>>        */
> > >> >>> -     if (waitqueue_active(&asoc->wait))
> > >> >>> +     if (asoc->wait_buf)
> > >> >>>               return -EBUSY;
> > >> >>>
> > >> >>>       /* An association cannot be branched off from an already peeled-off
> > >> >>> @@ -7835,6 +7835,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
> > >> >>>       /* Increment the association's refcnt.  */
> > >> >>>       sctp_association_hold(asoc);
> > >> >>>
> > >> >>> +     asoc->wait_buf = 1;
> > >> >>>       /* Wait on the association specific sndbuf space. */
> > >> >>>       for (;;) {
> > >> >>>               prepare_to_wait_exclusive(&asoc->wait, &wait,
> > >> >>> @@ -7860,6 +7861,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
> > >> >>>       }
> > >> >>>
> > >> >>>  out:
> > >> >>> +     asoc->wait_buf = 0;
> > >> >>>       finish_wait(&asoc->wait, &wait);
> > >> >>>
> > >> >>>       /* Release the association's refcnt.  */
> > >> >>> --
> > >> >>> 2.1.0
> > >> >>>
> > >> >>>
> > >> >>
> > >> >> This doesn't make much sense to me, as it appears to be prone to aliasing.  That
> > >> >> is to say:
> > >> >>
> > >> >> a) If multiple tasks are queued waiting in sctp_wait_for_sndbuf, the first
> > >> >> thread to exit that for(;;) loop will clean asoc->wait_buf, even though others
> > >> >> may be waiting on it, allowing sctp_do_peeloff to continue when it shouldn't be
> > >> > You're right, we talked about this before using waitqueue_active in
> > >> > earlier time.
> > >> > I didn't remember this somehow. Sorry.
> > >> >
> > >> >>
> > >> >> b) In the case of a single task blocking in sct_wait_for_sendbuf, checking
> > >> >> waitqueue_active is equally good, because it returns true, until such time as
> > >> >> finish_wait is called anyway.
> > >> > waitqueue_active can not work here, because in sctp_wait_for_sndbuf():
> > >> > ...
> > >> >                 release_sock(sk);
> > >> >                 current_timeo = schedule_timeout(current_timeo); <-----[a]
> > >> >                 lock_sock(sk);
> > >> > If another thread wakes up asoc->wait, it will be removed from
> > >> > this wait queue, you check DEFINE_WAIT, the callback autoremove_wake_function
> > >> > will do this removal in wake_up().
> > >> >
> > >> > I guess we need to think about another to fix this.
> > >> maybe we can use
> > >> DEFINE_WAIT_FUNC(wait, woken_wake_function);
> > >> instead of DEFINE_WAIT(wait) here ?
> > >>
> > > I'm still not sure I see the problem here.  If we have the following situation:
> > > * Exec context A is executing in sctp_do_peeloff, about to check
> > >   waitqueue_active()
> > > * Exec context B is blocking in sctp_wait_for_sndbuf(), specifically without the
> > >   socket lock held
> > >
> > >
> > > Then, we have two possibilities:
> > >
> > > a) Context A executes waitqueue_active, which returns true, implying that
> > > context B is still on the queue, or that some other undescribed context has
> > > begun waiting on the queue.  In either case, the behavior is correct, in that
> > > the peeloff is denied.
> > >
> > > b) Context B is woken up (and in the most pessimal case, has its waitq entry
> > > removed from queue immediately, causing context B to have waitequeue_active
> > > return false, allowing it to continue processing the peeloff.  Since it holds
> > > the socket lock however, context B will block on the lock_sock operation until
> > > such time as the peeloff completes, so you're safe.
> > >
> > > About the only issue that I see (and as I write this, I may be seeing what you
> > > are actually trying to fix here) is that, during the period where context A is
> > > sleeping in sctp_wait_for_sendbuf, with the socket lock released, it is possible
> > > for an sctp_do_peeloff operation to complete, meaning that assoc->base.sk might
> > > point to a new socket, allowing each context to hold an independent socket lock
> > > and execute in parallel.  To combat that, I think all you really need is some
> > > code in sctp_wait_for_sndbuf that looks like this:
> > >
> > > release_sock(sk);
> > > current_timeo = schedule_timeout(current_timeo);
> > > lock_sock(sk);
> > >
> > > if (sk != asoc->base.sk) {
> > >         /* a socket peeloff occured */
> > >         release_sock(sk);
> > >         sk = assoc->base.sk;
> > >         lock_sock(sk);
> > > }
> > >
> > > *timeo_p = current_timeo;
> > >
> > >
> > > Does that make sense?  This way, you lock the 'old' socket lock to ensure that
> > > the peeloff operation is completed, then you check to see if the socket has
> > > changed.  If it has, you migrate your socket to the new, peeled off one and
> > > continue your space availability check
> > Yes, you got what I'm trying to fix in this patch exactly. :-)
> > and the fix you proposed above is doable, but incomplete,
> > we also need to change the sk pointer in sctp_sendmsg:
> > @@ -1962,7 +1962,7 @@ static int sctp_sendmsg(struct sock *sk, struct
> > msghdr *msg, size_t msg_len)
> > 
> >         timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
> >         if (!sctp_wspace(asoc)) {
> > -               err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
> > +               err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len, &sk);

LGTM too. I just would welcome a comment somewhere around here to
highlight the fact the sk may change. When it happens, we will have
stale variables, like sp, which for now are not used.
The '&sk' already says it may change yes but it may be missed.

> >                 if (err) {
> >                         if (err = -ESRCH) {
> >                                 /* asoc is already dead; */
> > @@ -7828,7 +7828,7 @@ void sctp_sock_rfree(struct sk_buff *skb)
> > 
> >  /* Helper function to wait for space in the sndbuf.  */
> >  static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
> > -                               size_t msg_len)
> > +                               size_t msg_len, struct sock **orig_sk)
> >  {
> >         struct sock *sk = asoc->base.sk;
> >         int err = 0;
> > @@ -7862,11 +7862,17 @@ static int sctp_wait_for_sndbuf(struct
> > sctp_association *asoc, long *timeo_p,
> >                 release_sock(sk);
> >                 current_timeo = schedule_timeout(current_timeo);
> >                 lock_sock(sk);
> > +               if (sk != asoc->base.sk) {
> > +                       release_sock(sk);
> > +                       sk = asoc->base.sk;
> > +                       lock_sock(sk);
> > +               }
> > 
> >                 *timeo_p = current_timeo;
> >         }
> > 
> >  out:
> > +       *orig_sk = sk;
> >         finish_wait(&asoc->wait, &wait);
> > 
> > 
> > right ?
> > 
> 
> Yes, that makes sense, post that as a proper commit please, I'll support that.
> 
> Neil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
