From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 07 Apr 2016 18:29:54 +0000
Subject: Re: [PATCH net-next 5/7] sctp: reuse the some transport traversal functions in proc
Message-Id: <20160407182954.GF15005@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1459829123.git.lucien.xin@gmail.com>
 <cdc77cc7b894aab62dad372f0018c571e33cf16e.1459829123.git.lucien.xin@gmail.com>
 <20160407130930.GA4573@hmsreliant.think-freely.org>
In-Reply-To: <20160407130930.GA4573@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

On Thu, Apr 07, 2016 at 09:09:30AM -0400, Neil Horman wrote:
> On Tue, Apr 05, 2016 at 12:06:30PM +0800, Xin Long wrote:
> > There are some transport traversal functions for sctp_diag, we can also
> > use it for sctp_proc. cause they have the similar situation to traversal
> > transport.
> > 
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/proc.c | 80 +++++++++++++--------------------------------------------
> >  1 file changed, 18 insertions(+), 62 deletions(-)
> > 
> > diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> > index 5cfac8d..dd8492f 100644
> > --- a/net/sctp/proc.c
> > +++ b/net/sctp/proc.c
> > @@ -282,80 +282,31 @@ struct sctp_ht_iter {
> >  	struct rhashtable_iter hti;
> >  };
> >  
> > -static struct sctp_transport *sctp_transport_get_next(struct seq_file *seq)
> > -{
> > -	struct sctp_ht_iter *iter = seq->private;
> > -	struct sctp_transport *t;
> > -
> > -	t = rhashtable_walk_next(&iter->hti);
> > -	for (; t; t = rhashtable_walk_next(&iter->hti)) {
> > -		if (IS_ERR(t)) {
> > -			if (PTR_ERR(t) = -EAGAIN)
> > -				continue;
> > -			break;
> > -		}
> > -
> > -		if (net_eq(sock_net(t->asoc->base.sk), seq_file_net(seq)) &&
> > -		    t->asoc->peer.primary_path = t)
> > -			break;
> > -	}
> > -
> > -	return t;
> > -}
> > -
> 
> this may just be a nit, but you defined the new sctp_transport_get_next in patch
> 2 of this series, and didn't remove this private version until here.  Is that
> going to cause some behavioral issue, if someone builds a kernel between patch 2

Yes, it causes issues:

...net/sctp/proc.c:285:31: error: conflicting types for ‘sctp_transport_get_next’
 static struct sctp_transport *sctp_transport_get_next(struct seq_file *seq)
                               ^

> and 7?  Seems like perhaps those two patches should be merged.

Agreed.

  Marcelo

