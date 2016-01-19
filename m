From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 19 Jan 2016 22:02:30 +0000
Subject: Re: [PATCH net] sctp: fix rcu usage on proc listing
Message-Id: <20160119220230.GA15926@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <c68813736c92f28f78f1c8cc8f362e4c964f7899.1453240529.git.marcelo.leitner@gmail.com>
In-Reply-To: <c68813736c92f28f78f1c8cc8f362e4c964f7899.1453240529.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org

[just cc'ing linux-sctp@vger.kernel.org]

On Tue, Jan 19, 2016 at 07:59:03PM -0200, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> commit 39f66a7dce32 ("sctp: apply rhashtable api to sctp procfs")
> removed a rcu_read_lock() too much at sctp_remaddr_seq_show().
> 
> Fixes: 39f66a7dce32 ("sctp: apply rhashtable api to sctp procfs")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/proc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index dfa7eeccb5373053f460f1026a58e4a2ba015a69..4fdf4387910696492ba568b1096dd12e8e7221e2 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -491,6 +491,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
>  	tsp = (struct sctp_transport *)v;
>  	assoc = tsp->asoc;
>  
> +	rcu_read_lock();
>  	list_for_each_entry_rcu(tsp, &assoc->peer.transport_addr_list,
>  				transports) {
>  		if (tsp->dead)
> @@ -543,6 +544,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
>  
>  		seq_printf(seq, "\n");
>  	}
> +	rcu_read_unlock();
>  
>  	return 0;
>  }
> -- 
> 2.5.0
> 
