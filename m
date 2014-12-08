From: Richard Haines <richard_c_haines@btinternet.com>
Date: Mon, 08 Dec 2014 16:37:01 +0000
Subject: Re: [RFC-PATCH 3/3] selinux: Add support for the SCTP protocol
Message-Id: <1418056621.75499.YahooMailNeo@web87901.mail.ir2.yahoo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1417529767-2685-1-git-send-email-richard_c_haines@btinternet.com>
 <9273829.GERZqLc7Xs@sifl>
In-Reply-To: <9273829.GERZqLc7Xs@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Paul Moore <paul@paul-moore.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, 'Daniel Borkmann' <dborkman@redhat.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>

Thanks for the update. I've added some comments inline.

I will update the patch as per your comments and send out a new version in =
about
3 or 4 weeks time.




----- Original Message -----
> From: Paul Moore <paul@paul-moore.com>
> To: Richard Haines <richard_c_haines@btinternet.com>
> Cc: selinux@tycho.nsa.gov; linux-sctp@vger.kernel.org; 'Daniel Borkmann' =
<dborkman@redhat.com>
> Sent: Monday, 8 December 2014, 3:58
> Subject: Re: [RFC-PATCH 3/3] selinux: Add support for the SCTP protocol
>=20
> On Tuesday, December 02, 2014 02:16:07 PM Richard Haines wrote:
>>  Support SCTP protocol if enabled in the kernel.
>>=20
>>  Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
>>  ---
>> =A0 security/selinux/Makefile=A0 =A0 =A0 =A0 =A0 =A0 =A0  |=A0  2 +
>> =A0 security/selinux/hooks.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 334=20
> +++++++++++++++++++----------
>> =A0 security/selinux/include/classmap.h=A0 =A0  |=A0  4 +
>> =A0 security/selinux/include/sctp.h=A0 =A0 =A0 =A0  |=A0 66 +++++++
>> =A0 security/selinux/include/sctp_private.h |=A0 46 +++++
>> =A0 security/selinux/netlabel.c=A0 =A0 =A0 =A0 =A0 =A0  |=A0 12 +-
>> =A0 security/selinux/sctp.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  | 318 ++++++=
+++++++++++++++++++++
>> =A0 7 files changed, 663 insertions(+), 119 deletions(-)
>> =A0 create mode 100644 security/selinux/include/sctp.h
>> =A0 create mode 100644 security/selinux/include/sctp_private.h
>> =A0 create mode 100644 security/selinux/sctp.c
>=20
> [NOTE: CC'ing Daniel Borkmann in case he hasn't seen this already.]
>=20
> Hi Richard,
>=20
> Thank you very much for sticking with this and taking the time to dig int=
o=20
> this a put together another patch set; I especially appreciate the commen=
ts in=20
> the code, it has helped me understand the SCTP process a bit better.
>=20
> Comments inline ...
>=20
>>  diff --git a/security/selinux/Makefile b/security/selinux/Makefile
>>  index ad5cd76..a450c85 100644
>>  --- a/security/selinux/Makefile
>>  +++ b/security/selinux/Makefile
>>  @@ -13,6 +13,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) +=3D xfrm.o
>>=20
>> =A0 selinux-$(CONFIG_NETLABEL) +=3D netlabel.o
>>=20
>>  +selinux-$(subst m,y,$(CONFIG_IP_SCTP)) +=3D sctp.o
>>  +
>> =A0 ccflags-y :=3D -Isecurity/selinux -Isecurity/selinux/include
>>=20
>> =A0 $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
>>  diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>  index e03bad5..9e5ab56 100644
>>  --- a/security/selinux/hooks.c
>>  +++ b/security/selinux/hooks.c
>>  @@ -66,6 +66,7 @@
>> =A0 #include <linux/tcp.h>
>> =A0 #include <linux/udp.h>
>> =A0 #include <linux/dccp.h>
>>  +#include <linux/sctp.h>
>> =A0 #include <linux/quota.h>
>> =A0 #include <linux/un.h>=A0=A0=A0 =A0=A0=A0 /* for Unix socket types */
>> =A0 #include <net/af_unix.h>=A0=A0=A0 /* for Unix socket types */
>>  @@ -94,6 +95,7 @@
>> =A0 #include "netlabel.h"
>> =A0 #include "audit.h"
>> =A0 #include "avc_ss.h"
>>  +#include "sctp.h"
>>=20
>> =A0 extern struct security_operations *security_ops;
>>=20
>>  @@ -1185,8 +1187,11 @@ static inline u16 socket_type_to_security_class(=
int
>>  family, int type, int protoc case PF_INET6:
>> =A0 =A0=A0=A0 =A0=A0=A0 switch (type) {
>> =A0 =A0=A0=A0 =A0=A0=A0 case SOCK_STREAM:
>>  +=A0=A0=A0 =A0=A0=A0 case SOCK_SEQPACKET:
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (default_protocol_stream(protocol))
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return SECCLASS_TCP_SOCKET;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 else if (protocol =3D IPPROTO_SCTP)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return SECCLASS_SCTP_SOCKET;
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 else
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return SECCLASS_RAWIP_SOCKET;
>> =A0 =A0=A0=A0 =A0=A0=A0 case SOCK_DGRAM:
>>  @@ -3726,6 +3731,24 @@ static int selinux_parse_skb_ipv4(struct sk_buff
>>  *skb, break;
>> =A0 =A0=A0=A0 }
>>=20
>>  +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
>>  +=A0=A0=A0 case IPPROTO_SCTP: {
>>  +=A0=A0=A0 =A0=A0=A0 struct sctphdr _sctph, *sh;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 if (ntohs(ih->frag_off) & IP_OFFSET)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 offset +=3D ihlen;
>>  +=A0=A0=A0 =A0=A0=A0 sh =3D skb_header_pointer(skb, offset, sizeof(_sct=
ph), &_sctph);
>>  +=A0=A0=A0 =A0=A0=A0 if (sh =3D NULL)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 ad->u.net->sport =3D sh->source;
>>  +=A0=A0=A0 =A0=A0=A0 ad->u.net->dport =3D sh->dest;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 }
>>  +#endif
>>  +
>> =A0 =A0=A0=A0 default:
>> =A0 =A0=A0=A0 =A0=A0=A0 break;
>> =A0 =A0=A0=A0 }
>>  @@ -3799,6 +3822,20 @@ static int selinux_parse_skb_ipv6(struct sk_buff
>>  *skb, break;
>> =A0 =A0=A0=A0 }
>>=20
>>  +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
>>  +=A0=A0=A0 case IPPROTO_SCTP: {
>>  +=A0=A0=A0 =A0=A0=A0 struct sctphdr _sctph, *sh;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 sh =3D skb_header_pointer(skb, offset, sizeof(_sct=
ph), &_sctph);
>>  +=A0=A0=A0 =A0=A0=A0 if (sh =3D NULL)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 ad->u.net->sport =3D sh->source;
>>  +=A0=A0=A0 =A0=A0=A0 ad->u.net->dport =3D sh->dest;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 }
>>  +#endif
>>  +
>> =A0 =A0=A0=A0 /* includes fragments */
>> =A0 =A0=A0=A0 default:
>> =A0 =A0=A0=A0 =A0=A0=A0 break;
>>  @@ -3928,7 +3965,7 @@ static int socket_sockcreate_sid(const struct
>>  task_security_struct *tsec, socksid);
>> =A0 }
>>=20
>>  -static int sock_has_perm(struct task_struct *task, struct sock *sk, u32
>> =A0  perms)=20
>>  +int sock_has_perm(struct task_struct *task, struct sock *sk, u32
>> =A0  perms) {
>> =A0 =A0=A0=A0 struct sk_security_struct *sksec =3D sk->sk_security;
>> =A0 =A0=A0=A0 struct common_audit_data ad;
>>  @@ -3998,6 +4035,93 @@ static int selinux_socket_post_create(struct soc=
ket
>>  *sock, int family, Need to determine whether we should perform a name_b=
ind
>> =A0 =A0  permission check between the socket and the port number. */
>>=20
>>  +int selinux_sk_bind(struct sock *sk, struct sockaddr *address,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int addrlen, u16 famil=
y)
>>  +{
>>  +=A0=A0=A0 int err =3D 0;
>>  +=A0=A0=A0 char *addrp;
>>  +=A0=A0=A0 struct sk_security_struct *sksec =3D sk->sk_security;
>>  +=A0=A0=A0 struct common_audit_data ad;
>>  +=A0=A0=A0 struct lsm_network_audit net =3D {0,};
>>  +=A0=A0=A0 struct sockaddr_in *addr4 =3D NULL;
>>  +=A0=A0=A0 struct sockaddr_in6 *addr6 =3D NULL;
>>  +=A0=A0=A0 unsigned short snum;
>>  +=A0=A0=A0 u32 sid, node_perm;
>>  +
>>  +=A0=A0=A0 if (family =3D PF_INET) {
>>  +=A0=A0=A0 =A0=A0=A0 addr4 =3D (struct sockaddr_in *)address;
>>  +=A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr4->sin_port);
>>  +=A0=A0=A0 =A0=A0=A0 addrp =3D (char *)&addr4->sin_addr.s_addr;
>>  +=A0=A0=A0 } else {
>>  +=A0=A0=A0 =A0=A0=A0 addr6 =3D (struct sockaddr_in6 *)address;
>>  +=A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr6->sin6_port);
>>  +=A0=A0=A0 =A0=A0=A0 addrp =3D (char *)&addr6->sin6_addr.s6_addr;
>>  +=A0=A0=A0 }
>>  +
>>  +=A0=A0=A0 if (snum) {
>>  +=A0=A0=A0 =A0=A0=A0 int low, high;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 inet_get_local_port_range(sock_net(sk), &low, &hig=
h);
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 if (snum < max(PROT_SOCK, low) || snum > high) {
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sel_netport_sid(sk->sk_protocol,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 snum, &s=
id);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net =3D &net;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->sport =3D htons(snum);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->family =3D family;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D avc_has_perm(sksec->sid, sid,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  sksec->sclass,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  SOCKET__NAME_BI=
ND, &ad);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 }
>>  +
>>  +=A0=A0=A0 switch (sksec->sclass) {
>>  +=A0=A0=A0 case SECCLASS_TCP_SOCKET:
>>  +=A0=A0=A0 =A0=A0=A0 node_perm =3D TCP_SOCKET__NODE_BIND;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 case SECCLASS_UDP_SOCKET:
>>  +=A0=A0=A0 =A0=A0=A0 node_perm =3D UDP_SOCKET__NODE_BIND;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 case SECCLASS_DCCP_SOCKET:
>>  +=A0=A0=A0 =A0=A0=A0 node_perm =3D DCCP_SOCKET__NODE_BIND;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 case SECCLASS_SCTP_SOCKET:
>>  +=A0=A0=A0 =A0=A0=A0 node_perm =3D SCTP_SOCKET__NODE_BIND;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 default:
>>  +=A0=A0=A0 =A0=A0=A0 node_perm =3D RAWIP_SOCKET__NODE_BIND;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 }
>>  +
>>  +=A0=A0=A0 err =3D sel_netnode_sid(addrp, family, &sid);
>>  +=A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 goto out;
>>  +
>>  +=A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  +=A0=A0=A0 ad.u.net =3D &net;
>>  +=A0=A0=A0 ad.u.net->sport =3D htons(snum);
>>  +=A0=A0=A0 ad.u.net->family =3D family;
>>  +
>>  +=A0=A0=A0 if (family =3D PF_INET)
>>  +=A0=A0=A0 =A0=A0=A0 ad.u.net->v4info.saddr =3D addr4->sin_addr.s_addr;
>>  +=A0=A0=A0 else
>>  +=A0=A0=A0 =A0=A0=A0 ad.u.net->v6info.saddr =3D addr6->sin6_addr;
>>  +
>>  +=A0=A0=A0 err =3D avc_has_perm(sksec->sid, sid,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  sksec->sclass, node_perm, &ad);
>>  +out:
>>  +=A0=A0=A0 return err;
>>  +}
>>  +
>> =A0 static int selinux_socket_bind(struct socket *sock, struct sockaddr
>>  *address, int addrlen) {
>> =A0 =A0=A0=A0 struct sock *sk =3D sock->sk;
>>  @@ -4006,93 +4130,61 @@ static int selinux_socket_bind(struct socket *s=
ock,
>>  struct sockaddr *address, in
>>=20
>> =A0 =A0=A0=A0 err =3D sock_has_perm(current, sk, SOCKET__BIND);
>> =A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 goto out;
>>  +=A0=A0=A0 =A0=A0=A0 return err;
>>=20
>> =A0 =A0=A0=A0 /*
>> =A0 =A0=A0=A0  * If PF_INET or PF_INET6, check name_bind permission for =
the port.
>>  -=A0=A0=A0  * Multiple address binding for SCTP is not supported yet: w=
e just
>>  -=A0=A0=A0  * check the first address now.
>>  +=A0=A0=A0  * Multiple address binding for SCTP is supported via the
>>  +=A0=A0=A0  * selinux_sctp_validate_*() functions.
>> =A0 =A0=A0=A0  */
>> =A0 =A0=A0=A0 family =3D sk->sk_family;
>>  -=A0=A0=A0 if (family =3D PF_INET || family =3D PF_INET6) {
>>  -=A0=A0=A0 =A0=A0=A0 char *addrp;
>>  -=A0=A0=A0 =A0=A0=A0 struct sk_security_struct *sksec =3D sk->sk_securi=
ty;
>>  -=A0=A0=A0 =A0=A0=A0 struct common_audit_data ad;
>>  -=A0=A0=A0 =A0=A0=A0 struct lsm_network_audit net =3D {0,};
>>  -=A0=A0=A0 =A0=A0=A0 struct sockaddr_in *addr4 =3D NULL;
>>  -=A0=A0=A0 =A0=A0=A0 struct sockaddr_in6 *addr6 =3D NULL;
>>  -=A0=A0=A0 =A0=A0=A0 unsigned short snum;
>>  -=A0=A0=A0 =A0=A0=A0 u32 sid, node_perm;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 if (family =3D PF_INET) {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addr4 =3D (struct sockaddr_in *)address;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr4->sin_port);
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addrp =3D (char *)&addr4->sin_addr.s_add=
r;
>>  -=A0=A0=A0 =A0=A0=A0 } else {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addr6 =3D (struct sockaddr_in6 *)address;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr6->sin6_port);
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addrp =3D (char *)&addr6->sin6_addr.s6_a=
ddr;
>>  -=A0=A0=A0 =A0=A0=A0 }
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 if (snum) {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 int low, high;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 inet_get_local_port_range(sock_net(sk), =
&low, &high);
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (snum < max(PROT_SOCK, low) || snum >=
 high) {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sel_netport_sid(sk->sk=
_protocol,
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =
=A0 snum, &sid);
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net =3D &net;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->sport =3D htons(snum=
);
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->family =3D family;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D avc_has_perm(sksec->si=
d, sid,
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  sksec=
->sclass,
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  SOCKE=
T__NAME_BIND, &ad);
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
>>  -=A0=A0=A0 =A0=A0=A0 }
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 switch (sksec->sclass) {
>>  -=A0=A0=A0 =A0=A0=A0 case SECCLASS_TCP_SOCKET:
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 node_perm =3D TCP_SOCKET__NODE_BIND;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 case SECCLASS_UDP_SOCKET:
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 node_perm =3D UDP_SOCKET__NODE_BIND;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 if (family =3D PF_INET || family =3D PF_INET6)
>>  +=A0=A0=A0 =A0=A0=A0 err =3D selinux_sk_bind(sk, address, addrlen, fami=
ly);
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 case SECCLASS_DCCP_SOCKET:
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 node_perm =3D DCCP_SOCKET__NODE_BIND;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 return err;
>>  +}
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 default:
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 node_perm =3D RAWIP_SOCKET__NODE_BIND;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  -=A0=A0=A0 =A0=A0=A0 }
>=20
> Out of curiosity, why did you pull the bulk of selinux_socket_bind() out =
into=20
> a separate function?
It seemed like a good idea at the time !!! I'll review.

>=20
> I do agree that this function is a bit awkward (we could probably tweak t=
hings=20
> a bit so that the bulk of the code doesn't lie inside an if-then block), =
but=20
>=20
> I'm not convinced another function is the answer.
>=20
>>  +int selinux_sk_connect(struct sock *sk, struct sockaddr *address,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 in=
t addrlen)
>>  +{
>>  +=A0=A0=A0 struct sk_security_struct *sksec =3D sk->sk_security;
>>  +=A0=A0=A0 int err;
>>  +=A0=A0=A0 struct common_audit_data ad;
>>  +=A0=A0=A0 struct lsm_network_audit net =3D {0,};
>>  +=A0=A0=A0 struct sockaddr_in *addr4 =3D NULL;
>>  +=A0=A0=A0 struct sockaddr_in6 *addr6 =3D NULL;
>>  +=A0=A0=A0 unsigned short snum;
>>  +=A0=A0=A0 u32 sid, perm;
>>  +
>>  +=A0=A0=A0 if (sk->sk_family =3D PF_INET) {
>>  +=A0=A0=A0 =A0=A0=A0 addr4 =3D (struct sockaddr_in *)address;
>>  +=A0=A0=A0 =A0=A0=A0 if (addrlen < sizeof(struct sockaddr_in))
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  +=A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr4->sin_port);
>>  +=A0=A0=A0 } else {
>>  +=A0=A0=A0 =A0=A0=A0 addr6 =3D (struct sockaddr_in6 *)address;
>>  +=A0=A0=A0 =A0=A0=A0 if (addrlen < SIN6_LEN_RFC2133)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  +=A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr6->sin6_port);
>>  +=A0=A0=A0 }
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 err =3D sel_netnode_sid(addrp, family, &sid);
>>  -=A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  +=A0=A0=A0 err =3D sel_netport_sid(sk->sk_protocol, snum, &sid);
>>  +=A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 goto out;
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net =3D &net;
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net->sport =3D htons(snum);
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net->family =3D family;
>>  +=A0=A0=A0 if (sksec->sclass =3D SECCLASS_TCP_SOCKET)
>>  +=A0=A0=A0 =A0=A0=A0 perm =3D TCP_SOCKET__NAME_CONNECT;
>>  +=A0=A0=A0 else if (sksec->sclass =3D SECCLASS_DCCP_SOCKET)
>>  +=A0=A0=A0 =A0=A0=A0 perm =3D DCCP_SOCKET__NAME_CONNECT;
>>  +=A0=A0=A0 else if (sksec->sclass =3D SECCLASS_SCTP_SOCKET)
>>  +=A0=A0=A0 =A0=A0=A0 perm =3D SCTP_SOCKET__NAME_CONNECT;
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 if (family =3D PF_INET)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->v4info.saddr =3D addr4->sin_ad=
dr.s_addr;
>>  -=A0=A0=A0 =A0=A0=A0 else
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ad.u.net->v6info.saddr =3D addr6->sin6_a=
ddr;
>>  +=A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  +=A0=A0=A0 ad.u.net =3D &net;
>>  +=A0=A0=A0 ad.u.net->dport =3D htons(snum);
>>  +=A0=A0=A0 ad.u.net->family =3D sk->sk_family;
>>  +=A0=A0=A0 err =3D avc_has_perm(sksec->sid, sid, sksec->sclass, perm,=20
> &ad);
>>=20
>>  -=A0=A0=A0 =A0=A0=A0 err =3D avc_has_perm(sksec->sid, sid,
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  sksec->sclass, node_perm,=
 &ad);
>>  -=A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  -=A0=A0=A0 }
>> =A0 out:
>> =A0 =A0=A0=A0 return err;
>> =A0 }
>>  @@ -4108,48 +4200,18 @@ static int selinux_socket_connect(struct socket
>>  *sock, struct sockaddr *address, return err;
>>=20
>> =A0 =A0=A0=A0 /*
>>  -=A0=A0=A0  * If a TCP or DCCP socket, check name_connect permission fo=
r the=20
> port.
>>  +=A0=A0=A0  * If a TCP, DCCP or SCTP socket, check name_connect permiss=
ion
>>  +=A0=A0=A0  * for the port.
>> =A0 =A0=A0=A0  */
>> =A0 =A0=A0=A0 if (sksec->sclass =3D SECCLASS_TCP_SOCKET ||
>>  -=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_DCCP_SOCKET) {
>>  -=A0=A0=A0 =A0=A0=A0 struct common_audit_data ad;
>>  -=A0=A0=A0 =A0=A0=A0 struct lsm_network_audit net =3D {0,};
>>  -=A0=A0=A0 =A0=A0=A0 struct sockaddr_in *addr4 =3D NULL;
>>  -=A0=A0=A0 =A0=A0=A0 struct sockaddr_in6 *addr6 =3D NULL;
>>  -=A0=A0=A0 =A0=A0=A0 unsigned short snum;
>>  -=A0=A0=A0 =A0=A0=A0 u32 sid, perm;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 if (sk->sk_family =3D PF_INET) {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addr4 =3D (struct sockaddr_in *)address;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (addrlen < sizeof(struct sockaddr_in))
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr4->sin_port);
>>  -=A0=A0=A0 =A0=A0=A0 } else {
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addr6 =3D (struct sockaddr_in6 *)address;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (addrlen < SIN6_LEN_RFC2133)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 snum =3D ntohs(addr6->sin6_port);
>>  -=A0=A0=A0 =A0=A0=A0 }
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 err =3D sel_netport_sid(sk->sk_protocol, snum, &si=
d);
>>  -=A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 perm =3D (sksec->sclass =3D SECCLASS_TCP_SOCKET) ?
>>  -=A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0  TCP_SOCKET__NAME_CONNECT : DCCP_SOCKE=
T__NAME_CONNECT;
>>  -
>>  -=A0=A0=A0 =A0=A0=A0 ad.type =3D LSM_AUDIT_DATA_NET;
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net =3D &net;
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net->dport =3D htons(snum);
>>  -=A0=A0=A0 =A0=A0=A0 ad.u.net->family =3D sk->sk_family;
>>  -=A0=A0=A0 =A0=A0=A0 err =3D avc_has_perm(sksec->sid, sid, sksec->sclas=
s, perm,=20
> &ad);
>>  +=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_DCCP_SOCKET ||
>>  +=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_SCTP_SOCKET) {
>>  +=A0=A0=A0 =A0=A0=A0 err =3D selinux_sk_connect(sk, address, addrlen);
>> =A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto out;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>> =A0 =A0=A0=A0 }
>>=20
>> =A0 =A0=A0=A0 err =3D selinux_netlbl_socket_connect(sk, address);
>>  -
>>  -out:
>> =A0 =A0=A0=A0 return err;
>> =A0 }
>=20
> The same thing here, why the new function?
>=20
>>  @@ -4200,7 +4262,9 @@ static int selinux_socket_getpeername(struct sock=
et
>>  *sock) return sock_has_perm(current, sock->sk, SOCKET__GETATTR);
>> =A0 }
>>=20
>>  -static int selinux_socket_setsockopt(struct socket *sock, int level, i=
nt
>>  optname)=20
>>  +static int selinux_socket_setsockopt(struct socket *sock, int
>> =A0  level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname, char __us=
er *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optlen)
>> =A0 {
>> =A0 =A0=A0=A0 int err;
>>=20
>>  @@ -4208,13 +4272,26 @@ static int selinux_socket_setsockopt(struct soc=
ket
>>  *sock, int level, int optname if (err)
>> =A0 =A0=A0=A0 =A0=A0=A0 return err;
>>=20
>>  +=A0=A0=A0 err =3D selinux_sctp_validate_setsockopt(sock->sk, level, op=
tname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =
=A0  optval, optlen);
>>  +=A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 return err;
>>  +
>> =A0 =A0=A0=A0 return selinux_netlbl_socket_setsockopt(sock, level, optna=
me);
>> =A0 }
>>=20
>> =A0 static int selinux_socket_getsockopt(struct socket *sock, int level,
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0  int optname)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname, char __us=
er *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int __user *optlen)
>> =A0 {
>>  -=A0=A0=A0 return sock_has_perm(current, sock->sk, SOCKET__GETOPT);
>>  +=A0=A0=A0 int err;
>>  +
>>  +=A0=A0=A0 err =3D sock_has_perm(current, sock->sk, SOCKET__GETOPT);
>>  +=A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 return err;
>>  +
>>  +=A0=A0=A0 return selinux_sctp_validate_getsockopt(sock->sk, level, opt=
name,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =
=A0 =A0 optval, optlen);
>> =A0 }
>>=20
>> =A0 static int selinux_socket_shutdown(struct socket *sock, int how)
>>  @@ -4385,6 +4462,16 @@ static int selinux_socket_sock_rcv_skb(struct so=
ck
>>  *sk, struct sk_buff *skb) selinux_netlbl_err(skb, err, 0);
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>> =A0 =A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 =A0=A0=A0 /* The peer label has been validated. If SCTP clas=
s then
>>  +=A0=A0=A0 =A0=A0=A0  * update sksec->peer_sid with the new peer_sid so=
 it can be
>>  +=A0=A0=A0 =A0=A0=A0  * retrieved by getpeercon(3).
>>  +=A0=A0=A0 =A0=A0=A0  * Note: Because SCTP can have associations with m=
ultiple
>>  +=A0=A0=A0 =A0=A0=A0  * peers, it is possible that each will have a dif=
ferent
>>  +=A0=A0=A0 =A0=A0=A0  * peer label, therefore getpeercon(3) will only r=
eflect the
>>  +=A0=A0=A0 =A0=A0=A0  * last one processed here. */
>>  +=A0=A0=A0 =A0=A0=A0 if (sksec->sclass =3D SECCLASS_SCTP_SOCKET &&
>>  +=A0=A0=A0 =A0=A0=A0 =A0 =A0 sksec->peer_sid !=3D peer_sid)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sksec->peer_sid =3D peer_sid;
>=20
> I could use a SCTP refresher here, but I don't think this is correct.
>=20
> With connectionless protocols, e.g. UDP, there is not peer label since th=
ere=20
> is no connected peer.=A0 With connection based protocols, e.g. TCP, the p=
eer=20
> label is set during the early stages of the connection handshake, see=20
> selinux_inet_conn_request(), and never changes during the lifetime of the=
=20
> socket/connection.=A0 I suspect SCTP, due to the association concept, is =
much=20
> closer to TCP than UDP; we do want to set/track the peer label, but at th=
e=20
> early stages of the association setup, not here.
>=20
> If there is an issue with multiple associations sharing a single socket t=
hen=20
> we should look a bit more closely at how the associations are established=
.=A0=20
> Likely the first association on a socket would be the one that would set =
the=20
> peer label, and then each additional association would need to have the e=
xact=20
> same security label, else the association would be denied.

Thanks for the clarification. I'll work through this again.

>=20
>> =A0 =A0=A0=A0 }
>>=20
>> =A0 =A0=A0=A0 if (secmark_active) {
>>  @@ -4407,7 +4494,12 @@ static int selinux_socket_getpeersec_stream(stru=
ct
>>  socket *sock, char __user *op u32 peer_sid =3D SECSID_NULL;
>>=20
>> =A0 =A0=A0=A0 if (sksec->sclass =3D SECCLASS_UNIX_STREAM_SOCKET ||
>>  -=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_TCP_SOCKET)
>>  +=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_TCP_SOCKET ||
>>  +=A0=A0=A0 =A0 =A0 sksec->sclass =3D SECCLASS_SCTP_SOCKET)
>>  +=A0=A0=A0 =A0=A0=A0 /* Note: Because SCTP can have associations with m=
ultiple
>>  +=A0=A0=A0 =A0=A0=A0  * peers, it is possible that each will have a dif=
ferent
>>  +=A0=A0=A0 =A0=A0=A0  * peer label, therefore this will only reflect th=
e last
>>  +=A0=A0=A0 =A0=A0=A0  * one processed by selinux_socket_sock_rcv_skb() =
*/
>> =A0 =A0=A0=A0 =A0=A0=A0 peer_sid =3D sksec->peer_sid;
>=20
> See above comment.
>=20
>> =A0 =A0=A0=A0 if (peer_sid =3D SECSID_NULL)
>> =A0 =A0=A0=A0 =A0=A0=A0 return -ENOPROTOOPT;
>>  @@ -4805,6 +4897,8 @@ static unsigned int selinux_ip_output(struct sk_b=
uff
>>  *skb, if (sk) {
>> =A0 =A0=A0=A0 =A0=A0=A0 struct sk_security_struct *sksec;
>>=20
>>  +=A0=A0=A0 =A0=A0=A0 /* Note that TCP_LISTEN equates to SCTP_SS_LISTENI=
NG
>>  +=A0=A0=A0 =A0=A0=A0  * and DCCP_LISTEN socket states */
>> =A0 =A0=A0=A0 =A0=A0=A0 if (sk->sk_state =3D TCP_LISTEN)
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* if the socket is the listening stat=
e then this
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * packet is a SYN-ACK packet which me=
ans it needs to
>>  @@ -4910,7 +5004,9 @@ static unsigned int selinux_ip_postroute(struct
>>  sk_buff *skb, int ifindex,
>> =A0 =A0 *=A0 =A0 =A0  TCP listening state we cannot wait until the XFRM =
processing
>> =A0 =A0 *=A0 =A0 =A0  is done as we will miss out on the SA label if we =
do;
>> =A0 =A0=A0=A0  *=A0 =A0 =A0  unfortunately, this means more work, but it=
 is only once per
>>  -=A0=A0=A0  *=A0 =A0 =A0  connection. */
>>  +=A0=A0=A0  *=A0 =A0 =A0  connection.
>>  +=A0=A0=A0  * NOTE: that TCP_LISTEN equates to SCTP_SS_LISTENING and DC=
CP_LISTEN
>>  +=A0=A0=A0  * socket states */
>=20
> This is another thing we need to worry about.=A0 Do you understand why th=
ere are=20
> special cases here for TCP?=A0=20
Not really - I added lots of debugs around here to see what happened and co=
uld not
see anything that crippled anything, however as I was not sure what I was l=
ooking for !!!
This applied to the other areas I put comments regarding SCTP_SS_LISTENING =
and
DCCP_LISTEN states. I guess they may need narrowing down by adding
IPPROTO_TCP or IPROTO_SCTP (may be).
I'll poke around a bit more here and see how it goes.

> We may need to do something similar with SCTP=20
> depending on the associations; I say may because I'm not sure if we'll=20
> need to=20
> do the special accept()/child socket labeling trick (TCP child socket's t=
ake=20
>=20
> the TE information from the parent server socket, but the MLS/MCS informa=
tion=20
> from the connection).

>=20
>> =A0 =A0=A0=A0 if (skb_dst(skb) !=3D NULL && skb_dst(skb)->xfrm !=3D NULL=
=20
> &&
>> =A0 =A0=A0=A0 =A0 =A0 !(sk !=3D NULL && sk->sk_state =3D TCP_LISTEN))
>> =A0 =A0=A0=A0 =A0=A0=A0 return NF_ACCEPT;
>>  @@ -4929,6 +5025,8 @@ static unsigned int selinux_ip_postroute(struct
>>  sk_buff *skb, int ifindex, secmark_perm =3D PACKET__SEND;
>> =A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 peer_sid =3D SECINITSID_KERNEL;
>> =A0 =A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 /* Note that TCP_LISTEN equates to SCTP_SS_LISTENING and DCC=
P_LISTEN
>>  +=A0=A0=A0  * socket states */
>> =A0 =A0=A0=A0 } else if (sk->sk_state =3D TCP_LISTEN) {
>> =A0 =A0=A0=A0 =A0=A0=A0 /* Locally generated packet but the associated s=
ocket is in the
>> =A0 =A0=A0=A0 =A0=A0=A0  * listening state which means this is a SYN-ACK=
 packet.=A0 In
>>  diff --git a/security/selinux/include/classmap.h
>>  b/security/selinux/include/classmap.h index be491a7..8ab388a 100644
>>  --- a/security/selinux/include/classmap.h
>>  +++ b/security/selinux/include/classmap.h
>>  @@ -151,5 +151,9 @@ struct security_class_mapping secclass_map[] =3D {
>> =A0 =A0=A0=A0 { "kernel_service", { "use_as_override",=20
> "create_files_as", NULL } },
>> =A0 =A0=A0=A0 { "tun_socket",
>> =A0 =A0=A0=A0 =A0 { COMMON_SOCK_PERMS, "attach_queue", NULL } },
>>  +=A0=A0=A0 { "sctp_socket",
>>  +=A0=A0=A0 =A0 { COMMON_SOCK_PERMS, "node_bind",=20
> "name_connect", "bindx_add",
>>  +=A0=A0=A0 =A0 =A0 "bindx_rem", "connectx", "peeloff",=20
> "set_addr", "set_params",
>>  +=A0=A0=A0 =A0 =A0 NULL } },
>> =A0 =A0=A0=A0 { NULL }
>> =A0 =A0 };
>>  diff --git a/security/selinux/include/sctp.h
>>  b/security/selinux/include/sctp.h new file mode 100644
>>  index 0000000..e5c5de2
>>  --- /dev/null
>>  +++ b/security/selinux/include/sctp.h
>>  @@ -0,0 +1,66 @@
>>  +/*
>>  + * SELinux SCTP Support
>>  + *
>>  + * Provides SCTP function refs for getsockopt/setsockopt in
>>  selinux/hooks.c. + *
>>  + * Author: Richard Haines <richard_c_haines@btinternet.com>
>>  + *
>>  + */
>>  +
>>  +/*
>>  + * This program is free software;=A0 you can redistribute it and/or mo=
dify
>>  + * it under the terms of the GNU General Public License as published by
>>  + * the Free Software Foundation; either version 2 of the License, or
>>  + * (at your option) any later version.
>>  + *
>>  + * This program is distributed in the hope that it will be useful,
>>  + * but WITHOUT ANY WARRANTY;=A0 without even the implied warranty of
>>  + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=A0 See
>>  + * the GNU General Public License for more details.
>>  + *
>>  + * You should have received a copy of the GNU General Public License
>>  + * along with this program;=A0 if not, write to the Free Software
>>  + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307=
 USA
>>  + *
>>  + */
>>  +
>>  +#ifndef _SELINUX_SCTP_H_
>>  +#define _SELINUX_SCTP_H_
>>  +
>>  +#include <linux/types.h>
>>  +#include <linux/net.h>
>>  +#include <net/sock.h>
>>  +
>>  +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
>>  +int selinux_sctp_validate_setsockopt(struct sock *sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optlen);
>>  +
>>  +int selinux_sctp_validate_getsockopt(struct sock *sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int __user *optlen);
>>  +#else
>>  +static inline int selinux_sctp_validate_setsockopt(struct sock *sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optlen)
>>  +{
>>  +=A0=A0=A0 return 0;
>>  +}
>>  +
>>  +static inline int selinux_sctp_validate_getsockopt(struct sock *sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int __user *optlen)
>>  +{
>>  +=A0=A0=A0 return 0;
>>  +}
>>  +#endif=A0 /* CONFIG_IP_SCTP */
>>  +
>>  +#endif
>>  diff --git a/security/selinux/include/sctp_private.h
>>  b/security/selinux/include/sctp_private.h new file mode 100644
>>  index 0000000..25dbaa3
>>  --- /dev/null
>>  +++ b/security/selinux/include/sctp_private.h
>>  @@ -0,0 +1,46 @@
>>  +/*
>>  + * SELinux SCTP Support
>>  + *
>>  + * Provides headers + extern selinux/hooks.c functions for selinux/sct=
p.c.
>>  + *
>>  + * Author: Richard Haines <richard_c_haines@btinternet.com>
>>  + *
>>  + */
>>  +
>>  +/*
>>  + * This program is free software;=A0 you can redistribute it and/or mo=
dify
>>  + * it under the terms of the GNU General Public License as published by
>>  + * the Free Software Foundation; either version 2 of the License, or
>>  + * (at your option) any later version.
>>  + *
>>  + * This program is distributed in the hope that it will be useful,
>>  + * but WITHOUT ANY WARRANTY;=A0 without even the implied warranty of
>>  + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=A0 See
>>  + * the GNU General Public License for more details.
>>  + *
>>  + * You should have received a copy of the GNU General Public License
>>  + * along with this program;=A0 if not, write to the Free Software
>>  + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307=
 USA
>>  + *
>>  + */
>>  +
>>  +#include <linux/kernel.h>
>>  +#include <linux/init.h>
>>  +#include <linux/sched.h>
>>  +#include <linux/types.h>
>>  +#include <linux/net.h>
>>  +#include <net/sock.h>
>>  +#include <linux/sctp.h>
>>  +#include <uapi/linux/sctp.h>=A0=A0=A0 /* For bindx setsocket option ch=
ecks=20
> */
>>  +
>>  +#include "security.h"
>>  +#include "avc.h"
>>  +
>>  +extern int sock_has_perm(struct task_struct *task, struct sock *sk, u32
>> =A0  perms);
>>  +
>>  +extern int selinux_sk_bind(struct sock *sk, struct sockaddr *address,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int addrlen, u16 famil=
y);
>>  +
>>  +extern int selinux_sk_connect(struct sock *sk, struct sockaddr *addres=
s,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 in=
t addrlen);
>>  +
>>  diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
>>  index 0364120..0b04c8a 100644
>>  --- a/security/selinux/netlabel.c
>>  +++ b/security/selinux/netlabel.c
>>  @@ -396,13 +396,23 @@ int selinux_netlbl_sock_rcv_skb(struct
>>  sk_security_struct *sksec, case SECCLASS_TCP_SOCKET:
>> =A0 =A0=A0=A0 =A0=A0=A0 perm =3D TCP_SOCKET__RECVFROM;
>> =A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 case SECCLASS_SCTP_SOCKET:
>>  +=A0=A0=A0 =A0=A0=A0 perm =3D SCTP_SOCKET__RECVFROM;
>>  +=A0=A0=A0 =A0=A0=A0 break;
>> =A0 =A0=A0=A0 default:
>> =A0 =A0=A0=A0 =A0=A0=A0 perm =3D RAWIP_SOCKET__RECVFROM;
>> =A0 =A0=A0=A0 }
>>=20
>> =A0 =A0=A0=A0 rc =3D avc_has_perm(sksec->sid, nlbl_sid, sksec->sclass, p=
erm,=20
> ad);
>>  -=A0=A0=A0 if (rc =3D 0)
>>  +=A0=A0=A0 if (rc =3D 0) {
>>  +=A0=A0=A0 =A0=A0=A0 /* The peer label has been validated in compat mod=
e.
>>  +=A0=A0=A0 =A0=A0=A0  * If SCTP class then update sksec->peer_sid with =
the
>>  +=A0=A0=A0 =A0=A0=A0  * nlbl_sid so it can be retrieved by getpeercon(3=
). */
>>  +=A0=A0=A0 =A0=A0=A0 if (sksec->sclass =3D SECCLASS_SCTP_SOCKET &&
>>  +=A0=A0=A0 =A0=A0=A0 =A0 =A0 sksec->peer_sid !=3D nlbl_sid)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sksec->peer_sid =3D nlbl_sid;
>> =A0 =A0=A0=A0 =A0=A0=A0 return 0;
>>  +=A0=A0=A0 }
>=20
> See the other comments, this is likely not right.
>=20
>> =A0 =A0=A0=A0 if (nlbl_sid !=3D SECINITSID_UNLABELED)
>> =A0 =A0=A0=A0 =A0=A0=A0 netlbl_skbuff_err(skb, rc, 0);
>>  diff --git a/security/selinux/sctp.c b/security/selinux/sctp.c
>>  new file mode 100644
>>  index 0000000..1bd98a2
>>  --- /dev/null
>>  +++ b/security/selinux/sctp.c
>>  @@ -0,0 +1,318 @@
>>  +/*
>>  + * SELinux SCTP Support
>>  + *
>>  + * Provides security checks for the SCTP protocol.
>>  + *
>>  + * Author: Richard Haines <richard_c_haines@btinternet.com>
>>  + *
>>  + */
>>  +
>>  +/*
>>  + * This program is free software;=A0 you can redistribute it and/or mo=
dify
>>  + * it under the terms of the GNU General Public License as published by
>>  + * the Free Software Foundation; either version 2 of the License, or
>>  + * (at your option) any later version.
>>  + *
>>  + * This program is distributed in the hope that it will be useful,
>>  + * but WITHOUT ANY WARRANTY;=A0 without even the implied warranty of
>>  + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=A0 See
>>  + * the GNU General Public License for more details.
>>  + *
>>  + * You should have received a copy of the GNU General Public License
>>  + * along with this program;=A0 if not, write to the Free Software
>>  + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307=
 USA
>>  + *
>>  + */
>>  +
>>  +#include "sctp_private.h"=A0=A0=A0 /* #include files + extern=20
> functions. */
>>  +
>>  +/**
>>  + * validate_sctp_addrs - Validate bindx and connectx addresses.
>>  + * @sk: the socket
>>  + * @optname: contains the name of the option to validate
>>  + * @addrs: structure containing one or more SCTP addresses
>>  + * @len: contains the length of the structure
>>  + *
>>  + * Description:
>>  + * This function will copy down the SCTP bindx and connectx addresses =
then
>>  + * check the appropriate permissions on each one via selinux_sk_bind()=
 or
>>  + * selinux_sk_connect(). The code is a modified version from
>>  + * net/sctp/socket.c.
>>  + * Returns zero on success, negative values on failure.
>>  +*/
>=20
> Based on the comment above, I have to wonder if we are doing the check in=
 the=20
> right place, I don't think the LSM should be doing __copy_from_user()=20
> calls.=A0=20
> Is there a good place in the core SCTP code that we could hook to avoid a=
 lot=20
> of this?
Yes there are places as I've tested already. I plan to add a new security h=
ook
as follows and plugged into net/sctp/socket.c code:

int security_sk_setsockopt(struct sock *sk, int level, int optname,
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 char *optval,
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 unsigned int optlen)
{
=A0=A0=A0 return security_ops->sk_setsockopt(sk, level, optname, optval, op=
tlen);
}
EXPORT_SYMBOL(security_sk_setsockopt);

This could then be used by other services that would need to set sockopts. =
Does
this seem reasonable ???


>=20
>>  +static int validate_sctp_addrs(struct sock *sk, int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 struct sockaddr *addrs,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int len)
>>  +{
>>  +=A0=A0=A0 struct sockaddr *kaddrs;
>>  +=A0=A0=A0 int addrlen, err;
>>  +=A0=A0=A0 void *addr_buf;
>>  +=A0=A0=A0 struct sockaddr *address;
>>  +=A0=A0=A0 int walk_size =3D 0;
>>  +
>>  +=A0=A0=A0 /* Copy down the address information to process. */
>>  +=A0=A0=A0 if (unlikely(len <=3D 0))
>>  +=A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  +
>>  +=A0=A0=A0 /* Check the user passed a healthy pointer.=A0 */
>>  +=A0=A0=A0 if (unlikely(!access_ok(VERIFY_READ, addrs, (unsigned int)le=
n)))
>>  +=A0=A0=A0 =A0=A0=A0 return -EFAULT;
>>  +
>>  +=A0=A0=A0 /* Alloc space for the info in kernel memory.=A0 */
>>  +=A0=A0=A0 kaddrs =3D kmalloc((unsigned int)len, GFP_KERNEL);
>>  +=A0=A0=A0 if (unlikely(!kaddrs))
>>  +=A0=A0=A0 =A0=A0=A0 return -ENOMEM;
>>  +
>>  +=A0=A0=A0 if (__copy_from_user(kaddrs, addrs, (unsigned int)len)) {
>>  +=A0=A0=A0 =A0=A0=A0 kfree(kaddrs);
>>  +=A0=A0=A0 =A0=A0=A0 return -EFAULT;
>>  +=A0=A0=A0 }
>>  +
>>  +=A0=A0=A0 addr_buf =3D kaddrs;
>>  +=A0=A0=A0 /* Process list - may contain IPv4 or IPv6 addr's */
>>  +=A0=A0=A0 while (walk_size < (unsigned int)len) {
>>  +=A0=A0=A0 =A0=A0=A0 address =3D addr_buf;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 switch (address->sa_family) {
>>  +=A0=A0=A0 =A0=A0=A0 case PF_INET:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addrlen =3D sizeof(struct sockaddr_in);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 =A0=A0=A0 case PF_INET6:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 addrlen =3D sizeof(struct sockaddr_in6);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 =A0=A0=A0 default:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 kfree(kaddrs);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 err =3D -EINVAL;
>>  +=A0=A0=A0 =A0=A0=A0 if (optname =3D SCTP_SOCKOPT_BINDX_ADD) {
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 pr_info("SELinux: bindx addr: %pISpc\n",=
=20
> address);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D selinux_sk_bind(sk, address,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 addrlen,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 address->sa_family);
>>  +=A0=A0=A0 =A0=A0=A0 } else if (optname =3D SCTP_SOCKOPT_CONNECTX ||
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  optname =3D SCTP_SOCKOPT_CONNECTX3 =
||
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  optname =3D SCTP_SOCKOPT_CONNECTX_O=
LD) {
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 pr_info("SELinux: connectx addr: %pISpc\=
n",=20
> address);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D selinux_sk_connect(sk, address,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 addrlen);
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 =A0=A0=A0 if (err) {
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 kfree(kaddrs);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 =A0=A0=A0 addr_buf +=3D addrlen;
>>  +=A0=A0=A0 =A0=A0=A0 walk_size +=3D addrlen;
>>  +=A0=A0=A0 }
>>  +=A0=A0=A0 kfree(kaddrs);
>>  +=A0=A0=A0 return 0;
>>  +}
>>  +
>>  +/**
>>  + * selinux_sctp_validate_setsockopt - Check setsockopt values.
>>  + * @sk: the socket
>>  + * @level: contains the protocol level to validate
>>  + * @optname: contains the name of the option to validate
>>  + * @optval: contains the value(s) to set
>>  + * @optlen: contains the length of the value(s) to be set
>>  + *
>>  + * Description:
>>  + * Check whether SCTP socket options are allowed or not. Returns zero =
on
>>  + * success, negative values on failure.
>>  + *
>>  + * Supports the following socket options:
>>  + *
>>  + *=A0 =A0 SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to=
 be
>>  + *=A0 =A0 associated after (optionally) calling bind(3).
>>  + *=A0 =A0 sctp_bindx(3) - adds or removes a set of bind addresses on a=
 socket.
>>  + *
>>  + *=A0 =A0 SCTP_SOCKOPT_CONNECTX/_OLD - Allows the allocation of multip=
le
>>  + *=A0 =A0 addresses for reaching a peer (multi-homed).
>>  + *=A0 =A0 sctp_connectx(3) - initiate a connection on an SCTP socket u=
sing
>>  + *=A0 =A0 multiple destination addresses.
>>  + *=A0 =A0 NOTE: SCTP_SOCKOPT_CONNECTX3 is handled by the
>>  + *=A0 =A0 selinux_sctp_validate_getsockopt() function is it may return=
 an
>>  + *=A0 =A0 association id.
>>  + *
>>  + *=A0 Together they form SCTP associations with the address(s) passed =
over
>> =A0  the
>>  + *=A0 link to inform peer of any changes. As these two options can
>> =A0  support
>>  + *=A0 multiple addresses, each address is checked via
>> =A0  selinux_sk_bind() or
>>  + *=A0 selinux_sk_connect() to determine whether they
>> =A0  have the correct
>>  + *=A0 permissions:
>>  + *=A0 =A0  bindx_add: name_bind, node_bind + node SID + port SID via
>>  + *=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (portcon sctp port ctx) policy state=
ment.
>>  + *=A0 =A0  connectx:=A0 name_connect + port SID via (portcon sctp port=
 ctx)
>>  + *
>>  + *=A0 =A0 SCTP_SOCKOPT_BINDX_REM - As the addresses have already been
>>  + *=A0 =A0 allowed, only the bindx_rem permission is checked.
>>  + *
>>  + *=A0 =A0 SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max
>>  + *=A0 =A0 retransmissions.
>>  + *=A0 =A0 SCTP_PEER_ADDR_THLDS - Alter the thresholds.
>>  + *=A0 These require the set_params permission.
>>  + *
>>  + *=A0 =A0 SCTP_PRIMARY_ADDR - Set local primary address.
>>  + *=A0 =A0 SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
>>  + *=A0 =A0 association primary.
>>  + *=A0 These require the set_addr permission.
>>  +*/
>>  +int selinux_sctp_validate_setsockopt(struct sock *sk, int level, int
>> =A0  optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval, i=
nt optlen)
>>  +{
>>  +=A0=A0=A0 int err;
>>  +
>>  +=A0=A0=A0 if (level =3D SOL_SCTP) {
>>  +=A0=A0=A0 =A0=A0=A0 switch (optname) {
>>  +=A0=A0=A0 =A0=A0=A0 /* Allows additional addresses to be associated or=
 removed
>>  +=A0=A0=A0 =A0=A0=A0  * with an endpoint after (optionally) calling bin=
d(). */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_BINDX_ADD:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__BINDX_ADD);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D validate_sctp_addrs(sk, optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 (struct sockaddr __use=
r *)optval, optlen);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_BINDX_REM:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* The addresses have been checked as th=
ey were
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * added, so just see if allowed to be r=
emoved. */
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__BINDX_REM);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 /* Allows the allocation of multiple addresses for=
 reaching
>>  +=A0=A0=A0 =A0=A0=A0  * a peer (multi-homed). They form an SCTP=20
> "association".
>>  +=A0=A0=A0 =A0=A0=A0  * Note: CONNECTX3 requests go via getsockoption a=
s it can
>>  +=A0=A0=A0 =A0=A0=A0  * return an association id if required. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_CONNECTX:=A0=A0=A0 /* CONNECTX r=
equests. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_CONNECTX_OLD:=A0=A0=A0 /* CONNEC=
TX old requests. */
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__CONNECTX);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D validate_sctp_addrs(sk, optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 (struct sockaddr __use=
r *)optval, optlen);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 /* Alter heartbeats and address max retransmission=
s. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_PEER_ADDR_PARAMS:
>>  +=A0=A0=A0 =A0=A0=A0 /* Alter the thresholds. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_PEER_ADDR_THLDS:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__SET_PARAM=
S);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 /* Set local primary address. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_PRIMARY_ADDR:
>>  +=A0=A0=A0 =A0=A0=A0 /* Request peer sets address as association primar=
y. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SET_PEER_PRIMARY_ADDR:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__SET_ADDR);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 default:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 }
>>  +=A0=A0=A0 return 0;
>>  +}
>>  +
>>  +/**
>>  + * selinux_sctp_validate_getsockopt - Check getsockopt values.
>>  + * @sk: the socket
>>  + * @level: contains the protocol level to validate
>>  + * @optname: contains the name of the option to validate
>>  + * @optval: contains the value(s) to get
>>  + * @optlen: contains the length of the value(s) to get
>>  + *
>>  + * Description:
>>  + * Check whether SCTP socket options are allowed or not. Returns zero =
on
>>  + * success, negative values on failure.
>>  + *
>>  + * Supports the following socket options:
>>  + *
>>  + *=A0 =A0 SCTP_SOCKOPT_PEELOFF - Branch off an association into a new =
socket
>>  + *=A0 =A0 that will be a one-to-one style socket. As SELinux already h=
andles
>>  + *=A0 =A0 the creation of new sockets, only the peeloff permission is =
checked.
>=20
> This is interesting.=A0 How exactly is the new socket created by SCTP, is=
 the=20
> SELinux labeling setup correctly?=A0 What about the peer label?

The sctp code (net/sctp/socket.c sctp_do_peeloff()) calls sock_create() that
SELinux picks up. I did not touch the peer label as that was handled by
my bit of code in selinux_socket_sock_rcv_skb() that you want changed.

>=20
>>  + *=A0 =A0 SCTP_SOCKOPT_CONNECTX3 - Allows the allocation of multiple
>>  + *=A0 =A0 addresses for reaching a peer (multi-homed).
>>  + *=A0 =A0 sctp_connectx(3) - initiate a connection on an SCTP socket u=
sing
>>  + *=A0 =A0 multiple destination addresses. See comments in
>>  + *=A0 =A0 selinux_sctp_validate_setsockopt() for more detail.
>>  + *=A0 =A0 NOTES: 1) This option is a 'getsockopt' as it may also=20
> return an
>>  + *=A0 =A0 =A0 =A0 =A0 =A0 =A0 association id.
>>  + *=A0 =A0 =A0 =A0 =A0  2) This option requires some manipulation as th=
e address
>>  + *=A0 =A0 =A0 =A0 =A0 =A0 =A0 location and size are contained in 'stru=
ct
>> =A0  sctp_getaddrs_old'
>>  + *=A0 =A0 =A0 =A0 =A0 =A0 =A0 These need to be extracted and passed
>> =A0  to the common
>>  + *=A0 =A0 =A0 =A0 =A0 =A0 =A0 validate_sctp_addrs() function.
>>  +*/
>>  +int selinux_sctp_validate_getsockopt(struct sock *sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int level,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 char __user *optval,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 int __user *optlen)
>>  +{
>>  +=A0=A0=A0 int err;
>>  +
>>  +=A0=A0=A0 if (level =3D SOL_SCTP) {
>>  +=A0=A0=A0 =A0=A0=A0 struct sctp_getaddrs_old param;
>>  +=A0=A0=A0 =A0=A0=A0 int len;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 switch (optname) {
>>  +=A0=A0=A0 =A0=A0=A0 /* Branch off an association into a new socket. */
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_PEELOFF:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__PEELOFF);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 case SCTP_SOCKOPT_CONNECTX3:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D sock_has_perm(current, sk,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 SCTP_SOCKET__CONNECTX);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* The optval contains struct sctp_getad=
drs_old that
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * is then used to reference the address=
es to be
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * validated. */
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* TODO net/sctp/socket.c sctp_getsockop=
t_connectx3()
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * has #ifdef CONFIG_COMPAT with differe=
nt code.
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * Need to determine if needed here as n=
ot currently
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0  * implemented. */
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (get_user(len, optlen))
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EFAULT;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (len < sizeof(param))
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (copy_from_user(&param, optval, sizeo=
f(param)))
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -EFAULT;
>=20
> See my earlier comment about copy_from_user() and SELinux/LSM hooks.
>=20
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 len =3D param.addr_num;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D validate_sctp_addrs(sk, optname,
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 (struct sockaddr __user *)param.=
addrs, len);
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (err)
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return err;
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +
>>  +=A0=A0=A0 =A0=A0=A0 default:
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
>>  +=A0=A0=A0 =A0=A0=A0 }
>>  +=A0=A0=A0 }
>>  +=A0=A0=A0 return 0;
>>  +}
>=20
> --=20
> paul moore
> www.paul-moore.com
>=20
