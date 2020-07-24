From: Christoph Hellwig <hch@lst.de>
Date: Fri, 24 Jul 2020 06:46:03 +0000
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Message-Id: <20200724064603.GA8449@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com> <20200722204231.GA3398@localhost.localdomain> <20200723092238.GA21143@lst.de> <20200723153025.GF3307@localhost.localdomain>
In-Reply-To: <20200723153025.GF3307@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Thu, Jul 23, 2020 at 12:30:25PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Jul 23, 2020 at 11:22:38AM +0200, Christoph Hellwig wrote:
> > On Wed, Jul 22, 2020 at 05:42:31PM -0300, Marcelo Ricardo Leitner wrote:
> > > Cc'ing linux-sctp@vger.kernel.org.
> > 
> > What do you think of this version, which I think is a little cleaner?
> 
> It splits up the argument parsing from the actual handling, ok. Looks
> good. Just one point:
> 
> > +static int sctp_setsockopt_delayed_ack(struct sock *sk,
> > +				       struct sctp_sack_info *params,
> > +				       unsigned int optlen)
> > +{
> > +	if (optlen = sizeof(struct sctp_assoc_value)) {
> > +		struct sctp_sack_info p;
> > +
> > +		pr_warn_ratelimited(DEPRECATED
> > +				    "%s (pid %d) "
> > +				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
> > +				    "Use struct sctp_sack_info instead\n",
> > +				    current->comm, task_pid_nr(current));
> > +
> > +		memcpy(&p, params, sizeof(struct sctp_assoc_value));
> > +		p.sack_freq = p.sack_delay ? 0 : 1;
> 
> Please add a comment saying that sctp_sack_info.sack_delay maps
> exactly to sctp_assoc_value.assoc_value, so that's why we can do
> memcpy and read assoc_value as sack_delay. I think it will help us not
> trip on this again in the future.

Yeah.  Actually I think I'll go all the way and kill the not very
obvious or type safe memcpy as well.
