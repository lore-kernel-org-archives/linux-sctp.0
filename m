From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 06 Dec 2012 20:07:20 +0000
Subject: Re: [PATCH 1/2] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
Message-Id: <50C0FAF8.6060706@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1354821623.git.tgraf@suug.ch> <28cdea17e7b2c0f9f9c2a18949b10abc8cb84db2.1354821623.git.tgraf@suug.ch>
In-Reply-To: <28cdea17e7b2c0f9f9c2a18949b10abc8cb84db2.1354821623.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, Thomas Graf <tgraf@redhat.com>

On 12/06/2012 02:25 PM, Thomas Graf wrote:
> From: Thomas Graf <tgraf@redhat.com>
>
> address_list is protected via the socket lock or RCU. Since we don't want
> to take the socket lock for each assoc we dump in procfs a RCU read-side
> critical section must be entered.
>
> V2: Skip local addresses marked as dead
>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Acked-by: Vlad Yasevich <vyasevic@gmail.com>

-vlad

> ---
>   net/sctp/proc.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 9966e7b..06b05ee 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -139,7 +139,11 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
>   	    primary = &peer->saddr;
>   	}
>
> -	list_for_each_entry(laddr, &epb->bind_addr.address_list, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(laddr, &epb->bind_addr.address_list, list) {
> +		if (!laddr->valid)
> +			continue;
> +
>   		addr = &laddr->a;
>   		af = sctp_get_af_specific(addr->sa.sa_family);
>   		if (primary && af->cmp_addr(addr, primary)) {
> @@ -147,6 +151,7 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
>   		}
>   		af->seq_dump_addr(seq, addr);
>   	}
> +	rcu_read_unlock();
>   }
>
>   /* Dump remote addresses of an association. */
>

