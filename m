From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 01 Feb 2019 14:58:40 +0000
Subject: Re: [PATCH net] sctp: walk the list of asoc safely
Message-Id: <20190201145840.GD10521@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190201141522.GA20785@kroah.com>
 <20190201142037.GC10521@localhost.localdomain>
 <20190201144359.GA9864@kroah.com>
In-Reply-To: <20190201144359.GA9864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vuln@secunia.com

On Fri, Feb 01, 2019 at 03:43:59PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 01, 2019 at 12:20:37PM -0200, Marcelo Ricardo Leitner wrote:
> > On Fri, Feb 01, 2019 at 03:15:22PM +0100, Greg Kroah-Hartman wrote:
> > > In sctp_sendmesg(), when walking the list of endpoint associations, the
> > > association can be dropped from the list, making the list corrupt.
> > > Properly handle this by using list_for_each_entry_safe()
> > > 
> > > Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
> > > Reported-by: Secunia Research <vuln@secunia.com>
> > > Tested-by: Secunia Research <vuln@secunia.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index f93c3cf9e567..65d6d04546ae 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -2027,7 +2027,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
> > >  	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
> > >  	struct sctp_transport *transport = NULL;
> > >  	struct sctp_sndrcvinfo _sinfo, *sinfo;
> > > -	struct sctp_association *asoc;
> > > +	struct sctp_association *asoc, *tmp;
> > >  	struct sctp_cmsgs cmsgs;
> > >  	union sctp_addr *daddr;
> > >  	bool new = false;
> > > @@ -2053,7 +2053,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
> > 
> > Extending the context here by 1 line:
> >         lock_sock(sk);
> > >  
> > >  	/* SCTP_SENDALL process */
> > >  	if ((sflags & SCTP_SENDALL) && sctp_style(sk, UDP)) {
> > > -		list_for_each_entry(asoc, &ep->asocs, asocs) {
> > > +		list_for_each_entry_safe(asoc, tmp, &ep->asocs, asocs) {
> > 
> > With the socket being locked by here, how can an asoc be removed
> > while the list is being traversed? The socket lock should be
> > protecting from it.
> 
> What about when the SCTP_ABORT flag is set with SCTP_SENDALL at the same
> time?
> 
> :(

Good point! Thanks.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
