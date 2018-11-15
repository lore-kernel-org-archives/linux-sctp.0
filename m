From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 15 Nov 2018 21:43:10 +0000
Subject: Re: [PATCH net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <20181115214310.GA8505@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <7417f2d10de933afb69b832d9a30a210f42a16bb.1542280468.git.lucien.xin@gmail.com>
 <20181115172221.GA3601@localhost.localdomain>
In-Reply-To: <20181115172221.GA3601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Thu, Nov 15, 2018 at 03:22:21PM -0200, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 15, 2018 at 07:14:28PM +0800, Xin Long wrote:
> > As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:
> > 
> >    This socket option allows the enabling or disabling of the
> >    negotiation of PR-SCTP support for future associations.  For existing
> >    associations, it allows one to query whether or not PR-SCTP support
> >    was negotiated on a particular association.
> > 
> > It means only sctp sock's prsctp_enable can be set.
> > 
> > Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
> > add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
> > sctp in another patchset.
> > 
> > Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/socket.c | 13 +++----------
> >  1 file changed, 3 insertions(+), 10 deletions(-)
> > 
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 739f3e5..e9b8232 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -3940,7 +3940,6 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> >  					unsigned int optlen)
> >  {
> >  	struct sctp_assoc_value params;
> > -	struct sctp_association *asoc;
> >  	int retval = -EINVAL;
> >  
> >  	if (optlen != sizeof(params))
> > @@ -3951,16 +3950,10 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> >  		goto out;
> >  	}
> >  
> > -	asoc = sctp_id2assoc(sk, params.assoc_id);
> > -	if (asoc) {
> > -		asoc->prsctp_enable = !!params.assoc_value;
> > -	} else if (!params.assoc_id) {
> > -		struct sctp_sock *sp = sctp_sk(sk);
> > -
> > -		sp->ep->prsctp_enable = !!params.assoc_value;
> > -	} else {
> > +	if (sctp_style(sk, UDP) && sctp_id2assoc(sk, params.assoc_id))
> 
> This would allow using a non-existent assoc id on UDP-style sockets to
> set it at the socket, which is not expected. It should be more like:
> 
> +	if (sctp_style(sk, UDP) && params.assoc_id)
How do you see that to be the case? sctp_id2assoc will return NULL if an
association isn't found, so the use of sctp_id2assoc should work just fine.
Just checking params.assoc_id would instead fail the setting of any association
id that isn't 0, which I don't think is what we want at all.

Neil

> 
> >  		goto out;
> > -	}
> > +
> > +	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
> >  
> >  	retval = 0;
> >  
> > -- 
> > 2.1.0
> > 
> 
