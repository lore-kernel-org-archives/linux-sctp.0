From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 21 Jan 2016 13:05:53 +0000
Subject: Re: [PATCH net] sctp: fix rcu usage on proc listing
Message-Id: <20160121130553.GA3452@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <c68813736c92f28f78f1c8cc8f362e4c964f7899.1453240529.git.marcelo.leitner@gmail.com>
 <20160119220230.GA15926@mrl.redhat.com>
 <20160120010720.GA22183@mrl.redhat.com>
In-Reply-To: <20160120010720.GA22183@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org

On Tue, Jan 19, 2016 at 11:07:20PM -0200, Marcelo Ricardo Leitner wrote:
> On Tue, Jan 19, 2016 at 08:02:30PM -0200, Marcelo Ricardo Leitner wrote:
> > > --- a/net/sctp/proc.c
> > > +++ b/net/sctp/proc.c
> > > @@ -491,6 +491,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
> > >  	tsp = (struct sctp_transport *)v;
> > >  	assoc = tsp->asoc;
> > >  
> > > +	rcu_read_lock();
> 
> should have used rcu_read_lock_bh() here, will send a v2 tomorrow.

Please just drop this one, no change is actually needed.
rhashtable_walk_start() already puts the rcu_read_lock() in there and
disabling bh is not necessary. Thanks.

> > >  	list_for_each_entry_rcu(tsp, &assoc->peer.transport_addr_list,
> > >  				transports) {
> > >  		if (tsp->dead)
> > > @@ -543,6 +544,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
> > >  
> > >  		seq_printf(seq, "\n");
> > >  	}
> > > +	rcu_read_unlock();
> > >  
> > >  	return 0;
> > >  }
> > > -- 
> > > 2.5.0
> > > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
