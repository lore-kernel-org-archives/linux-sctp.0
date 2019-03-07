From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 07 Mar 2019 10:06:21 +0000
Subject: Re: [PATCH net 1/3] sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
Message-Id: <CADvbK_daLJLZs0bKdQmyTE8W=oJB4j86eeggjUhC8pKMy7YbKg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com> <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
 <20190306182127.GB10683@neilslaptop.think-freely.org>
In-Reply-To: <20190306182127.GB10683@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Mar 7, 2019 at 2:21 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Sun, Mar 03, 2019 at 05:54:53PM +0800, Xin Long wrote:
> > It should fail to create the new sk if sctp_bind_addr_dup() fails
> > when accepting or peeloff an association.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 34 ++++++++++++++++++++++++----------
> >  1 file changed, 24 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index a2771b3..22adb8d 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -102,9 +102,9 @@ static int sctp_send_asconf(struct sctp_association *asoc,
> >                           struct sctp_chunk *chunk);
> >  static int sctp_do_bind(struct sock *, union sctp_addr *, int);
> >  static int sctp_autobind(struct sock *sk);
> > -static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> > -                           struct sctp_association *assoc,
> > -                           enum sctp_socket_type type);
> > +static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> > +                          struct sctp_association *assoc,
> > +                          enum sctp_socket_type type);
> >
> >  static unsigned long sctp_memory_pressure;
> >  static atomic_long_t sctp_memory_allocated;
> > @@ -4655,7 +4655,11 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
> >       /* Populate the fields of the newsk from the oldsk and migrate the
> >        * asoc to the newsk.
> >        */
> > -     sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> > +     error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> > +     if (error) {
> > +             sk_common_release(newsk);
> sctp_sock_migrate may fail after the pending packets have been moved from the
> old socket to the new socket.  Normally those packets will get purged by
> successful transmission, or when the socket is closed (via sctp_close), but
> neither of those cases applies here.  Whats going to dequeue and free any
> pending skbs on the sk_receive_queue here?
>
> > +             newsk = NULL;
> > +     }
> >
> >  out:
> >       release_sock(sk);
> > @@ -5401,7 +5405,12 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
> >       /* Populate the fields of the newsk from the oldsk and migrate the
> >        * asoc to the newsk.
> >        */
> > -     sctp_sock_migrate(sk, sock->sk, asoc, SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
> > +     err = sctp_sock_migrate(sk, sock->sk, asoc,
> > +                             SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
> > +     if (err) {
> > +             sock_release(sock);
> Same question here, what frees any pending skbs on the new socket, if the
> migration fails after the skbs have been queued to it?
Luckily, in sctp_sock_migrate(), it can only fail before the skbs are
moved to newsk->sk_receive_queue. So when it returns err,
newsk->sk_receive_queue must be empty.

>
> > +             sock = NULL;
> > +     }
> >
> >       *sockp = sock;
> >
> > @@ -8924,9 +8933,9 @@ static inline void sctp_copy_descendant(struct sock *sk_to,
> >  /* Populate the fields of the newsk from the oldsk and migrate the assoc
> >   * and its messages to the newsk.
> >   */
> > -static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> > -                           struct sctp_association *assoc,
> > -                           enum sctp_socket_type type)
> > +static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> > +                          struct sctp_association *assoc,
> > +                          enum sctp_socket_type type)
> >  {
> >       struct sctp_sock *oldsp = sctp_sk(oldsk);
> >       struct sctp_sock *newsp = sctp_sk(newsk);
> > @@ -8935,6 +8944,7 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> >       struct sk_buff *skb, *tmp;
> >       struct sctp_ulpevent *event;
> >       struct sctp_bind_hashbucket *head;
> > +     int err;
> >
> >       /* Migrate socket buffer sizes and all the socket level options to the
> >        * new socket.
> > @@ -8963,8 +8973,10 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> >       /* Copy the bind_addr list from the original endpoint to the new
> >        * endpoint so that we can handle restarts properly
> >        */
> > -     sctp_bind_addr_dup(&newsp->ep->base.bind_addr,
> > -                             &oldsp->ep->base.bind_addr, GFP_KERNEL);
> > +     err = sctp_bind_addr_dup(&newsp->ep->base.bind_addr,
> > +                              &oldsp->ep->base.bind_addr, GFP_KERNEL);
> > +     if (err)
> > +             return err;
> >
> >       /* Move any messages in the old socket's receive queue that are for the
> >        * peeled off association to the new socket's receive queue.
> > @@ -9049,6 +9061,8 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> >       }
> >
> >       release_sock(newsk);
> > +
> > +     return 0;
> >  }
> >
> >
> > --
> > 2.1.0
> >
> >
