From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sat, 05 Jun 2010 19:40:51 +0000
Subject: Re: [PATCH 4/6] sctp multistream scheduling: extend socket API
Message-Id: <AANLkTilGROAVnKE5odR6qy6LrVjPSHxkqCrPhAtHtjlQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>
	<4C07C927.4090901@hp.com>
In-Reply-To: <4C07C927.4090901@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 8:24 AM, Vlad Yasevich <vladislav.yasevich@hp.com> w=
rote:
>
>
> Yaogong Wang wrote:
>> Augment SCTP socket API with a new socket option to choose and
>> configure scheduling algorithm.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p3/include/net/sctp/structs.h p4/include/net/sctp/structs.h
>> --- p3/include/net/sctp/structs.h =A0 =A0 2010-06-02 12:57:24.000000000 =
-0700
>> +++ p4/include/net/sctp/structs.h =A0 =A0 2010-06-02 12:58:11.000000000 =
-0700
>> @@ -326,6 +326,8 @@ struct sctp_sock {
>>
>> =A0 =A0 =A0 /* Multistream scheduling =A0*/
>> =A0 =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> + =A0 =A0 __u32 sched_priv_len;
>> + =A0 =A0 __u16 *sched_priv;
>>
>> =A0 =A0 =A0 struct sctp_initmsg initmsg;
>> =A0 =A0 =A0 struct sctp_rtoinfo rtoinfo;
>> @@ -1691,6 +1693,8 @@ struct sctp_association {
>>
>> =A0 =A0 =A0 /* Multistream scheduling =A0*/
>> =A0 =A0 =A0 const struct sctp_sched_ops *sched_ops;
>> + =A0 =A0 __u32 sched_priv_len;
>> + =A0 =A0 __u16 *sched_priv;
>>
>> =A0 =A0 =A0 /* Heartbeat interval: The endpoint sends out a Heartbeat ch=
unk to
>> =A0 =A0 =A0 =A0* the destination address every heartbeat interval. This =
value
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p3/include/net/sctp/user.h p4/include/net/sctp/user.h
>> --- p3/include/net/sctp/user.h =A0 =A0 =A0 =A02010-05-28 10:59:23.000000=
000 -0700
>> +++ p4/include/net/sctp/user.h =A0 =A0 =A0 =A02010-05-28 11:54:47.000000=
000 -0700
>> @@ -67,6 +67,8 @@ enum sctp_optname {
>> =A0#define SCTP_ASSOCINFO SCTP_ASSOCINFO
>> =A0 =A0 =A0 SCTP_INITMSG,
>> =A0#define SCTP_INITMSG SCTP_INITMSG
>> + =A0 =A0 SCTP_SCHED,
>> +#define SCTP_SCHED SCTP_SCHED
>> =A0 =A0 =A0 SCTP_NODELAY, =A0 /* Get/set nodelay option. */
>
> You can't insert a new option into the middle. =A0This would change the o=
rdering
> of subsequent options and break the ABI.
>
>> =A0#define SCTP_NODELAY SCTP_NODELAY
>> =A0 =A0 =A0 SCTP_AUTOCLOSE,
>> @@ -171,8 +173,22 @@ struct sctp_initmsg {
>> =A0 =A0 =A0 __u16 sinit_max_init_timeo;
>> =A0};
>>
>> +/*
>> + * SCTP Scheduling Structure (SCTP_SCHED)
>> + *
>> + * =A0 cmsg_level =A0 =A0cmsg_type =A0 =A0 =A0cmsg_data[]
>> + * =A0 ------------ =A0------------ =A0 ----------------------
>> + * =A0 IPPROTO_SCTP =A0SCTP_SCHED =A0 =A0 struct sctp_sched
>> + *
>> + */
>> =A0#define SCTP_SCHED_NAME_MAX =A016
>>
>> +struct sctp_sched {
>> + =A0 =A0 char =A0ssched_name[SCTP_SCHED_NAME_MAX];
>> + =A0 =A0 __u32 ssched_priv_len;
>> + =A0 =A0 __u16 ssched_priv[0];
>> +};
>> +
>
> Don't document it as ancillary data since it can't be used as such.
>
> Also, should this also have an assoc_id so that it can be set per
> association?

There is an important design issue here: when should the user set this
socket option?

My current assumption is that the user choose the scheduling algorithm
after declaring the socket but before the establishment of any
association. Therefore, the granularity of control is socket-based
rather than association-based. In one-to-many style socket case, all
associations inherit the scheduling algorithm of the socket. The
problems with this approach are:
1. Cannot specify different scheduling algorithm for each association
under the same socket
2. Since the option is set before the establishment of any
association, it doesn't know how many streams would be negotiated. It
could only consult initmsg for the intended number of outgoing
streams.

If we go with the association-based approach, the above problems can
be solved. But the question is: in this case, when should the user set
this option? In one-to-many style socket, associations are implicitly
established. There isn't a point where association is established but
data transfer hasn't started yet so that the user can choose the
scheduling algorithm. Any suggestion on this dilemma?

>
>> =A0/*
>> =A0 * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
>> =A0 *
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p3/net/sctp/associola.c p4/net/sctp/associola.c
>> --- p3/net/sctp/associola.c =A0 2010-06-02 12:57:06.000000000 -0700
>> +++ p4/net/sctp/associola.c =A0 2010-06-02 12:57:57.000000000 -0700
>> @@ -187,6 +187,14 @@ static struct sctp_association *sctp_ass
>>
>> =A0 =A0 =A0 /* Multistream scheduling =A0*/
>> =A0 =A0 =A0 asoc->sched_ops =3D sp->sched_ops;
>> + =A0 =A0 asoc->sched_priv_len =3D sp->sched_priv_len;
>> + =A0 =A0 if (asoc->sched_priv_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 asoc->sched_priv =3D kmalloc(asoc->sched_priv_=
len, gfp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!asoc->sched_priv)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_init;
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(asoc->sched_priv, sp->sched_priv, asoc-=
>sched_priv_len);
>
> use kmemdup()
>
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 asoc->sched_priv =3D NULL;
>>
>> =A0 =A0 =A0 /* Allocate storage for the ssnmap after the inbound and out=
bound
>> =A0 =A0 =A0 =A0* streams have been negotiated during Init.
>> @@ -464,6 +472,8 @@ static void sctp_association_destroy(str
>> =A0{
>> =A0 =A0 =A0 SCTP_ASSERT(asoc->base.dead, "Assoc is not dead", return);
>>
>> + =A0 =A0 kfree(asoc->sched_priv);
>> +
>> =A0 =A0 =A0 sctp_endpoint_put(asoc->ep);
>> =A0 =A0 =A0 sock_put(asoc->base.sk);
>>
>> diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
>> p3/net/sctp/socket.c p4/net/sctp/socket.c
>> --- p3/net/sctp/socket.c =A0 =A0 =A02010-05-28 12:38:09.000000000 -0700
>> +++ p4/net/sctp/socket.c =A0 =A0 =A02010-05-28 12:36:37.000000000 -0700
>> @@ -2580,6 +2580,50 @@ static int sctp_setsockopt_initmsg(struc
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> +/* Set the multistream scheduling algorithm*/
>> +static int sctp_setsockopt_sched(struct sock *sk, char __user *optval,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 unsigned int optlen)
>> +{
>> + =A0 =A0 struct sctp_sched *ssched =3D NULL;
>> + =A0 =A0 struct sctp_sock *sp =3D sctp_sk(sk);
>> + =A0 =A0 int ret =3D 0;
>> +
>> + =A0 =A0 if (optlen < sizeof(struct sctp_sched))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> +
>> + =A0 =A0 ssched =3D kmalloc(optlen, GFP_KERNEL);
>> + =A0 =A0 if (!ssched)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 if (copy_from_user(ssched, optval, optlen)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EFAULT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>
> use memdup_user().
>
>> +
>> + =A0 =A0 if (optlen !=3D sizeof(struct sctp_sched) + ssched->ssched_pri=
v_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 ret =3D sctp_set_sched(sk, ssched->ssched_name);
>> + =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 sp->sched_priv_len =3D ssched->ssched_priv_len;
>> + =A0 =A0 kfree(sp->sched_priv);
>> + =A0 =A0 if (sp->sched_priv_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sp->sched_priv =3D kmalloc(sp->sched_priv_len,=
 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!sp->sched_priv) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sp->sched_priv, ssched->ssched_priv, sp=
->sched_priv_len);
>> + =A0 =A0 }
>> +
>> +out:
>> + =A0 =A0 kfree(ssched);
>> + =A0 =A0 return ret;
>> +}
>> +
>> =A0/*
>> =A0 * 7.1.14 Set default send parameters (SCTP_DEFAULT_SEND_PARAM)
>> =A0 *
>> @@ -3417,6 +3461,9 @@ SCTP_STATIC int sctp_setsockopt(struct s
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_setsockopt_partial_delivery_=
point(sk, optval, optlen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>>
>> + =A0 =A0 case SCTP_SCHED:
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_setsockopt_sched(sk, optval, o=
ptlen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 case SCTP_INITMSG:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_setsockopt_initmsg(sk, optva=
l, optlen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> @@ -3642,7 +3689,10 @@ SCTP_STATIC int sctp_init_sock(struct so
>> =A0 =A0 =A0 sp->initmsg.sinit_max_attempts =A0 =3D sctp_max_retrans_init;
>> =A0 =A0 =A0 sp->initmsg.sinit_max_init_timeo =3D sctp_rto_max;
>>
>> + =A0 =A0 /* Initialize default scheduling algorithm =A0*/
>> =A0 =A0 =A0 sp->sched_ops =3D sctp_default_sched_ops;
>> + =A0 =A0 sp->sched_priv_len =3D 0;
>> + =A0 =A0 sp->sched_priv =3D NULL;
>>
>
> This part should be in the framework patch. =A0That way assoc will actual=
ly
> inherit the proper pointer.
>
>
>> =A0 =A0 =A0 /* Initialize default RTO related parameters. =A0These param=
eters can
>> =A0 =A0 =A0 =A0* be modified for with the SCTP_RTOINFO socket option.
>> @@ -3735,6 +3785,9 @@ SCTP_STATIC void sctp_destroy_sock(struc
>>
>> =A0 =A0 =A0 SCTP_DEBUG_PRINTK("sctp_destroy_sock(sk: %p)\n", sk);
>>
>> + =A0 =A0 sctp_cleanup_sched(sk);
>> + =A0 =A0 kfree(sctp_sk(sk)->sched_priv);
>> +
>> =A0 =A0 =A0 /* Release our hold on the endpoint. */
>> =A0 =A0 =A0 ep =3D sctp_sk(sk)->ep;
>> =A0 =A0 =A0 sctp_endpoint_free(ep);
>> @@ -4351,6 +4404,35 @@ static int sctp_getsockopt_initmsg(struc
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> +/* Get the multistream scheduling algorithm*/
>> +static int sctp_getsockopt_sched(struct sock *sk, int len, char __user =
*optval,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int __user *optlen)
>> +{
>> + =A0 =A0 struct sctp_sched *ssched;
>> + =A0 =A0 int sz =3D sizeof(struct sctp_sched) + sctp_sk(sk)->sched_priv=
_len;
>> + =A0 =A0 int ret =3D 0;
>> +
>> + =A0 =A0 if (len < sz)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 if (put_user(sz, optlen))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>> +
>> + =A0 =A0 ssched =3D kmalloc(sz, GFP_KERNEL);
>> + =A0 =A0 if (!ssched)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>> + =A0 =A0 memcpy(ssched->ssched_name, sctp_sk(sk)->sched_ops->name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 SCTP_SCHED_NAME_MAX);
>> + =A0 =A0 ssched->ssched_priv_len =3D sctp_sk(sk)->sched_priv_len;
>> + =A0 =A0 memcpy(ssched->ssched_priv, sctp_sk(sk)->sched_priv,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ssched->ssched_priv_len);
>> +
>> + =A0 =A0 if (copy_to_user(optval, ssched, sz))
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EFAULT;
>> +
>
> Don't forget to also copy out the sz to let user know how long the data
> is.
>
> -vlad
>
>> + =A0 =A0 kfree(ssched);
>> + =A0 =A0 return ret;
>> +}
>> +
>> =A0static int sctp_getsockopt_peer_addrs_num_old(struct sock *sk, int le=
n,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 char __user *optval,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 int __user *optlen)
>> @@ -5605,6 +5687,9 @@ SCTP_STATIC int sctp_getsockopt(struct s
>> =A0 =A0 =A0 case SCTP_INITMSG:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_getsockopt_initmsg(sk, len, =
optval, optlen);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SCTP_SCHED:
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_getsockopt_sched(sk, len, optv=
al, optlen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 case SCTP_GET_PEER_ADDRS_NUM_OLD:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D sctp_getsockopt_peer_addrs_num_ol=
d(sk, len, optval,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 optlen);
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
