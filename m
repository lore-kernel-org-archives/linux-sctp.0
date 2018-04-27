From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 27 Apr 2018 19:03:29 +0000
Subject: Re: [PATCH net-next 03/13] sctp: remove an if() that is always true
Message-Id: <20180427190329.GC22078@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
 <b083bd9240e25ad84cda4d9212b886da2373ec11.1524772453.git.marcelo.leitner@gmail.com>
 <20180427105050.GA22078@hmswarspite.think-freely.org>
 <20180427181349.GA5105@localhost.localdomain>
In-Reply-To: <20180427181349.GA5105@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

On Fri, Apr 27, 2018 at 03:13:49PM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Apr 27, 2018 at 06:50:50AM -0400, Neil Horman wrote:
> > On Thu, Apr 26, 2018 at 04:58:52PM -0300, Marcelo Ricardo Leitner wrote:
> > > As noticed by Xin Long, the if() here is always true as PMTU can never
> > > be 0.
> > >
> > > Reported-by: Xin Long <lucien.xin@gmail.com>
> > > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > ---
> > >  net/sctp/associola.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > > index b3aa95222bd52113295cb246c503c903bdd5c353..c5ed09cfa8423b17546e3d45f6d06db03af66384 100644
> > > --- a/net/sctp/associola.c
> > > +++ b/net/sctp/associola.c
> > > @@ -1397,10 +1397,8 @@ void sctp_assoc_sync_pmtu(struct sctp_association *asoc)
> > >  			pmtu = t->pathmtu;
> > >  	}
> > >
> > > -	if (pmtu) {
> > > -		asoc->pathmtu = pmtu;
> > > -		asoc->frag_point = sctp_frag_point(asoc, pmtu);
> > > -	}
> > > +	asoc->pathmtu = pmtu;
> > > +	asoc->frag_point = sctp_frag_point(asoc, pmtu);
> > >
> > Can you double check this?  Looking at it, it seems far fetched, but if someone
> 
> Sure.
> 
> > sends a crafted icmp dest unreach message to the host, pmtu_sending might be
> > able to get set for an association (which may have no transports established
> > yet), and if so, on the first packet send sctp_assoc_sync_pmtu can be called,
> > leading to a fall through in the loop over all transports, and pmtu being zero.
> > It seems like a far fetched set of circumstances, I know, but if it can happen,
> > I think you might see a crash in sctp_frag_point due to an underflow of the frag
> > value
> 
> If I got you right, this situation would not happen because when
> handling the icmp it will check if there is a transport and ignore it
> otherwise.
> 
Yup, you're right.  sctp_err_lookup returns NULL if there is no transport
associated with the icmp message

Thanks
Neil

>   Marcelo
> 
> >
> > Neil
> >
> > >  	pr_debug("%s: asoc:%p, pmtu:%d, frag_point:%d\n", __func__, asoc,
> > >  		 asoc->pathmtu, asoc->frag_point);
> > > --
> > > 2.14.3
> > >
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
