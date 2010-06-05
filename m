From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sat, 05 Jun 2010 20:03:07 +0000
Subject: Re: [PATCH 5/6] sctp multistream scheduling: a sample priority queue
Message-Id: <AANLkTik5jr2ciX_7sT2uHIsNraZf-d0P_0HBLhln2RMT@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTikV9RSoTIjUNARyrXHG-BdulDR5zIdk8dIVVOHI@mail.gmail.com>
	<4C07D30C.5090101@hp.com>
In-Reply-To: <4C07D30C.5090101@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:06 AM, Vlad Yasevich <vladislav.yasevich@hp.com> w=
rote:
>
>
> Yaogong Wang wrote:
>> A sample priority queue scheduling module that uses our interface
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/Kconfig p5/net/sctp/Kconfig
>> --- p4/net/sctp/Kconfig =A0 =A0 =A0 2010-05-28 11:48:55.000000000 -0700
>> +++ p5/net/sctp/Kconfig =A0 =A0 =A0 2010-05-28 14:43:17.000000000 -0700
>> @@ -37,6 +37,12 @@ menuconfig IP_SCTP
>>
>> =A0if IP_SCTP
>>
>> +config SCTP_SCHED_PRIO
>> + =A0 =A0 tristate "SCTP Multistream Scheduling: Priority Queue"
>> + =A0 =A0 default m
>> + =A0 =A0 help
>> + =A0 =A0 =A0 Use priority queue to schedule among multiple streams
>> +
>> =A0config SCTP_DBG_MSG
>> =A0 =A0 =A0 bool "SCTP: Debug messages"
>> =A0 =A0 =A0 help
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/Makefile p5/net/sctp/Makefile
>> --- p4/net/sctp/Makefile =A0 =A0 =A02010-05-28 11:48:55.000000000 -0700
>> +++ p5/net/sctp/Makefile =A0 =A0 =A02010-05-28 14:48:08.000000000 -0700
>> @@ -11,6 +11,7 @@ sctp-y :=3D sm_statetable.o sm_statefuns.o
>> =A0 =A0 =A0 =A0 tsnmap.o bind_addr.o socket.o primitive.o \
>> =A0 =A0 =A0 =A0 output.o input.o debug.o ssnmap.o auth.o sched.o
>>
>> +obj-$(CONFIG_SCTP_SCHED_PRIO) +=3D sctp_prio.o
>> =A0sctp-$(CONFIG_SCTP_DBG_OBJCNT) +=3D objcnt.o
>> =A0sctp-$(CONFIG_PROC_FS) +=3D proc.o
>> =A0sctp-$(CONFIG_SYSCTL) +=3D sysctl.o
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p4/net/sctp/sctp_prio.c p5/net/sctp/sctp_prio.c
>> --- p4/net/sctp/sctp_prio.c =A0 1969-12-31 16:00:00.000000000 -0800
>> +++ p5/net/sctp/sctp_prio.c =A0 2010-06-02 13:09:33.000000000 -0700
>> @@ -0,0 +1,108 @@
>> +/*
>> + * Priority queue scheduling among multiple SCTP streams
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/list.h>
>> +#include <net/sctp/sctp.h>
>> +
>> +static int zero_high_prio =3D 1;
>> +module_param(zero_high_prio, int, 0644);
>> +MODULE_PARM_DESC(zero_high_prio, "zero indicates highest priority?");
>> +
>> +static int prio_init(struct sctp_outq *q, gfp_t gfp)
>> +{
>> + =A0 =A0 __u16 i;
>> + =A0 =A0 q->out_chunk_list =3D kmalloc(q->asoc->c.sinit_num_ostreams
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* sizeof(st=
ruct list_head), gfp);
>
> This could end up wasting quite a lot of space since the queue is initial=
ized
> prior to ostreams negotiation.
>

I agree. Refer to my discussion on the design issue of when to set the
socket option.

>
>> + =A0 =A0 if (!q->out_chunk_list)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 for (i =3D 0; i < q->asoc->c.sinit_num_ostreams; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&q->out_chunk_list[i]);
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static void prio_release(struct sctp_outq *q)
>> +{
>> + =A0 =A0 kfree(q->out_chunk_list);
>> + =A0 =A0 return;
>> +}
>> +
>> +static void prio_enqueue_head_data(struct sctp_outq *q,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 struct sctp_chunk *ch)
>> +{
>> + =A0 =A0 list_add(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]=
);
>> + =A0 =A0 q->out_qlen +=3D ch->skb->len;
>> + =A0 =A0 return;
>> +}
>> +
>> +static void prio_enqueue_tail_data(struct sctp_outq *q, struct sctp_chu=
nk *ch)
>> +{
>> + =A0 =A0 list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_st=
ream]);
>> + =A0 =A0 q->out_qlen +=3D ch->skb->len;
>> + =A0 =A0 return;
>> +}
>> +
>> +static struct sctp_chunk *prio_dequeue_data(struct sctp_outq *q)
>> +{
>> + =A0 =A0 struct sctp_chunk *ch =3D NULL;
>> + =A0 =A0 __u16 prio =3D 0, i, cur =3D 0;
>> + =A0 =A0 int flag =3D 0;
>> +
>> + =A0 =A0 for (i =3D 0; i < q->asoc->c.sinit_num_ostreams; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!list_empty(&q->out_chunk_list[i]) && (fla=
g =3D 0
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 || (zero_high_prio ? q->asoc->=
sched_priv[i] < prio
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : q->asoc->sched_priv[i] > pri=
o))) {
>
> Can you please simplify this conditional. =A0Also, the logical operands
> typically end the line, not start it.

will do it

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur =3D i;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flag =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio =3D q->as=
oc->sched_priv[i];
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>
> It might be nice to cache the asoc so you don't have to keep dereferencin=
g the
> queue.
>

If I move sched_ops from sctp_association to sctp_outq as per your
suggestion, the problem is automatically solved.

> Also, isn't there a strong starvation possibility if a higher priority qu=
eue
> gets most of data?
>

Yes, starvation is possible in this algorithm. However, the philosophy
is that, as the user chooses the scheduling algorithm, he should be
aware of this. If he doesn't want this, he may use other scheduling
algorithms or implement his own. We provide mechanism. The user
decides his policy.

Yaogong

> -vlad
>
>> + =A0 =A0 if (flag) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct list_head *entry =3D q->out_chunk_list[=
cur].next;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ch =3D list_entry(entry, struct sctp_chunk, li=
st);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(entry);
>> + =A0 =A0 =A0 =A0 =A0 =A0 q->out_qlen -=3D ch->skb->len;
>> + =A0 =A0 }
>> + =A0 =A0 return ch;
>> +}
>> +
>> +static inline int prio_is_empty(struct sctp_outq *q)
>> +{
>> + =A0 =A0 __u16 i;
>> + =A0 =A0 for (i =3D 0; i < q->asoc->c.sinit_num_ostreams; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!list_empty(&q->out_chunk_list[i]))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 return 1;
>> +}
>> +
>> +static struct sctp_sched_ops sctp_prio =3D {
>> + =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D "prio",
>> + =A0 =A0 .owner =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D THIS_MODULE,
>> + =A0 =A0 .init =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D prio_init,
>> + =A0 =A0 .release =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D prio_release,
>> + =A0 =A0 .enqueue_head_data =A0 =A0 =A0=3D prio_enqueue_head_data,
>> + =A0 =A0 .enqueue_tail_data =A0 =A0 =A0=3D prio_enqueue_tail_data,
>> + =A0 =A0 .dequeue_data =A0 =A0 =A0 =A0 =A0 =3D prio_dequeue_data,
>> + =A0 =A0 .is_empty =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D prio_is_empty,
>> +};
>> +
>> +static int __init sctp_prio_register(void)
>> +{
>> + =A0 =A0 return sctp_register_sched(&sctp_prio);
>> +}
>> +
>> +static void __exit sctp_prio_unregister(void)
>> +{
>> + =A0 =A0 sctp_unregister_sched(&sctp_prio);
>> +}
>> +
>> +module_init(sctp_prio_register);
>> +module_exit(sctp_prio_unregister);
>> +
>> +MODULE_AUTHOR("Yaogong Wang");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("SCTP Multistream Scheduling: Priority Queue");
>>
>
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
