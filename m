From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 13 Sep 2010 13:45:06 +0000
Subject: Re: [PATCHv2 2/5] sctp: implement pluggable multistream scheduling
Message-Id: <4C8E2AE2.9050309@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTinaO5Fqn+QJxxkXSCsW0XWvhBc16jK6HGB_0YG0@mail.gmail.com>
In-Reply-To: <AANLkTinaO5Fqn+QJxxkXSCsW0XWvhBc16jK6HGB_0YG0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yaogong Wang <ywang15@ncsu.edu>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

One small nit.

On 09/11/2010 09:12 PM, Yaogong Wang wrote:
> Implement the pluggable multistream scheduling framework.
> Provide the default first-come-first-serve (FCFS) algorithm.
> 
> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
> ---
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 5027b83..d40c5cc 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1157,6 +1157,9 @@ SCTP_STATIC __init int sctp_init(void)
>  	sctp_max_instreams    		= SCTP_DEFAULT_INSTREAMS;
>  	sctp_max_outstreams   		= SCTP_DEFAULT_OUTSTREAMS;
> 
> +	/* Initialize default multistream scheduling algorithm to FCFS */
> +	sctp_default_sched_ops		= &sctp_fcfs;
> +
>  	/* Initialize handle used for association ids. */
>  	idr_init(&sctp_assocs_id);
> 
> @@ -1304,6 +1307,11 @@ SCTP_STATIC __init int sctp_init(void)
>  	if (status)
>  		goto err_v6_add_protocol;
> 
> +	/* Add FCFS to sctp_sched_list */
> +	status = sctp_register_sched(&sctp_fcfs);
> +	if (status)
> +		goto err_v6_add_protocol;
> +

This needs its own tag that will call sctp_v6_del_protocol().

-vlad

>  	status = 0;
>  out:
>  	return status;
> @@ -1348,6 +1356,9 @@ SCTP_STATIC __exit void sctp_exit(void)
>  	 * up all the remaining associations and all that memory.
>  	 */
> 
> +	/* Unregister FCFS from sctp_sched_list */
> +	sctp_unregister_sched(&sctp_fcfs);
> +
>  	/* Unregister with inet6/inet layers. */
>  	sctp_v6_del_protocol();
>  	sctp_v4_del_protocol();
> diff --git a/net/sctp/sched.c b/net/sctp/sched.c
> new file mode 100644
> index 0000000..3820e3f
> --- /dev/null
> +++ b/net/sctp/sched.c
> @@ -0,0 +1,177 @@
> +/*
> + * Plugable SCTP multistream scheduling support and
> + * the default first-come-first-serve (FCFS) algorithm
> + *
> + * Based on ideas from pluggable TCP congestion control
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <net/sctp/sctp.h>
> +
> +static DEFINE_SPINLOCK(sctp_sched_list_lock);
> +static LIST_HEAD(sctp_sched_list);
> +
> +/* Simple linear search, don't expect many entries! */
> +static struct sctp_sched_ops *sctp_sched_find(const char *name)
> +{
> +	struct sctp_sched_ops *e;
> +
> +	list_for_each_entry_rcu(e, &sctp_sched_list, list) {
> +		if (strcmp(e->name, name) = 0)
> +			return e;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * Attach new scheduling algorithm to the list
> + * of available options.
> + */
> +int sctp_register_sched(struct sctp_sched_ops *sched)
> +{
> +	int ret = 0;
> +
> +	/* algorithm must implement required ops */
> +	if (!sched->init || !sched->release || !sched->is_empty
> +		|| !sched->enqueue_head_data || !sched->enqueue_tail_data
> +		|| !sched->dequeue_data) {
> +		printk(KERN_ERR "SCTP %s does not implement required ops\n",
> +		       sched->name);
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&sctp_sched_list_lock);
> +	if (sctp_sched_find(sched->name)) {
> +		printk(KERN_NOTICE "SCTP %s already registered\n", sched->name);
> +		ret = -EEXIST;
> +	} else {
> +		list_add_tail_rcu(&sched->list, &sctp_sched_list);
> +		printk(KERN_INFO "SCTP %s registered\n", sched->name);
> +	}
> +	spin_unlock(&sctp_sched_list_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sctp_register_sched);
> +
> +/*
> + * Remove scheduling algorithm, called from
> + * the module's remove function.  Module ref counts are used
> + * to ensure that this can't be done till all sockets using
> + * that method are closed.
> + */
> +void sctp_unregister_sched(struct sctp_sched_ops *sched)
> +{
> +	spin_lock(&sctp_sched_list_lock);
> +	list_del_rcu(&sched->list);
> +	spin_unlock(&sctp_sched_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(sctp_unregister_sched);
> +
> +/* Manage refcounts on socket close. */
> +void sctp_cleanup_sched(struct sock *sk)
> +{
> +	module_put(sctp_sk(sk)->sched_ops->owner);
> +}
> +
> +/* Change scheduling algorithm for socket */
> +int sctp_set_sched(struct sock *sk, const char *name)
> +{
> +	struct sctp_sock *sp = sctp_sk(sk);
> +	struct sctp_sched_ops *sched;
> +	int err = 0;
> +
> +	rcu_read_lock();
> +	sched = sctp_sched_find(name);
> +
> +	/* no change asking for existing value */
> +	if (sched = sp->sched_ops)
> +		goto out;
> +
> +#ifdef CONFIG_MODULES
> +	/* not found attempt to autoload module */
> +	if (!sched && capable(CAP_NET_ADMIN)) {
> +		rcu_read_unlock();
> +		request_module("sctp_%s", name);
> +		rcu_read_lock();
> +		sched = sctp_sched_find(name);
> +	}
> +#endif
> +	if (!sched)
> +		err = -ENOENT;
> +
> +	else if (!try_module_get(sched->owner))
> +		err = -EBUSY;
> +
> +	else {
> +		sctp_cleanup_sched(sk);
> +		sp->sched_ops = sched;
> +	}
> +out:
> +	rcu_read_unlock();
> +	return err;
> +}
> +
> +static int fcfs_init(struct sctp_outq *q, gfp_t gfp)
> +{
> +	q->out_chunk_list = kmalloc(sizeof(struct list_head), gfp);
> +	if (!q->out_chunk_list)
> +		return -ENOMEM;
> +	INIT_LIST_HEAD(q->out_chunk_list);
> +
> +	return 0;
> +}
> +
> +static void fcfs_release(struct sctp_outq *q)
> +{
> +	kfree(q->out_chunk_list);
> +}
> +
> +static void fcfs_enqueue_head_data(struct sctp_outq *q,
> +					struct sctp_chunk *ch)
> +{
> +	list_add(&ch->list, q->out_chunk_list);
> +	q->out_qlen += ch->skb->len;
> +	return;
> +}
> +
> +static void fcfs_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
> +{
> +	list_add_tail(&ch->list, q->out_chunk_list);
> +	q->out_qlen += ch->skb->len;
> +	return;
> +}
> +
> +static struct sctp_chunk *fcfs_dequeue_data(struct sctp_outq *q)
> +{
> +	struct sctp_chunk *ch = NULL;
> +
> +	if (!list_empty(q->out_chunk_list)) {
> +		struct list_head *entry = q->out_chunk_list->next;
> +
> +		ch = list_entry(entry, struct sctp_chunk, list);
> +		list_del_init(entry);
> +		q->out_qlen -= ch->skb->len;
> +	}
> +	return ch;
> +}
> +
> +static inline int fcfs_is_empty(struct sctp_outq *q)
> +{
> +	return list_empty(q->out_chunk_list);
> +}
> +
> +struct sctp_sched_ops sctp_fcfs = {
> +	.name			= "fcfs",
> +	.owner			= THIS_MODULE,
> +	.init			= fcfs_init,
> +	.release		= fcfs_release,
> +	.enqueue_head_data	= fcfs_enqueue_head_data,
> +	.enqueue_tail_data	= fcfs_enqueue_tail_data,
> +	.dequeue_data		= fcfs_dequeue_data,
> +	.is_empty		= fcfs_is_empty,
> +};
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index ca44917..7d461be 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3644,6 +3644,9 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
>  	sp->initmsg.sinit_max_attempts   = sctp_max_retrans_init;
>  	sp->initmsg.sinit_max_init_timeo = sctp_rto_max;
> 
> +	/* Initialize default multistream scheduling algorithm */
> +	sp->sched_ops = sctp_default_sched_ops;
> +
>  	/* Initialize default RTO related parameters.  These parameters can
>  	 * be modified for with the SCTP_RTOINFO socket option.
>  	 */

