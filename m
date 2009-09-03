From: Bhaskar Dutta <bhaskie@gmail.com>
Date: Thu, 03 Sep 2009 15:56:37 +0000
Subject: Re: [PATCH 1/1] sctp: Sysctl configuration for IPv4 Address Scoping
Message-Id: <571fb4000909030850obbb9393i7be8a7c0778717dd@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
In-Reply-To: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Thu, Sep 3, 2009 at 7:13 PM, Vlad Yasevich<vladislav.yasevich@hp.com> wr=
ote:
> Bhaskar Dutta wrote:
>> Hi Vlad,
>>
>> Thanks a lot for the comments. I have incorporated all of them in the
>> updated patch below.
>
> One think I forgot to mention the first time, and just thought of it,
> is that since you are introducing a new sysctl, it would be very good
> to document it in Documents/networking/ip-sysctl.txt.
>
> There is an SCTP section with all current sctp parameters documented.
>
> Thanks
> -vlad
>

It is already there. I'd added the new param at the end of the sctp section.
>>>> Documentation/networking/ip-sysctl.txt |   10 ++++++++++

Thanks,
Bhaskar



>>
>> Regards,
>> Bhaskar
>>
>>
>> Patch Summary:
>> =3D=3D=3D=3D=3D=3D>> This patch introduces a new sysctl option to make I=
Pv4 Address Scoping
>> configurable <draft-stewart-tsvwg-sctp-ipv4-00.txt>.
>>
>> In networking environments where DNAT rules in iptables prerouting
>> chains convert destination IP's to link-local/private IP addresses,
>> SCTP connections fail to establish as the INIT chunk is dropped by the
>> kernel due to address scope match failure.
>> For example to support overlapping IP addresses (same IP address with
>> different vlan id) a Layer-5 application listens on link local IP's,
>> and there is a DNAT rule that maps the destination IP to a link local
>> IP. Such applications never get the SCTP INIT if the address-scoping
>> draft is strictly followed.
>>
>> This sysctl configuration allows SCTP to function in such
>> unconventional networking environments.
>>
>> Sysctl options:
>> 0 - Disable IPv4 address scoping draft altogether
>> 1 - Enable IPv4 address scoping (default, current behavior)
>> 2 - Enable address scoping but allow IPv4 private addresses in init/init=
-ack
>> 3 - Enable address scoping but allow IPv4 link local address in init/ini=
t-ack
>>
>> Patch generated against kernel 2.6.31-rc7.
>>
>>
>> Signed-off-by: Bhaskar Dutta <bhaskar.dutta@globallogic.com>
>> ---
>> =A0Documentation/networking/ip-sysctl.txt | =A0 10 ++++++++++
>> =A0include/net/sctp/constants.h =A0 =A0 =A0 =A0 =A0 | =A0 =A07 +++++++
>> =A0include/net/sctp/structs.h =A0 =A0 =A0 =A0 =A0 =A0 | =A0 10 ++++++++++
>> =A0net/sctp/bind_addr.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 21 +++=
+++++++++++++++++-
>> =A0net/sctp/protocol.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 11 +=
+++++-----
>> =A0net/sctp/sysctl.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 12=
 ++++++++++++
>> =A06 files changed, 65 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.txt
>> b/Documentation/networking/ip-sysctl.txt
>> index 8be7623..da07602 100644
>> --- a/Documentation/networking/ip-sysctl.txt
>> +++ b/Documentation/networking/ip-sysctl.txt
>> @@ -1282,6 +1282,16 @@ sctp_rmem - vector of 3 INTEGERs: min, default, m=
ax
>> =A0sctp_wmem =A0- vector of 3 INTEGERs: min, default, max
>> =A0 =A0 =A0 See tcp_wmem for a description.
>>
>> +addr_scope_policy - INTEGER
>> + =A0 =A0 Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
>> +
>> + =A0 =A0 0 =A0 - Disable IPv4 address scoping
>> + =A0 =A0 1 =A0 - Enable IPv4 address scoping
>> + =A0 =A0 2 =A0 - Follow draft but allow IPv4 private addresses
>> + =A0 =A0 3 =A0 - Follow draft but allow IPv4 link local addresses
>> +
>> + =A0 =A0 Default: 1
>> +
>>
>> =A0/proc/sys/net/core/*
>> =A0dev_weight - INTEGER
>> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
>> index b05b055..699e6ae 100644
>> --- a/include/net/sctp/constants.h
>> +++ b/include/net/sctp/constants.h
>> @@ -361,6 +361,13 @@ typedef enum {
>> =A0 =A0 =A0 SCTP_SCOPE_UNUSABLE, =A0 =A0 =A0 =A0 =A0 =A0/* IPv4 unusable=
 addresses */
>> =A0} sctp_scope_t;
>>
>> +typedef enum {
>> + =A0 =A0 SCTP_SCOPE_POLICY_DISABLE, =A0 =A0 =A0/* Disable IPv4 address =
scoping */
>> + =A0 =A0 SCTP_SCOPE_POLICY_ENABLE, =A0 =A0 =A0 /* Enable IPv4 address s=
coping */
>> + =A0 =A0 SCTP_SCOPE_POLICY_PRIVATE, =A0 =A0 =A0/* Follow draft but allo=
w IPv4 private addresses */
>> + =A0 =A0 SCTP_SCOPE_POLICY_LINK, =A0 =A0 =A0 =A0 /* Follow draft but al=
low IPv4 link local
>> addresses */
>> +} sctp_scope_policy_t;
>> +
>> =A0/* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
>> =A0 * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/2=
4,
>> =A0 * 192.88.99.0/24.
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index edfcacf..de46ac6 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -219,6 +219,15 @@ extern struct sctp_globals {
>> =A0 =A0 =A0 /* Flag to idicate if SCTP-AUTH is enabled */
>> =A0 =A0 =A0 int auth_enable;
>>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Policy to control SCTP IPv4 address scoping
>> + =A0 =A0 =A0* 0 =A0 - Disable IPv4 address scoping
>> + =A0 =A0 =A0* 1 =A0 - Enable IPv4 address scoping
>> + =A0 =A0 =A0* 2 =A0 - Selectively allow only IPv4 private addresses
>> + =A0 =A0 =A0* 3 =A0 - Selectively allow only IPv4 link local address
>> + =A0 =A0 =A0*/
>> + =A0 =A0 int ipv4_scope_policy;
>> +
>> =A0 =A0 =A0 /* Flag to indicate whether computing and verifying checksum
>> =A0 =A0 =A0 =A0* is disabled. */
>> =A0 =A0 =A0 =A0 =A0int checksum_disable;
>> @@ -252,6 +261,7 @@ extern struct sctp_globals {
>> =A0#define sctp_port_hashtable =A0 =A0 =A0 =A0 =A0(sctp_globals.port_has=
htable)
>> =A0#define sctp_local_addr_list =A0 =A0 =A0 =A0 (sctp_globals.local_addr=
_list)
>> =A0#define sctp_local_addr_lock =A0 =A0 =A0 =A0 (sctp_globals.addr_list_=
lock)
>> +#define sctp_scope_policy =A0 =A0 =A0 =A0 =A0 =A0(sctp_globals.ipv4_sco=
pe_policy)
>> =A0#define sctp_addip_enable =A0 =A0 =A0 =A0 =A0 =A0(sctp_globals.addip_=
enable)
>> =A0#define sctp_addip_noauth =A0 =A0 =A0 =A0 =A0 =A0(sctp_globals.addip_=
noauth_enable)
>> =A0#define sctp_prsctp_enable =A0 =A0 =A0 =A0 =A0 (sctp_globals.prsctp_e=
nable)
>> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
>> index 6d5944a..7e33508 100644
>> --- a/net/sctp/bind_addr.c
>> +++ b/net/sctp/bind_addr.c
>> @@ -510,9 +510,28 @@ int sctp_in_scope(const union sctp_addr *addr,
>> sctp_scope_t scope)
>> =A0 =A0 =A0 =A0* of requested destination address, sender and receiver
>> =A0 =A0 =A0 =A0* SHOULD include all of its addresses with level greater
>> =A0 =A0 =A0 =A0* than or equal to L.
>> + =A0 =A0 =A0*
>> + =A0 =A0 =A0* Address scoping can be selectively controlled via sysctl
>> + =A0 =A0 =A0* option
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 if (addr_scope <=3D scope)
>> + =A0 =A0 switch (sctp_scope_policy) {
>> + =A0 =A0 case SCTP_SCOPE_POLICY_DISABLE:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 case SCTP_SCOPE_POLICY_ENABLE:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (addr_scope <=3D scope)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SCTP_SCOPE_POLICY_PRIVATE:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (addr_scope <=3D scope || SCTP_SCOPE_PRIVAT=
E =3D addr_scope)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 case SCTP_SCOPE_POLICY_LINK:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (addr_scope <=3D scope || SCTP_SCOPE_LINK =
=3D addr_scope)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 return 0;
>> =A0}
>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>> index a76da65..5c65cac 100644
>> --- a/net/sctp/protocol.c
>> +++ b/net/sctp/protocol.c
>> @@ -431,16 +431,14 @@ static int sctp_v4_available(union sctp_addr
>> *addr, struct sctp_sock *sp)
>> =A0 * of requested destination address, sender and receiver
>> =A0 * SHOULD include all of its addresses with level greater
>> =A0 * than or equal to L.
>> + *
>> + * IPv4 scoping can be controlled through sysctl option
>> + * net.sctp.addr_scope_policy
>> =A0 */
>> =A0static sctp_scope_t sctp_v4_scope(union sctp_addr *addr)
>> =A0{
>> =A0 =A0 =A0 sctp_scope_t retval;
>>
>> - =A0 =A0 /* Should IPv4 scoping be a sysctl configurable option
>> - =A0 =A0 =A0* so users can turn it off (default on) for certain
>> - =A0 =A0 =A0* unconventional networking environments?
>> - =A0 =A0 =A0*/
>> -
>> =A0 =A0 =A0 /* Check for unusable SCTP addresses. */
>> =A0 =A0 =A0 if (IS_IPV4_UNUSABLE_ADDRESS(addr->v4.sin_addr.s_addr)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D =A0SCTP_SCOPE_UNUSABLE;
>> @@ -1259,6 +1257,9 @@ SCTP_STATIC __init int sctp_init(void)
>> =A0 =A0 =A0 /* Disable AUTH by default. */
>> =A0 =A0 =A0 sctp_auth_enable =3D 0;
>>
>> + =A0 =A0 /* Set SCOPE policy to enabled */
>> + =A0 =A0 sctp_scope_policy =3D SCTP_SCOPE_POLICY_ENABLE;
>> +
>> =A0 =A0 =A0 sctp_sysctl_register();
>>
>> =A0 =A0 =A0 INIT_LIST_HEAD(&sctp_address_families);
>> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
>> index 63eabbc..ab7151d 100644
>> --- a/net/sctp/sysctl.c
>> +++ b/net/sctp/sysctl.c
>> @@ -51,6 +51,7 @@ static int timer_max =3D 86400000; /* ms in one day */
>> =A0static int int_max =3D INT_MAX;
>> =A0static int sack_timer_min =3D 1;
>> =A0static int sack_timer_max =3D 500;
>> +static int addr_scope_max =3D 3; /* check sctp_scope_policy_t in
>> include/net/sctp/constants.h for max entries */
>>
>> =A0extern int sysctl_sctp_mem[3];
>> =A0extern int sysctl_sctp_rmem[3];
>> @@ -272,6 +273,17 @@ static ctl_table sctp_table[] =3D {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 .proc_handler =A0 =3D proc_dointvec,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 .strategy =A0 =A0 =A0 =3D sysctl_intvec
>> =A0 =A0 =A0 },
>> + =A0 =A0 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 .ctl_name =A0 =A0 =A0 =3D CTL_UNNUMBERED,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .procname =A0 =A0 =A0 =3D "addr_scope_policy",
>> + =A0 =A0 =A0 =A0 =A0 =A0 .data =A0 =A0 =A0 =A0 =A0 =3D &sctp_scope_poli=
cy,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .maxlen =A0 =A0 =A0 =A0 =3D sizeof(int),
>> + =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0 =A0 =A0 =A0 =A0 =3D 0644,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .proc_handler =A0 =3D &proc_dointvec_minmax,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .strategy =A0 =A0 =A0 =3D &sysctl_intvec,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .extra1 =A0 =A0 =A0 =A0 =3D &zero,
>> + =A0 =A0 =A0 =A0 =A0 =A0 .extra2 =A0 =A0 =A0 =A0 =3D &addr_scope_max,
>> + =A0 =A0 },
>> =A0 =A0 =A0 { .ctl_name =3D 0 }
>> =A0};
>>
>> --
>> 1.6.2.6
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
