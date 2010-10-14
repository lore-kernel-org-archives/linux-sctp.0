From: Yaogong Wang <ywang15@ncsu.edu>
Date: Thu, 14 Oct 2010 18:07:26 +0000
Subject: Re: [PATCHv2 4/5] sctp: a sample module of strict priority queue
Message-Id: <AANLkTimnQboEwHV5LWvEa46LrRpwxmrWscJ2xGjO-Qjx@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=8ArxUh2-8PJvD8paDGVBHdDjKk=xQDKo6i2==@mail.gmail.com>
	<4CB56F7A.8030702@cn.fujitsu.com>
In-Reply-To: <4CB56F7A.8030702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 4:36 AM, Shan Wei <shanwei@cn.fujitsu.com> wrote:
> Yaogong Wang wrote, at 09/12/2010 09:13 AM:
>> Provide a sample kernel module that uses the pluggable multistream
>> scheduling framework. This module implements strict priority queue.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> =A0net/sctp/Kconfig =A0 =A0 | =A0 12 ++++++
>> =A0net/sctp/Makefile =A0 =A0| =A0 =A01 +
>> =A0net/sctp/sctp_prio.c | =A0103 +++++++++++++++++++++++++++++++++++++++=
+++++++++++
>> =A03 files changed, 116 insertions(+), 0 deletions(-)
>> =A0create mode 100644 net/sctp/sctp_prio.c
>>
>> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
>> index 126b014..85c8ded 100644
>> --- a/net/sctp/Kconfig
>> +++ b/net/sctp/Kconfig
>> @@ -37,6 +37,18 @@ menuconfig IP_SCTP
>>
>> =A0if IP_SCTP
>>
>> +config SCTP_SCHED_PRIO
>> + =A0 =A0 tristate "SCTP Multistream Scheduling: Priority Queue"
>> + =A0 =A0 default m
>> + =A0 =A0 help
>> + =A0 =A0 =A0 This module provides the ability to use priority queue
>> + =A0 =A0 =A0 to schedule multiple streams within an association.
>> +
>> + =A0 =A0 =A0 To compile this code as a module, choose M here: the
>> + =A0 =A0 =A0 module will be called sctp_prio.
>> +
>> + =A0 =A0 =A0 If in doubt, say N.
>> +
>> =A0config NET_SCTPPROBE
>> =A0 =A0 =A0 tristate "SCTP: Association probing"
>> =A0 =A0 =A0 =A0 =A0depends on PROC_FS && KPROBES
>> diff --git a/net/sctp/Makefile b/net/sctp/Makefile
>> index 4e8b65d..89be03a 100644
>> --- a/net/sctp/Makefile
>> +++ b/net/sctp/Makefile
>> @@ -4,6 +4,7 @@
>>
>> =A0obj-$(CONFIG_IP_SCTP) +=3D sctp.o
>> =A0obj-$(CONFIG_NET_SCTPPROBE) +=3D sctp_probe.o
>> +obj-$(CONFIG_SCTP_SCHED_PRIO) +=3D sctp_prio.o
>>
>> =A0sctp-y :=3D sm_statetable.o sm_statefuns.o sm_sideeffect.o \
>> =A0 =A0 =A0 =A0 protocol.o endpointola.o associola.o \
>> diff --git a/net/sctp/sctp_prio.c b/net/sctp/sctp_prio.c
>> new file mode 100644
>> index 0000000..11e7e11
>> --- /dev/null
>> +++ b/net/sctp/sctp_prio.c
>> @@ -0,0 +1,103 @@
>> +/*
>> + * SCTP multistream scheduling: priority queue
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/list.h>
>> +#include <net/sctp/sctp.h>
>> +
>> +static int prio_init(struct sctp_outq *q, gfp_t gfp)
>> +{
>> + =A0 =A0 __u16 i;
>> + =A0 =A0 q->out_chunk_list =3D kmalloc(q->asoc->c.sinit_num_ostreams
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* sizeof(st=
ruct list_head), gfp);
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
>
> User can using SCTP_SNDRCV option to specific stream number.
> So, It is necessary to check stream number with q->asoc->c.sinit_num_ostr=
eams.

Isn't this check already performed in sctp_sendmsg() before it comes
to sctp_outq?

>
>> + =A0 =A0 q->out_qlen +=3D ch->skb->len;
>> + =A0 =A0 return;
>> +}
>> +
>> +static void prio_enqueue_tail_data(struct sctp_outq *q, struct sctp_chu=
nk *ch)
>> +{
>> + =A0 =A0 list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_st=
ream]);
>
> need to check too.
>
>
>
> --
> Best Regards
> -----
> Shan Wei
>
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
