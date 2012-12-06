From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 06 Dec 2012 18:25:04 +0000
Subject: Re: [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
Message-Id: <50C0E300.3000703@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <a803093c70e857e8e01e554288ee79f66f7acda4.1354814846.git.tgraf@suug.ch>
In-Reply-To: <a803093c70e857e8e01e554288ee79f66f7acda4.1354814846.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/06/2012 12:34 PM, Thomas Graf wrote:
> address_list is protected via the socket lock or RCU. Since we don't want
> to take the socket lock for each assoc we dump in procfs a RCU read-side
> critical section must be entered.
>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> ---
>   net/sctp/proc.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 9966e7b..ec9b0c8 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -139,7 +139,8 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
>   	    primary = &peer->saddr;
>   	}
>
> -	list_for_each_entry(laddr, &epb->bind_addr.address_list, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(laddr, &epb->bind_addr.address_list, list) {
>   		addr = &laddr->a;
>   		af = sctp_get_af_specific(addr->sa.sa_family);
>   		if (primary && af->cmp_addr(addr, primary)) {
> @@ -147,6 +148,7 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
>   		}
>   		af->seq_dump_addr(seq, addr);
>   	}
> +	rcu_read_unlock();
>   }
>
>   /* Dump remote addresses of an association. */
>

May want to avoid printing addresses that are !addr->valid.

Otherwise looks good.

-vlad
