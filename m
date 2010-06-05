From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sat, 05 Jun 2010 19:57:21 +0000
Subject: Re: [PATCH 4/6] sctp multistream scheduling: extend socket API
Message-Id: <AANLkTims45bo9pv2hZmdjbUuEyVpFDj2zqjfIybE1RZD@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>
	<4C0764F7.7030300@cn.fujitsu.com>
	<4C07BF9B.4000301@hp.com>
In-Reply-To: <4C07BF9B.4000301@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org

With regard to sched_priv and sched_internal, here are some explanations:

sched_priv: Parameters of a scheduling algorithm that should be
configured by the user. For example, the weight of each stream in WFQ
or the priority of each stream in priority queue.

sched_internal: Internal states used by a scheduling algorithm. Not
all algorithms need it. For example, memoryless algorithms such as
priority queue don't need it. Priority queue only look at the current
state and pick the highest priority chunk available. But for WFQ, we
need to store the remaining token of each stream in sched_internal. We
also need to memorize who is scheduled last time.

In the current design, sched_priv is specific to a socket. Even if two
sockets both use WFQ, they may set different weights for different
streams. sched_internal is specific to each association/queue. Even if
two associations use the same scheduling algorithm with exactly the
same configuration, the internal states are separate.

I cannot move these states in to sched_ops since sched_ops is specific
to each scheduling algorithm.

Yaogong

On Thu, Jun 3, 2010 at 7:43 AM, Vlad Yasevich <vladislav.yasevich@hp.com> w=
rote:
>
>
> Wei Yongjun wrote:
>>> Augment SCTP socket API with a new socket option to choose and
>>> configure scheduling algorithm.
>>>
>>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>>> ---
>>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>>> p3/include/net/sctp/structs.h p4/include/net/sctp/structs.h
>>> --- p3/include/net/sctp/structs.h =A0 =A02010-06-02 12:57:24.000000000 =
-0700
>>> +++ p4/include/net/sctp/structs.h =A0 =A02010-06-02 12:58:11.000000000 =
-0700
>>> @@ -326,6 +326,8 @@ struct sctp_sock {
>>>
>>> =A0 =A0 =A0/* Multistream scheduling =A0*/
>>> =A0 =A0 =A0const struct sctp_sched_ops *sched_ops;
>>> + =A0 =A0__u32 sched_priv_len;
>>> + =A0 =A0__u16 *sched_priv;
>>>
>>> =A0 =A0 =A0struct sctp_initmsg initmsg;
>>> =A0 =A0 =A0struct sctp_rtoinfo rtoinfo;
>>> @@ -1691,6 +1693,8 @@ struct sctp_association {
>>>
>>> =A0 =A0 =A0/* Multistream scheduling =A0*/
>>> =A0 =A0 =A0const struct sctp_sched_ops *sched_ops;
>>> + =A0 =A0__u32 sched_priv_len;
>>> + =A0 =A0__u16 *sched_priv;
>>>
>>
>> I also see you add "__u16 *sched_internal;" to asoc, those are
>> the sche base values, and are different between sche.
>> The socket and assoc may not want to know the detail, raw data
>> is enough for them, and if we want to add a new sche, we do
>> not change the struct sctp_sock or struct sctp_association every
>> time.
>
> I agree. =A0These should probably go into sched_ops.
>
> -vlad
>
>>
>>> =A0 =A0 =A0/* Heartbeat interval: The endpoint sends out a Heartbeat ch=
unk to
>>> =A0 =A0 =A0 * the destination address every heartbeat interval. This va=
lue
>>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>>> p3/include/net/sctp/user.h p4/include/net/sctp/user.h
>>> --- p3/include/net/sctp/user.h =A0 =A0 =A0 2010-05-28 10:59:23.00000000=
0 -0700
>>> +++ p4/include/net/sctp/user.h =A0 =A0 =A0 2010-05-28 11:54:47.00000000=
0 -0700
>>> @@ -67,6 +67,8 @@ enum sctp_optname {
>>> =A0#define SCTP_ASSOCINFO SCTP_ASSOCINFO
>>> =A0 =A0 =A0SCTP_INITMSG,
>>> =A0#define SCTP_INITMSG SCTP_INITMSG
>>> + =A0 =A0SCTP_SCHED,
>>> +#define SCTP_SCHED SCTP_SCHED
>>> =A0 =A0 =A0SCTP_NODELAY, =A0 /* Get/set nodelay option. */
>>> =A0#define SCTP_NODELAY =A0 =A0 =A0 =A0SCTP_NODELAY
>>> =A0 =A0 =A0SCTP_AUTOCLOSE,
>>> @@ -171,8 +173,22 @@ struct sctp_initmsg {
>>> =A0 =A0 =A0__u16 sinit_max_init_timeo;
>>> =A0};
>>>
>>> +/*
>>> + * SCTP Scheduling Structure (SCTP_SCHED)
>>> + *
>>> + * =A0 cmsg_level =A0 =A0cmsg_type =A0 =A0 =A0cmsg_data[]
>>> + * =A0 ------------ =A0------------ =A0 ----------------------
>>> + * =A0 IPPROTO_SCTP =A0SCTP_SCHED =A0 =A0 struct sctp_sched
>>> + *
>>> + */
>>> =A0#define SCTP_SCHED_NAME_MAX 16
>>>
>>> +struct sctp_sched {
>>> + =A0 =A0char =A0ssched_name[SCTP_SCHED_NAME_MAX];
>>> + =A0 =A0__u32 ssched_priv_len;
>>> + =A0 =A0__u16 ssched_priv[0];
>>> +};
>>> +
>>> =A0/*
>>> =A0 * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>>> =A0 *
>>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>>> p3/net/sctp/associola.c p4/net/sctp/associola.c
>>> --- p3/net/sctp/associola.c =A02010-06-02 12:57:06.000000000 -0700
>>> +++ p4/net/sctp/associola.c =A02010-06-02 12:57:57.000000000 -0700
>>> @@ -187,6 +187,14 @@ static struct sctp_association *sctp_ass
>>>
>>> =A0 =A0 =A0/* Multistream scheduling =A0*/
>>> =A0 =A0 =A0asoc->sched_ops =3D sp->sched_ops;
>>> + =A0 =A0asoc->sched_priv_len =3D sp->sched_priv_len;
>>> + =A0 =A0if (asoc->sched_priv_len) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0asoc->sched_priv =3D kmalloc(asoc->sched_priv_=
len, gfp);
>>> + =A0 =A0 =A0 =A0 =A0 =A0if (!asoc->sched_priv)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail_init;
>>> + =A0 =A0 =A0 =A0 =A0 =A0memcpy(asoc->sched_priv, sp->sched_priv, asoc-=
>sched_priv_len);
>>> + =A0 =A0} else
>>> + =A0 =A0 =A0 =A0 =A0 =A0asoc->sched_priv =3D NULL;
>>>
>>> =A0 =A0 =A0/* Allocate storage for the ssnmap after the inbound and out=
bound
>>> =A0 =A0 =A0 * streams have been negotiated during Init.
>>> @@ -464,6 +472,8 @@ static void sctp_association_destroy(str
>>> =A0{
>>> =A0 =A0 =A0SCTP_ASSERT(asoc->base.dead, "Assoc is not dead", return);
>>>
>>> + =A0 =A0kfree(asoc->sched_priv);
>>> +
>>> =A0 =A0 =A0sctp_endpoint_put(asoc->ep);
>>> =A0 =A0 =A0sock_put(asoc->base.sk);
>>>
>>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>>> p3/net/sctp/socket.c p4/net/sctp/socket.c
>>> --- p3/net/sctp/socket.c =A0 =A0 2010-05-28 12:38:09.000000000 -0700
>>> +++ p4/net/sctp/socket.c =A0 =A0 2010-05-28 12:36:37.000000000 -0700
>>> @@ -2580,6 +2580,50 @@ static int sctp_setsockopt_initmsg(struc
>>> =A0 =A0 =A0return 0;
>>> =A0}
>>>
>>> +/* Set the multistream scheduling algorithm*/
>>> +static int sctp_setsockopt_sched(struct sock *sk, char __user *optval,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0unsigned int optlen)
>>> +{
>>> + =A0 =A0struct sctp_sched *ssched =3D NULL;
>>> + =A0 =A0struct sctp_sock *sp =3D sctp_sk(sk);
>>> + =A0 =A0int ret =3D 0;
>>> +
>>> + =A0 =A0if (optlen < sizeof(struct sctp_sched))
>>> + =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>>> +
>>> + =A0 =A0ssched =3D kmalloc(optlen, GFP_KERNEL);
>>> + =A0 =A0if (!ssched)
>>> + =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>>> +
>>> + =A0 =A0if (copy_from_user(ssched, optval, optlen)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EFAULT;
>>> + =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>> + =A0 =A0}
>>> +
>>> + =A0 =A0if (optlen !=3D sizeof(struct sctp_sched) + ssched->ssched_pri=
v_len) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EINVAL;
>>> + =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>> + =A0 =A0}
>>> +
>>> + =A0 =A0ret =3D sctp_set_sched(sk, ssched->ssched_name);
>>> + =A0 =A0if (ret)
>>> + =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>> + =A0 =A0sp->sched_priv_len =3D ssched->ssched_priv_len;
>>> + =A0 =A0kfree(sp->sched_priv);
>>> + =A0 =A0if (sp->sched_priv_len) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0sp->sched_priv =3D kmalloc(sp->sched_priv_len,=
 GFP_KERNEL);
>>> + =A0 =A0 =A0 =A0 =A0 =A0if (!sp->sched_priv) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>>> + =A0 =A0 =A0 =A0 =A0 =A0}
>>> + =A0 =A0 =A0 =A0 =A0 =A0memcpy(sp->sched_priv, ssched->ssched_priv, sp=
->sched_priv_len);
>>> + =A0 =A0}
>>> +
>>> +out:
>>> + =A0 =A0kfree(ssched);
>>> + =A0 =A0return ret;
>>> +}
>>> +
>>> =A0/*
>>> =A0 * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
>>> =A0 *
>>> @@ -3417,6 +3461,9 @@ SCTP_STATIC int sctp_setsockopt(struct s
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_setsockopt_partial_delivery_=
point(sk, optval, optlen);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>>>
>>> + =A0 =A0case SCTP_SCHED:
>>> + =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_setsockopt_sched(sk, optval, o=
ptlen);
>>> + =A0 =A0 =A0 =A0 =A0 =A0break;
>>> =A0 =A0 =A0case SCTP_INITMSG:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_setsockopt_initmsg(sk, optva=
l, optlen);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>>> @@ -3642,7 +3689,10 @@ SCTP_STATIC int sctp_init_sock(struct so
>>> =A0 =A0 =A0sp->initmsg.sinit_max_attempts =A0 =3D sctp_max_retrans_init;
>>> =A0 =A0 =A0sp->initmsg.sinit_max_init_timeo =3D sctp_rto_max;
>>>
>>> + =A0 =A0/* Initialize default scheduling algorithm =A0*/
>>> =A0 =A0 =A0sp->sched_ops =3D sctp_default_sched_ops;
>>> + =A0 =A0sp->sched_priv_len =3D 0;
>>> + =A0 =A0sp->sched_priv =3D NULL;
>>>
>>> =A0 =A0 =A0/* Initialize default RTO related parameters. =A0These param=
eters can
>>> =A0 =A0 =A0 * be modified for with the SCTP_RTOINFO socket option.
>>> @@ -3735,6 +3785,9 @@ SCTP_STATIC void sctp_destroy_sock(struc
>>>
>>> =A0 =A0 =A0SCTP_DEBUG_PRINTK("sctp_destroy_sock(sk: %p)\n", sk);
>>>
>>> + =A0 =A0sctp_cleanup_sched(sk);
>>> + =A0 =A0kfree(sctp_sk(sk)->sched_priv);
>>> +
>>> =A0 =A0 =A0/* Release our hold on the endpoint. */
>>> =A0 =A0 =A0ep =3D sctp_sk(sk)->ep;
>>> =A0 =A0 =A0sctp_endpoint_free(ep);
>>> @@ -4351,6 +4404,35 @@ static int sctp_getsockopt_initmsg(struc
>>> =A0 =A0 =A0return 0;
>>> =A0}
>>>
>>> +/* Get the multistream scheduling algorithm*/
>>> +static int sctp_getsockopt_sched(struct sock *sk, int len, char __user=
 *optval,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int __user *optlen)
>>> +{
>>> + =A0 =A0struct sctp_sched *ssched;
>>> + =A0 =A0int sz =3D sizeof(struct sctp_sched) + sctp_sk(sk)->sched_priv=
_len;
>>> + =A0 =A0int ret =3D 0;
>>> +
>>> + =A0 =A0if (len < sz)
>>> + =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>>> + =A0 =A0if (put_user(sz, optlen))
>>> + =A0 =A0 =A0 =A0 =A0 =A0return -EFAULT;
>>> +
>>> + =A0 =A0ssched =3D kmalloc(sz, GFP_KERNEL);
>>> + =A0 =A0if (!ssched)
>>> + =A0 =A0 =A0 =A0 =A0 =A0return -EFAULT;
>>> + =A0 =A0memcpy(ssched->ssched_name, sctp_sk(sk)->sched_ops->name,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0SCTP_SCHED_NAME_MAX);
>>> + =A0 =A0ssched->ssched_priv_len =3D sctp_sk(sk)->sched_priv_len;
>>> + =A0 =A0memcpy(ssched->ssched_priv, sctp_sk(sk)->sched_priv,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0ssched->ssched_priv_len);
>>> +
>>> + =A0 =A0if (copy_to_user(optval, ssched, sz))
>>> + =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EFAULT;
>>> +
>>> + =A0 =A0kfree(ssched);
>>> + =A0 =A0return ret;
>>> +}
>>> +
>>> =A0static int sctp_getsockopt_peer_addrs_num_old(struct sock *sk, int l=
en,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0char __user *optval,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0int __user *optlen)
>>> @@ -5605,6 +5687,9 @@ SCTP_STATIC int sctp_getsockopt(struct s
>>> =A0 =A0 =A0case SCTP_INITMSG:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_getsockopt_initmsg(sk, len, =
optval, optlen);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>>> + =A0 =A0case SCTP_SCHED:
>>> + =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_getsockopt_sched(sk, len, optv=
al, optlen);
>>> + =A0 =A0 =A0 =A0 =A0 =A0break;
>>> =A0 =A0 =A0case SCTP_GET_PEER_ADDRS_NUM_OLD:
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D sctp_getsockopt_peer_addrs_num_ol=
d(sk, len, optval,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0optlen);
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at =A0http://www.tux.org/lkml/
>>>
>>>
>>>
>>
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
