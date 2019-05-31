From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 31 May 2019 12:42:42 +0000
Subject: Re: memory leak in sctp_process_init
Message-Id: <20190531124242.GE3713@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
 <20190529233757.GC3713@localhost.localdomain>
 <20190530142011.GC1966@hmswarspite.think-freely.org>
 <20190530151705.GD3713@localhost.localdomain>
 <20190530195634.GD1966@hmswarspite.think-freely.org>
In-Reply-To: <20190530195634.GD1966@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

On Thu, May 30, 2019 at 03:56:34PM -0400, Neil Horman wrote:
> On Thu, May 30, 2019 at 12:17:05PM -0300, Marcelo Ricardo Leitner wrote:
...
> > --- a/net/sctp/sm_sideeffect.c
> > +++ b/net/sctp/sm_sideeffect.c
> > @@ -898,6 +898,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> >  						asoc->rto_initial;
> >  	}
> >  
> > +	if (sctp_state(asoc, ESTABLISHED)) {
> > +		kfree(asoc->peer.cookie);
> > +		asoc->peer.cookie = NULL;
> > +	}
> > +
> Not sure I follow why this is needed.  It doesn't hurt anything of course, but
> if we're freeing in sctp_association_free, we don't need to duplicate the
> operation here, do we?

This one would be to avoid storing the cookie throughout the entire
association lifetime, as the cookie is only needed during the
handshake.
While the free in sctp_association_free will handle the freeing in
case the association never enters established state.

> >  	if (sctp_state(asoc, ESTABLISHED) ||
> >  	    sctp_state(asoc, CLOSED) ||
> >  	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {
> > 
> > Also untested, just sharing the idea.
> > 
> >   Marcelo
> > 
