From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 23 Jul 2020 15:30:25 +0000
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Message-Id: <20200723153025.GF3307@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
 <20200722204231.GA3398@localhost.localdomain>
 <20200723092238.GA21143@lst.de>
In-Reply-To: <20200723092238.GA21143@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Thu, Jul 23, 2020 at 11:22:38AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 22, 2020 at 05:42:31PM -0300, Marcelo Ricardo Leitner wrote:
> > Cc'ing linux-sctp@vger.kernel.org.
> 
> What do you think of this version, which I think is a little cleaner?

It splits up the argument parsing from the actual handling, ok. Looks
good. Just one point:

> +static int sctp_setsockopt_delayed_ack(struct sock *sk,
> +				       struct sctp_sack_info *params,
> +				       unsigned int optlen)
> +{
> +	if (optlen = sizeof(struct sctp_assoc_value)) {
> +		struct sctp_sack_info p;
> +
> +		pr_warn_ratelimited(DEPRECATED
> +				    "%s (pid %d) "
> +				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
> +				    "Use struct sctp_sack_info instead\n",
> +				    current->comm, task_pid_nr(current));
> +
> +		memcpy(&p, params, sizeof(struct sctp_assoc_value));
> +		p.sack_freq = p.sack_delay ? 0 : 1;

Please add a comment saying that sctp_sack_info.sack_delay maps
exactly to sctp_assoc_value.assoc_value, so that's why we can do
memcpy and read assoc_value as sack_delay. I think it will help us not
trip on this again in the future.

> +		return __sctp_setsockopt_delayed_ack(sk, &p);
> +	}
> +
> +	if (optlen != sizeof(struct sctp_sack_info))
> +		return -EINVAL;
> +	if (params->sack_delay = 0 && params->sack_freq = 0)
> +		return 0;
> +	return __sctp_setsockopt_delayed_ack(sk, params);
> +}
> +
>  /* 7.1.3 Initialization Parameters (SCTP_INITMSG)
>   *
>   * Applications can specify protocol parameters for the default association
