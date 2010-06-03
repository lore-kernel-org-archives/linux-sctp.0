From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 07:43:50 +0000
Subject: Re: [PATCH 2/6] sctp multistream scheduling: provide pluggable SCTP
Message-Id: <4C075D36.8030706@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTimanFQ-gbcqNnygBvuQiFUk0SJrKFxjiOEAlesi@mail.gmail.com>
In-Reply-To: <AANLkTimanFQ-gbcqNnygBvuQiFUk0SJrKFxjiOEAlesi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yaogong Wang <ywang15@ncsu.edu>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org


> Provide a general interface for implementing new SCTP multistream
> scheduling algorithms as kernel modules.
>
>   

after apply this patch, the SCTP will be broken, this will
broken git bisect.

> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
> ---
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p1/include/net/sctp/structs.h p2/include/net/sctp/structs.h
> --- p1/include/net/sctp/structs.h	2010-05-28 10:33:12.000000000 -0700
> +++ p2/include/net/sctp/structs.h	2010-06-02 13:02:14.000000000 -0700
> @@ -1158,7 +1158,7 @@ struct sctp_outq {
>  	struct sctp_association *asoc;
>
>  	/* Data pending that has never been transmitted.  */
> -	struct list_head out_chunk_list;
> +	struct list_head *out_chunk_list;
>
>  	unsigned out_qlen;	/* Total length of queued data chunks. */
>
> @@ -1199,7 +1199,7 @@ struct sctp_outq {
>  	char malloced;
>  };
>
> -void sctp_outq_init(struct sctp_association *, struct sctp_outq *);
> +int sctp_outq_init(struct sctp_association *, struct sctp_outq *, gfp_t gfp);
>  void sctp_outq_teardown(struct sctp_outq *);
>  void sctp_outq_free(struct sctp_outq*);
>  int sctp_outq_tail(struct sctp_outq *, struct sctp_chunk *chunk);
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p1/net/sctp/Makefile p2/net/sctp/Makefile
> --- p1/net/sctp/Makefile	2010-05-28 10:05:50.000000000 -0700
> +++ p2/net/sctp/Makefile	2010-06-02 12:55:13.000000000 -0700
> @@ -9,7 +9,7 @@ sctp-y := sm_statetable.o sm_statefuns.o
>  	  transport.o chunk.o sm_make_chunk.o ulpevent.o \
>  	  inqueue.o outqueue.o ulpqueue.o command.o \
>  	  tsnmap.o bind_addr.o socket.o primitive.o \
> -	  output.o input.o debug.o ssnmap.o auth.o
> +	  output.o input.o debug.o ssnmap.o auth.o sched.o
>
>  sctp-$(CONFIG_SCTP_DBG_OBJCNT) += objcnt.o
>  sctp-$(CONFIG_PROC_FS) += proc.o
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p1/net/sctp/associola.c p2/net/sctp/associola.c
> --- p1/net/sctp/associola.c	2010-05-28 10:05:50.000000000 -0700
> +++ p2/net/sctp/associola.c	2010-06-02 12:56:23.000000000 -0700
> @@ -185,6 +185,9 @@ static struct sctp_association *sctp_ass
>  	asoc->max_init_timeo >  		 msecs_to_jiffies(sp->initmsg.sinit_max_init_timeo);
>
> +	/* Multistream scheduling  */
> +	asoc->sched_ops = sp->sched_ops;
> +
>  	/* Allocate storage for the ssnmap after the inbound and outbound
>  	 * streams have been negotiated during Init.
>  	 */
> @@ -280,7 +283,9 @@ static struct sctp_association *sctp_ass
>  	sctp_inq_set_th_handler(&asoc->base.inqueue, sctp_assoc_bh_rcv);
>
>  	/* Create an output queue.  */
> -	sctp_outq_init(asoc, &asoc->outqueue);
> +	err = sctp_outq_init(asoc, &asoc->outqueue, gfp);
> +	if (err)
> +		goto fail_init;
>
>  	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
>  		goto fail_init;
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p1/net/sctp/outqueue.c p2/net/sctp/outqueue.c
> --- p1/net/sctp/outqueue.c	2010-05-28 10:05:50.000000000 -0700
> +++ p2/net/sctp/outqueue.c	2010-06-02 12:55:13.000000000 -0700
> @@ -73,38 +73,6 @@ static void sctp_generate_fwdtsn(struct
>
>  static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout);
>
> -/* Add data to the front of the queue. */
> -static inline void sctp_outq_head_data(struct sctp_outq *q,
> -					struct sctp_chunk *ch)
> -{
> -	list_add(&ch->list, &q->out_chunk_list);
> -	q->out_qlen += ch->skb->len;
> -	return;
> -}
> -
> -/* Take data from the front of the queue. */
> -static inline struct sctp_chunk *sctp_outq_dequeue_data(struct sctp_outq *q)
> -{
> -	struct sctp_chunk *ch = NULL;
> -
> -	if (!list_empty(&q->out_chunk_list)) {
> -		struct list_head *entry = q->out_chunk_list.next;
> -
> -		ch = list_entry(entry, struct sctp_chunk, list);
> -		list_del_init(entry);
> -		q->out_qlen -= ch->skb->len;
> -	}
> -	return ch;
> -}
> -/* Add data chunk to the end of the queue. */
> -static inline void sctp_outq_tail_data(struct sctp_outq *q,
> -				       struct sctp_chunk *ch)
> -{
> -	list_add_tail(&ch->list, &q->out_chunk_list);
> -	q->out_qlen += ch->skb->len;
> -	return;
> -}
> -
>  /*
>   * SFR-CACC algorithm:
>   * D) If count_of_newacks is greater than or equal to 2
> @@ -201,10 +169,15 @@ static inline int sctp_cacc_skip(struct
>   * You still need to define handlers if you really want to DO
>   * something with this structure...
>   */
> -void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
> +int sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q,
> +			gfp_t gfp)
>  {
> -	q->asoc = asoc;
> -	INIT_LIST_HEAD(&q->out_chunk_list);
> +	int err = 0;
> +
> +	q->asoc = asoc;
> +	err = q->asoc->sched_ops->init(q, gfp);
> +	if (err)
> +		goto fail_init;
>  	INIT_LIST_HEAD(&q->control_chunk_list);
>  	INIT_LIST_HEAD(&q->retransmit);
>  	INIT_LIST_HEAD(&q->sacked);
> @@ -217,6 +190,9 @@ void sctp_outq_init(struct sctp_associat
>
>  	q->malloced = 0;
>  	q->out_qlen = 0;
> +
> +fail_init:
> +	return err;
>  }
>
>  /* Free the outqueue structure and any related pending chunks.
> @@ -267,7 +243,7 @@ void sctp_outq_teardown(struct sctp_outq
>  	}
>
>  	/* Throw away any leftover data chunks. */
> -	while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
> +	while ((chunk = q->asoc->sched_ops->dequeue_data(q)) != NULL) {
>   

why not use sctp_outq_dequeue_data() as help function
instead of direct using q->asoc->sched_ops->dequeue_data()?
and also the others.

>  		/* Mark as send failure. */
>  		sctp_chunk_fail(chunk, q->error);
> @@ -289,6 +265,8 @@ void sctp_outq_free(struct sctp_outq *q)
>  	/* Throw away leftover chunks. */
>  	sctp_outq_teardown(q);
>
> +	q->asoc->sched_ops->release(q);
> +
>  	/* If we were kmalloc()'d, free the memory.  */
>  	if (q->malloced)
>  		kfree(q);
> @@ -334,7 +312,7 @@ int sctp_outq_tail(struct sctp_outq *q,
>  			  sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type))
>  			  : "Illegal Chunk");
>
> -			sctp_outq_tail_data(q, chunk);
> +			q->asoc->sched_ops->enqueue_tail_data(q, chunk);
>  			if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
>  				SCTP_INC_STATS(SCTP_MIB_OUTUNORDERCHUNKS);
>  			else
> @@ -922,7 +900,7 @@ static int sctp_outq_flush(struct sctp_o
>  		}
>
>  		/* Finally, transmit new packets.  */
> -		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
> +		while ((chunk = q->asoc->sched_ops->dequeue_data(q)) != NULL) {
>  			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
>  			 * stream identifier.
>  			 */
> @@ -996,7 +974,7 @@ static int sctp_outq_flush(struct sctp_o
>  					"not transmit TSN: 0x%x, status: %d\n",
>  					ntohl(chunk->subh.data_hdr->tsn),
>  					status);
> -				sctp_outq_head_data(q, chunk);
> +				q->asoc->sched_ops->enqueue_head_data(q, chunk);
>  				goto sctp_flush_out;
>  				break;
>
> @@ -1252,7 +1230,7 @@ int sctp_outq_sack(struct sctp_outq *q,
>  	/* See if all chunks are acked.
>  	 * Make sure the empty queue handler will get run later.
>  	 */
> -	q->empty = (list_empty(&q->out_chunk_list) &&
> +	q->empty = (q->asoc->sched_ops->is_empty(q) &&
>  		    list_empty(&q->retransmit));
>  	if (!q->empty)
>  		goto finish;
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p1/net/sctp/sched.c p2/net/sctp/sched.c
> --- p1/net/sctp/sched.c	1969-12-31 16:00:00.000000000 -0800
> +++ p2/net/sctp/sched.c	2010-06-02 12:59:40.000000000 -0700
> @@ -0,0 +1,116 @@
> +/*
> + * Plugable SCTP scheduling support and FCFS
> + * Based on ideas from pluggable TCP congestion control.
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
> +	/* all algorithms must implement enqueue and dequeue ops */
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
