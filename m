From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 11 Mar 2020 03:34:28 +0000
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
Message-Id: <20200311033428.GD2547@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
 <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
 <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
In-Reply-To: <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jere Leppanen <jere.leppanen@nokia.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>

On Wed, Mar 04, 2020 at 07:13:14PM +0200, Jere Leppanen wrote:
> On Wed, 4 Mar 2020, Xin Long wrote:
> 
> > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > <jere.leppanen@nokia.com> wrote:
> > > 
> > > On Mon, 2 Mar 2020, Xin Long wrote:
> > > 
> > > > As it says in rfc6458#section-9.2:
> > > > 
> > > >   The application uses the sctp_peeloff() call to branch off an
> > > >   association into a separate socket.  (Note that the semantics are
> > > >   somewhat changed from the traditional one-to-one style accept()
> > > >   call.)  Note also that the new socket is a one-to-one style socket.
> > > >   Thus, it will be confined to operations allowed for a one-to-one
> > > >   style socket.
> > > > 
> > > > Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > > > on which some operations are not allowed, like shutdown, as Jere
> > > > reported.
> > > > 
> > > > This patch is to change it to return a one-to-one type socket instead.
> > > 
> > > Thanks for looking into this. I like the patch, and it fixes my simple
> > > test case.
> > > 
> > > But with this patch, peeled-off sockets are created by copying from a
> > > one-to-many socket to a one-to-one socket. Are you sure that that's
> > > not going to cause any problems? Is it possible that there was a
> > > reason why peeloff wasn't implemented this way in the first place?
> > I'm not sure, it's been there since very beginning, and I couldn't find
> > any changelog about it.
> > 
> > I guess it was trying to differentiate peeled-off socket from TCP style
> > sockets.

Me too.

> 
> Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> there is legitimate need for that differentiation in some cases, but I think
> inventing a special socket style is not the best way to handle it.

I agree, but.. (in the end of the email)

> 
> But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET to
> SOCK_STREAM, but why would we need to avoid that?
> 
> Mark Butler commented in 2006
> (https://sourceforge.net/p/lksctp/mailman/message/10122693/):
> 
>     In short, SOCK_SEQPACKET could/should be replaced with SOCK_STREAM
>     right there, but there might be a minor dependency or two that would
>     need to be fixed.
> 
> > 
> > > 
> > > With this patch there's no way to create UDP_HIGH_BANDWIDTH style
> > > sockets anymore, so the remaining references should probably be
> > > cleaned up:
> > > 
> > > ./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
> > > ./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))
> > > ./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,
> > > 
> > > This patch disables those checks. The first one ignores a destination
> > > address given to sendmsg() with a peeled-off socket - I don't know
> > > why. The second one prevents listen() on a peeled-off socket.
> > My understanding is:
> > UDP_HIGH_BANDWIDTH is another kind of one-to-one socket, like TCP style.
> > it can get asoc by its socket when sending msg, doesn't need daddr.
> 
> But on that association, the peer may have multiple addresses. The RFC says
> (https://tools.ietf.org/html/rfc6458#section-4.1.8):
> 
>     When sending, the msg_name field [...] is used to indicate a preferred
>     peer address if the sender wishes to discourage the stack from sending
>     the message to the primary address of the receiver.

Which means the currect check in 1886 is wrong and should be fixed regardless.

> 
> > 
> > Now I thinking to fix your issue in sctp_shutdown():
> > 
> > @@ -5163,7 +5163,7 @@ static void sctp_shutdown(struct sock *sk, int how)
> >        struct net *net = sock_net(sk);
> >        struct sctp_endpoint *ep;
> > 
> > -       if (!sctp_style(sk, TCP))
> > +       if (sctp_style(sk, UDP))
> >                return;
> > 
> > in this way, we actually think:
> > one-to-many socket: UDP style socket
> > one-to-one socket includes: UDP_HIGH_BANDWIDTH and TCP style sockets.
> > 
> 
> That would probably fix shutdown(), but there are other problems as well.
> sctp_style() is called in nearly a hundred different places, I wonder if
> anyone systematically went through all of them back when UDP_HIGH_BANDWIDTH
> was added.

I suppose, and with no grounds, just random thoughts, that
UDP_HIGH_BANDWIDTH is a left-over from an early draft/implementation.

> 
> I think getting rid of UDP_HIGH_BANDWIDTH altogether is a much cleaner
> solution. That's what your patch does, which is why I like it. But such a
> change could easily break something.

Xin's initial patch here or this without backward compatibility, will
create some user-noticeable differences, yes. For example, in
sctp_recvmsg():
        if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
            !sctp_sstate(sk, CLOSING) && !sctp_sstate(sk, CLOSED)) {
                err = -ENOTCONN;
                goto out;

And in sctp_setsockopt_autoclose():
" * This socket option is applicable to the UDP-style socket only. When"
        /* Applicable to UDP-style socket only */
        if (sctp_style(sk, TCP))
                return -EOPNOTSUPP;

Although on RFC it was updated to:
8.1.8.  Automatic Close of Associations (SCTP_AUTOCLOSE)
   This socket option is applicable to the one-to-many style socket
   only.

These would start to be checked with such change. The first is a
minor, because that return code is already possible from within
sctp_wait_for_packet(), it's mostly just enforced later. But the
second..  Yes, we're violating the RFC in there, but OTOH, I'm afraid
it may be too late to fix it.

Removing UDP_HIGH_BANDWIDTH would thus require some weird checks, like
in the autoclose example above, something like:
        /* Applicable to one-to-many sockets only */
        if (sctp_style(sk, TCP) && !sctp_peeledoff(sk))
                return -EOPNOTSUPP;

Which doesn't help much by now. Yet, maybe there is only a few cases
like this around?

  Marcelo
