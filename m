From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Mar 2019 03:48:10 +0000
Subject: Re: [PATCH net 1/3] sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
Message-Id: <CADvbK_cca0Xmxa2E=4JzyvVqaS8T-fbn5tt4h43dWDE5WTCZ2g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com> <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
 <20190307182503.GB13515@localhost.localdomain>
In-Reply-To: <20190307182503.GB13515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Mar 8, 2019 at 2:25 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
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
>
> I'm having a hard time understanding why it needs sock_release() here
> and sk_common_release() in the above chunk. AFAICT by here (after
> sctp_sock_migrate call) the sockets are pretty much the same. Mind
> elaborating please?
In sctp_do_peeloff(),'sock' is 'struct socket' created by sock_create(),
which should be freed by sock_release(struct socket *sock), otherwise
no place takes care of its freeing.
(sock_create() also create sock->sk)

In sctp_accept(), 'newsk' is 'struct sock' created by sk_alloc(), and
it should be freed by sk_common_release(). Note by then sock->sk is not
yet set to 'newsk', so when it return errs, outside can't free newsk
when freeing sock.
(sys_accept() calls sock_alloc() directly that doesn't set sock->sk)
