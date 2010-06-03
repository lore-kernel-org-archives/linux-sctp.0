From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 03 Jun 2010 16:07:00 +0000
Subject: Re: [PATCH 6/6] sctp multistream scheduling: a sample weighted fair
Message-Id: <4C07D324.3070304@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilqwskt5fS2Yc2pa32IMA7QgDdn5latnAkyPpvZ@mail.gmail.com>
In-Reply-To: <AANLkTilqwskt5fS2Yc2pa32IMA7QgDdn5latnAkyPpvZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yaogong Wang <ywang15@ncsu.edu>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org



Yaogong Wang wrote:
> A sample weighted fair queue scheduling module that uses our interface
> 
> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
> ---
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p5/include/net/sctp/structs.h p6/include/net/sctp/structs.h
> --- p5/include/net/sctp/structs.h	2010-06-02 12:58:41.000000000 -0700
> +++ p6/include/net/sctp/structs.h	2010-05-28 15:09:31.000000000 -0700
> @@ -1693,6 +1693,7 @@ struct sctp_association {
> 
>  	/* Multistream scheduling  */
>  	const struct sctp_sched_ops *sched_ops;
> +	__u16 *sched_internal;
>  	__u32 sched_priv_len;
>  	__u16 *sched_priv;

I am really not liking this pollution of sctp_association.

You need to come up with a model where each scheduling algo can have
it's own structure that it knows how to use.

Then if the user wants to change how each algorithm behavies (like stream
priorities, etc), then each algorithm should implement an API for the user
to call.

A generic socket API is to change the algorithm on the socket and/or
association.  Once you do that.  The user has to call the algo specific
API to set up priorities.

-vlad

> 
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p5/net/sctp/Kconfig p6/net/sctp/Kconfig
> --- p5/net/sctp/Kconfig	2010-05-28 14:43:17.000000000 -0700
> +++ p6/net/sctp/Kconfig	2010-05-28 15:10:30.000000000 -0700
> @@ -43,6 +43,12 @@ config SCTP_SCHED_PRIO
>  	help
>  	  Use priority queue to schedule among multiple streams
> 
> +config SCTP_SCHED_WFQ
> +	tristate "SCTP Multistream Scheduling: Weighted Fair Queue"
> +	default m
> +	help
> +	  Use weighted fair queue to schedule among multiple streams
> +
>  config SCTP_DBG_MSG
>  	bool "SCTP: Debug messages"
>  	help
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p5/net/sctp/Makefile p6/net/sctp/Makefile
> --- p5/net/sctp/Makefile	2010-05-28 14:48:08.000000000 -0700
> +++ p6/net/sctp/Makefile	2010-05-28 15:11:02.000000000 -0700
> @@ -12,6 +12,7 @@ sctp-y := sm_statetable.o sm_statefuns.o
>  	  output.o input.o debug.o ssnmap.o auth.o sched.o
> 
>  obj-$(CONFIG_SCTP_SCHED_PRIO) += sctp_prio.o
> +obj-$(CONFIG_SCTP_SCHED_WFQ) += sctp_wfq.o
>  sctp-$(CONFIG_SCTP_DBG_OBJCNT) += objcnt.o
>  sctp-$(CONFIG_PROC_FS) += proc.o
>  sctp-$(CONFIG_SYSCTL) += sysctl.o
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p5/net/sctp/associola.c p6/net/sctp/associola.c
> --- p5/net/sctp/associola.c	2010-06-02 12:58:27.000000000 -0700
> +++ p6/net/sctp/associola.c	2010-05-28 15:09:37.000000000 -0700
> @@ -195,6 +195,7 @@ static struct sctp_association *sctp_ass
>  		memcpy(asoc->sched_priv, sp->sched_priv, asoc->sched_priv_len);
>  	} else
>  		asoc->sched_priv = NULL;
> +	asoc->sched_internal = NULL;
> 
>  	/* Allocate storage for the ssnmap after the inbound and outbound
>  	 * streams have been negotiated during Init.
> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
> p5/net/sctp/sctp_wfq.c p6/net/sctp/sctp_wfq.c
> --- p5/net/sctp/sctp_wfq.c	1969-12-31 16:00:00.000000000 -0800
> +++ p6/net/sctp/sctp_wfq.c	2010-06-02 13:10:05.000000000 -0700
> @@ -0,0 +1,150 @@
> +/*
> + * Weighted fair queue scheduling among multiple SCTP streams
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <net/sctp/sctp.h>
> +
> +static int quantum = 1500;
> +module_param(quantum, int, 0644);
> +MODULE_PARM_DESC(quantum, "quantum in bytes");
> +
> +/*
> + * Weighted fair queue internal data structure
> + *
> + * implemented using deficit round robin technique
> + */
> +struct wfq {
> +	__u16	rr_ptr;
> +	__u16	deficit[0];
> +};
> +
> +static int wfq_init(struct sctp_outq *q, gfp_t gfp)
> +{
> +	__u16 i;
> +	struct wfq *internal;
> +
> +	/* initiate out_chunk_list  */
> +	q->out_chunk_list = kmalloc(q->asoc->c.sinit_num_ostreams
> +				 * sizeof(struct list_head), gfp);
> +	if (!q->out_chunk_list)
> +		return -ENOMEM;
> +	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
> +		INIT_LIST_HEAD(&q->out_chunk_list[i]);
> +
> +	/* initiate internal data structure  */
> +	q->asoc->sched_internal = kmalloc(q->asoc->sched_priv_len
> +						+ sizeof(__u16), gfp);
> +	if (!q->asoc->sched_internal) {
> +		kfree(q->out_chunk_list);
> +		return -ENOMEM;
> +	}
> +	internal = (struct wfq *)q->asoc->sched_internal;
> +	internal->rr_ptr = 0;
> +	internal->deficit[0] = q->asoc->sched_priv[0] * quantum;
> +	for (i = 1; i < q->asoc->c.sinit_num_ostreams; i++)
> +		internal->deficit[i] = 0;
> +
> +	return 0;
> +}
> +
> +static void wfq_release(struct sctp_outq *q)
> +{
> +	kfree(q->out_chunk_list);
> +	kfree(q->asoc->sched_internal);
> +	return;
> +}
> +
> +static void wfq_enqueue_head_data(struct sctp_outq *q,
> +					struct sctp_chunk *ch)
> +{
> +	list_add(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
> +	q->out_qlen += ch->skb->len;
> +	return;
> +}
> +
> +static void wfq_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
> +{
> +	list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
> +	q->out_qlen += ch->skb->len;
> +	return;
> +}
> +
> +static struct sctp_chunk *wfq_dequeue_data(struct sctp_outq *q)
> +{
> +	struct sctp_chunk *ch = NULL;
> +	struct wfq *internal = (struct wfq *)q->asoc->sched_internal;
> +	__u16 i, cur = 0;
> +	int flag = 0, hasdata = 0;
> +
> +	for (i = 0; i < q->asoc->c.sinit_num_ostreams || hasdata; i++) {
> +		if (!list_empty(&q->out_chunk_list[internal->rr_ptr])) {
> +			hasdata = 1;
> +			struct list_head *tmp_entry > +				q->out_chunk_list[internal->rr_ptr].next;
> +			struct sctp_chunk *tmp_ch > +				list_entry(tmp_entry, struct sctp_chunk, list);
> +			if (tmp_ch->skb->len <> +				internal->deficit[internal->rr_ptr]) {
> +				internal->deficit[internal->rr_ptr] -> +					tmp_ch->skb->len;
> +				cur = internal->rr_ptr;
> +				flag = 1;
> +				break;
> +			}
> +		} else {
> +			internal->deficit[internal->rr_ptr] = 0;
> +		}
> +		internal->rr_ptr = (internal->rr_ptr + 1)
> +						% q->asoc->c.sinit_num_ostreams;
> +		internal->deficit[internal->rr_ptr] +> +				q->asoc->sched_priv[internal->rr_ptr] * quantum;
> +	}
> +
> +	if (flag) {
> +		struct list_head *entry = q->out_chunk_list[cur].next;
> +		ch = list_entry(entry, struct sctp_chunk, list);
> +		list_del_init(entry);
> +		q->out_qlen -= ch->skb->len;
> +	}
> +	return ch;
> +}
> +
> +static inline int wfq_is_empty(struct sctp_outq *q)
> +{
> +	__u16 i;
> +	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
> +		if (!list_empty(&q->out_chunk_list[i]))
> +			return 0;
> +	return 1;
> +}
> +
> +static struct sctp_sched_ops sctp_wfq = {
> +	.name			= "wfq",
> +	.owner			= THIS_MODULE,
> +	.init			= wfq_init,
> +	.release		= wfq_release,
> +	.enqueue_head_data	= wfq_enqueue_head_data,
> +	.enqueue_tail_data	= wfq_enqueue_tail_data,
> +	.dequeue_data		= wfq_dequeue_data,
> +	.is_empty		= wfq_is_empty,
> +};
> +
> +static int __init sctp_wfq_register(void)
> +{
> +	return sctp_register_sched(&sctp_wfq);
> +}
> +
> +static void __exit sctp_wfq_unregister(void)
> +{
> +	sctp_unregister_sched(&sctp_wfq);
> +}
> +
> +module_init(sctp_wfq_register);
> +module_exit(sctp_wfq_unregister);
> +
> +MODULE_AUTHOR("Yaogong Wang");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("SCTP Multistream Scheduling: Weighted Fair Queue");
> 

