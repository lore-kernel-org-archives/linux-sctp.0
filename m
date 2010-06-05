From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sat, 05 Jun 2010 19:11:38 +0000
Subject: Re: [PATCH 1/6] sctp multistream scheduling: declare sctp_sched_ops
Message-Id: <AANLkTilnetlpc8IAkw9v072PZBAlVrdkXo9eKIeQw7Iu@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilgantV3v0T1-ef6ewyinddzfOs1PZW1Re9ZAyQ@mail.gmail.com>
	<4C07C3B8.7020003@hp.com>
In-Reply-To: <4C07C3B8.7020003@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org

I agree that it's clearer to put sched_ops in sctp_outq. That way, the
data structure and the operations on it are put together. I'll make
the required changes.

Yaogong

On Thu, Jun 3, 2010 at 8:01 AM, Vlad Yasevich <vladislav.yasevich@hp.com> w=
rote:
>
>
> Yaogong Wang wrote:
>> Declare sctp_sched_ops structure and related functions
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> linux-2.6.32.8/include/net/sctp/structs.h
>> p1/include/net/sctp/structs.h
>> --- linux-2.6.32.8/include/net/sctp/structs.h 2010-02-09
>> 04:57:19.000000000 -0800
>> +++ p1/include/net/sctp/structs.h =A0 =A0 2010-05-28 10:33:12.000000000 =
-0700
>> @@ -320,6 +320,9 @@ struct sctp_sock {
>> =A0 =A0 =A0 /* Flags controlling Heartbeat, SACK delay, and Path MTU Dis=
covery. */
>> =A0 =A0 =A0 __u32 param_flags;
>>
>> + =A0 =A0 /* Multistream scheduling =A0*/
>> + =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> +
>> =A0 =A0 =A0 struct sctp_initmsg initmsg;
>> =A0 =A0 =A0 struct sctp_rtoinfo rtoinfo;
>> =A0 =A0 =A0 struct sctp_paddrparams paddrparam;
>> @@ -534,6 +537,36 @@ static inline void sctp_ssn_skip(struct
>> =A0}
>>
>
> BTW, is there a reason you decided to through the sched_ops into the asso=
ciation
> and not the queue? =A0I seems to make more sense to me to put one into th=
e other.
>
> -vlad
>
>> =A0/*
>> + * Interface for adding new SCTP scheduling handlers
>> + * This is similar to the pluggable TCP congestion control
>> + */
>> +struct sctp_sched_ops {
>> + =A0 =A0 struct list_head =A0 =A0 =A0 =A0list;
>> +
>> + =A0 =A0 /* initialize out_chunk_list (required) */
>> + =A0 =A0 int (*init)(struct sctp_outq *q, gfp_t gfp);
>> + =A0 =A0 /* cleanup out_chunk_list (required) */
>> + =A0 =A0 void (*release)(struct sctp_outq *q);
>> + =A0 =A0 /* enqueue head function (required) */
>> + =A0 =A0 void (*enqueue_head_data)(struct sctp_outq *q, struct sctp_chu=
nk *ch);
>> + =A0 =A0 /* enqueue tail function (required) */
>> + =A0 =A0 void (*enqueue_tail_data)(struct sctp_outq *q, struct sctp_chu=
nk *ch);
>> + =A0 =A0 /* dequeue function (required) */
>> + =A0 =A0 struct sctp_chunk* (*dequeue_data)(struct sctp_outq *q);
>> + =A0 =A0 /* is out_chunk_list empty? (required) */
>> + =A0 =A0 int (*is_empty)(struct sctp_outq *q);
>> +
>> + =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0name[SCTP_SCHED_NAME_MAX];
>> + =A0 =A0 struct module =A0 *owner;
>> +};
>> +
>> +extern int sctp_register_sched(struct sctp_sched_ops *type);
>> +extern void sctp_unregister_sched(struct sctp_sched_ops *type);
>> +
>> +extern void sctp_cleanup_sched(struct sock *sk);
>> +extern int sctp_set_sched(struct sock *sk, const char *name);
>> +
>> +/*
>> =A0 * Pointers to address related SCTP functions.
>> =A0 * (i.e. things that depend on the address family.)
>> =A0 */
>> @@ -1650,6 +1683,9 @@ struct sctp_association {
>> =A0 =A0 =A0 /* The largest timeout or RTO value to use in attempting an =
INIT */
>> =A0 =A0 =A0 unsigned long max_init_timeo;
>>
>> + =A0 =A0 /* Multistream scheduling =A0*/
>> + =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> +
>> =A0 =A0 =A0 /* Heartbeat interval: The endpoint sends out a Heartbeat ch=
unk to
>> =A0 =A0 =A0 =A0* the destination address every heartbeat interval. This =
value
>> =A0 =A0 =A0 =A0* will be inherited by all new transports.
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> linux-2.6.32.8/include/net/sctp/user.h p1/include/net/sctp/user.h
>> --- linux-2.6.32.8/include/net/sctp/user.h =A0 =A02010-02-09 04:57:19.00=
0000000 -0800
>> +++ p1/include/net/sctp/user.h =A0 =A0 =A0 =A02010-05-28 10:52:57.000000=
000 -0700
>> @@ -171,6 +171,8 @@ struct sctp_initmsg {
>> =A0 =A0 =A0 __u16 sinit_max_init_timeo;
>> =A0};
>>
>> +#define SCTP_SCHED_NAME_MAX =A016
>> +
>> =A0/*
>> =A0 * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>> =A0 *
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
