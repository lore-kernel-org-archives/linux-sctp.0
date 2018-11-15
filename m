From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 15 Nov 2018 23:25:40 +0000
Subject: Re: [PATCH net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <20181115232540.GA7442@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <7417f2d10de933afb69b832d9a30a210f42a16bb.1542280468.git.lucien.xin@gmail.com>
 <20181115172221.GA3601@localhost.localdomain>
 <20181115214310.GA8505@neilslaptop.think-freely.org>
 <20181115222536.GB31918@localhost.localdomain>
In-Reply-To: <20181115222536.GB31918@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net

On Thu, Nov 15, 2018 at 08:25:36PM -0200, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 15, 2018 at 04:43:10PM -0500, Neil Horman wrote:
> > On Thu, Nov 15, 2018 at 03:22:21PM -0200, Marcelo Ricardo Leitner wrote:
> > > On Thu, Nov 15, 2018 at 07:14:28PM +0800, Xin Long wrote:
> > > > As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:
> > > > 
> > > >    This socket option allows the enabling or disabling of the
> > > >    negotiation of PR-SCTP support for future associations.  For existing
> > > >    associations, it allows one to query whether or not PR-SCTP support
> > > >    was negotiated on a particular association.
> > > > 
> > > > It means only sctp sock's prsctp_enable can be set.
> > > > 
> > > > Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
> > > > add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
> > > > sctp in another patchset.
> > > > 
> > > > Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
> > > > Reported-by: Ying Xu <yinxu@redhat.com>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/sctp/socket.c | 13 +++----------
> > > >  1 file changed, 3 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > index 739f3e5..e9b8232 100644
> > > > --- a/net/sctp/socket.c
> > > > +++ b/net/sctp/socket.c
> > > > @@ -3940,7 +3940,6 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> > > >  					unsigned int optlen)
> > > >  {
> > > >  	struct sctp_assoc_value params;
> > > > -	struct sctp_association *asoc;
> > > >  	int retval = -EINVAL;
> > > >  
> > > >  	if (optlen != sizeof(params))
> > > > @@ -3951,16 +3950,10 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
> > > >  		goto out;
> > > >  	}
> > > >  
> > > > -	asoc = sctp_id2assoc(sk, params.assoc_id);
> > > > -	if (asoc) {
> > > > -		asoc->prsctp_enable = !!params.assoc_value;
> > > > -	} else if (!params.assoc_id) {
> > > > -		struct sctp_sock *sp = sctp_sk(sk);
> > > > -
> > > > -		sp->ep->prsctp_enable = !!params.assoc_value;
> > > > -	} else {
> > > > +	if (sctp_style(sk, UDP) && sctp_id2assoc(sk, params.assoc_id))
> > > 
> > > This would allow using a non-existent assoc id on UDP-style sockets to
> > > set it at the socket, which is not expected. It should be more like:
> > > 
> > > +	if (sctp_style(sk, UDP) && params.assoc_id)
> > How do you see that to be the case? sctp_id2assoc will return NULL if an
> > association isn't found, so the use of sctp_id2assoc should work just fine.
> 
> Right, it will return NULL, and because of that it won't bail out as
> it should and will adjust the socket config instead.
> 

Oh, duh, you're absolutely right, NULL will evalutate to false there, and skip
the conditional goto out;

that said, It would make more sense to me to just change the sense of the second
condition to !sctp_id2assoc(sk, params.assoc_id), so that we goto out if no
association is found.  it still seems a bit dodgy to me to just check if
params.assoc_id is non-zero, as that will allow userspace to pass invalid assoc
ids in and have those trigger pr support updates.

Neil
