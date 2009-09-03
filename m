From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 03 Sep 2009 19:12:41 +0000
Subject: Re: [PATCH 1/1] sctp: Sysctl configuration for IPv4 Address Scoping
Message-Id: <4AA01529.5010807@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
In-Reply-To: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Bhaskar Dutta wrote:
>> On Thu, Sep 3, 2009 at 7:13 PM, Vlad Yasevich<vladislav.yasevich@hp.com> wrote:
>>> Bhaskar Dutta wrote:
>>>> Hi Vlad,
>>>>
>>>> Thanks a lot for the comments. I have incorporated all of them in the
>>>> updated patch below.
>>> One think I forgot to mention the first time, and just thought of it,
>>> is that since you are introducing a new sysctl, it would be very good
>>> to document it in Documents/networking/ip-sysctl.txt.
>>>
>>> There is an SCTP section with all current sctp parameters documented.
>>>
>>> Thanks
>>> -vlad
>>>
>> It is already there. I'd added the new param at the end of the sctp section.
> 
> NM.  must have looked right past it.... ;)
> 
> I'll apply.

Looks like you mail client corrupted the patch such that it doesn't apply.
I'll fix it up this time, but please look at look at Documentation/email-clients
in the kernel tree.

-vlad

> 
> Thanks
> -vlad
> 
>>>>>> Documentation/networking/ip-sysctl.txt |   10 ++++++++++
>> Thanks,
>> Bhaskar
>>
>>
>>
>>>> Regards,
>>>> Bhaskar
>>>>
>>>>
>>>> Patch Summary:
>>>> ======>>>> This patch introduces a new sysctl option to make IPv4 Address Scoping
>>>> configurable <draft-stewart-tsvwg-sctp-ipv4-00.txt>.
>>>>
>>>> In networking environments where DNAT rules in iptables prerouting
>>>> chains convert destination IP's to link-local/private IP addresses,
>>>> SCTP connections fail to establish as the INIT chunk is dropped by the
>>>> kernel due to address scope match failure.
>>>> For example to support overlapping IP addresses (same IP address with
>>>> different vlan id) a Layer-5 application listens on link local IP's,
>>>> and there is a DNAT rule that maps the destination IP to a link local
>>>> IP. Such applications never get the SCTP INIT if the address-scoping
>>>> draft is strictly followed.
>>>>
>>>> This sysctl configuration allows SCTP to function in such
>>>> unconventional networking environments.
>>>>
>>>> Sysctl options:
>>>> 0 - Disable IPv4 address scoping draft altogether
>>>> 1 - Enable IPv4 address scoping (default, current behavior)
>>>> 2 - Enable address scoping but allow IPv4 private addresses in init/init-ack
>>>> 3 - Enable address scoping but allow IPv4 link local address in init/init-ack
>>>>
>>>> Patch generated against kernel 2.6.31-rc7.
>>>>
>>>>
>>>> Signed-off-by: Bhaskar Dutta <bhaskar.dutta@globallogic.com>
>>>> ---
>>>>  Documentation/networking/ip-sysctl.txt |   10 ++++++++++
>>>>  include/net/sctp/constants.h           |    7 +++++++
>>>>  include/net/sctp/structs.h             |   10 ++++++++++
>>>>  net/sctp/bind_addr.c                   |   21 ++++++++++++++++++++-
>>>>  net/sctp/protocol.c                    |   11 ++++++-----
>>>>  net/sctp/sysctl.c                      |   12 ++++++++++++
>>>>  6 files changed, 65 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/Documentation/networking/ip-sysctl.txt
>>>> b/Documentation/networking/ip-sysctl.txt
>>>> index 8be7623..da07602 100644
>>>> --- a/Documentation/networking/ip-sysctl.txt
>>>> +++ b/Documentation/networking/ip-sysctl.txt
>>>> @@ -1282,6 +1282,16 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
>>>>  sctp_wmem  - vector of 3 INTEGERs: min, default, max
>>>>       See tcp_wmem for a description.
>>>>
>>>> +addr_scope_policy - INTEGER
>>>> +     Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
>>>> +
>>>> +     0   - Disable IPv4 address scoping
>>>> +     1   - Enable IPv4 address scoping
>>>> +     2   - Follow draft but allow IPv4 private addresses
>>>> +     3   - Follow draft but allow IPv4 link local addresses
>>>> +
>>>> +     Default: 1
>>>> +
>>>>
>>>>  /proc/sys/net/core/*
>>>>  dev_weight - INTEGER
>>>> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
>>>> index b05b055..699e6ae 100644
>>>> --- a/include/net/sctp/constants.h
>>>> +++ b/include/net/sctp/constants.h
>>>> @@ -361,6 +361,13 @@ typedef enum {
>>>>       SCTP_SCOPE_UNUSABLE,            /* IPv4 unusable addresses */
>>>>  } sctp_scope_t;
>>>>
>>>> +typedef enum {
>>>> +     SCTP_SCOPE_POLICY_DISABLE,      /* Disable IPv4 address scoping */
>>>> +     SCTP_SCOPE_POLICY_ENABLE,       /* Enable IPv4 address scoping */
>>>> +     SCTP_SCOPE_POLICY_PRIVATE,      /* Follow draft but allow IPv4 private addresses */
>>>> +     SCTP_SCOPE_POLICY_LINK,         /* Follow draft but allow IPv4 link local
>>>> addresses */
>>>> +} sctp_scope_policy_t;
>>>> +
>>>>  /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
>>>>   * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
>>>>   * 192.88.99.0/24.
>>>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>>>> index edfcacf..de46ac6 100644
>>>> --- a/include/net/sctp/structs.h
>>>> +++ b/include/net/sctp/structs.h
>>>> @@ -219,6 +219,15 @@ extern struct sctp_globals {
>>>>       /* Flag to idicate if SCTP-AUTH is enabled */
>>>>       int auth_enable;
>>>>
>>>> +     /*
>>>> +      * Policy to control SCTP IPv4 address scoping
>>>> +      * 0   - Disable IPv4 address scoping
>>>> +      * 1   - Enable IPv4 address scoping
>>>> +      * 2   - Selectively allow only IPv4 private addresses
>>>> +      * 3   - Selectively allow only IPv4 link local address
>>>> +      */
>>>> +     int ipv4_scope_policy;
>>>> +
>>>>       /* Flag to indicate whether computing and verifying checksum
>>>>        * is disabled. */
>>>>          int checksum_disable;
>>>> @@ -252,6 +261,7 @@ extern struct sctp_globals {
>>>>  #define sctp_port_hashtable          (sctp_globals.port_hashtable)
>>>>  #define sctp_local_addr_list         (sctp_globals.local_addr_list)
>>>>  #define sctp_local_addr_lock         (sctp_globals.addr_list_lock)
>>>> +#define sctp_scope_policy            (sctp_globals.ipv4_scope_policy)
>>>>  #define sctp_addip_enable            (sctp_globals.addip_enable)
>>>>  #define sctp_addip_noauth            (sctp_globals.addip_noauth_enable)
>>>>  #define sctp_prsctp_enable           (sctp_globals.prsctp_enable)
>>>> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
>>>> index 6d5944a..7e33508 100644
>>>> --- a/net/sctp/bind_addr.c
>>>> +++ b/net/sctp/bind_addr.c
>>>> @@ -510,9 +510,28 @@ int sctp_in_scope(const union sctp_addr *addr,
>>>> sctp_scope_t scope)
>>>>        * of requested destination address, sender and receiver
>>>>        * SHOULD include all of its addresses with level greater
>>>>        * than or equal to L.
>>>> +      *
>>>> +      * Address scoping can be selectively controlled via sysctl
>>>> +      * option
>>>>        */
>>>> -     if (addr_scope <= scope)
>>>> +     switch (sctp_scope_policy) {
>>>> +     case SCTP_SCOPE_POLICY_DISABLE:
>>>>               return 1;
>>>> +     case SCTP_SCOPE_POLICY_ENABLE:
>>>> +             if (addr_scope <= scope)
>>>> +                     return 1;
>>>> +             break;
>>>> +     case SCTP_SCOPE_POLICY_PRIVATE:
>>>> +             if (addr_scope <= scope || SCTP_SCOPE_PRIVATE = addr_scope)
>>>> +                     return 1;
>>>> +             break;
>>>> +     case SCTP_SCOPE_POLICY_LINK:
>>>> +             if (addr_scope <= scope || SCTP_SCOPE_LINK = addr_scope)
>>>> +                     return 1;
>>>> +             break;
>>>> +     default:
>>>> +             break;
>>>> +     }
>>>>
>>>>       return 0;
>>>>  }
>>>> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
>>>> index a76da65..5c65cac 100644
>>>> --- a/net/sctp/protocol.c
>>>> +++ b/net/sctp/protocol.c
>>>> @@ -431,16 +431,14 @@ static int sctp_v4_available(union sctp_addr
>>>> *addr, struct sctp_sock *sp)
>>>>   * of requested destination address, sender and receiver
>>>>   * SHOULD include all of its addresses with level greater
>>>>   * than or equal to L.
>>>> + *
>>>> + * IPv4 scoping can be controlled through sysctl option
>>>> + * net.sctp.addr_scope_policy
>>>>   */
>>>>  static sctp_scope_t sctp_v4_scope(union sctp_addr *addr)
>>>>  {
>>>>       sctp_scope_t retval;
>>>>
>>>> -     /* Should IPv4 scoping be a sysctl configurable option
>>>> -      * so users can turn it off (default on) for certain
>>>> -      * unconventional networking environments?
>>>> -      */
>>>> -
>>>>       /* Check for unusable SCTP addresses. */
>>>>       if (IS_IPV4_UNUSABLE_ADDRESS(addr->v4.sin_addr.s_addr)) {
>>>>               retval =  SCTP_SCOPE_UNUSABLE;
>>>> @@ -1259,6 +1257,9 @@ SCTP_STATIC __init int sctp_init(void)
>>>>       /* Disable AUTH by default. */
>>>>       sctp_auth_enable = 0;
>>>>
>>>> +     /* Set SCOPE policy to enabled */
>>>> +     sctp_scope_policy = SCTP_SCOPE_POLICY_ENABLE;
>>>> +
>>>>       sctp_sysctl_register();
>>>>
>>>>       INIT_LIST_HEAD(&sctp_address_families);
>>>> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
>>>> index 63eabbc..ab7151d 100644
>>>> --- a/net/sctp/sysctl.c
>>>> +++ b/net/sctp/sysctl.c
>>>> @@ -51,6 +51,7 @@ static int timer_max = 86400000; /* ms in one day */
>>>>  static int int_max = INT_MAX;
>>>>  static int sack_timer_min = 1;
>>>>  static int sack_timer_max = 500;
>>>> +static int addr_scope_max = 3; /* check sctp_scope_policy_t in
>>>> include/net/sctp/constants.h for max entries */
>>>>
>>>>  extern int sysctl_sctp_mem[3];
>>>>  extern int sysctl_sctp_rmem[3];
>>>> @@ -272,6 +273,17 @@ static ctl_table sctp_table[] = {
>>>>               .proc_handler   = proc_dointvec,
>>>>               .strategy       = sysctl_intvec
>>>>       },
>>>> +     {
>>>> +             .ctl_name       = CTL_UNNUMBERED,
>>>> +             .procname       = "addr_scope_policy",
>>>> +             .data           = &sctp_scope_policy,
>>>> +             .maxlen         = sizeof(int),
>>>> +             .mode           = 0644,
>>>> +             .proc_handler   = &proc_dointvec_minmax,
>>>> +             .strategy       = &sysctl_intvec,
>>>> +             .extra1         = &zero,
>>>> +             .extra2         = &addr_scope_max,
>>>> +     },
>>>>       { .ctl_name = 0 }
>>>>  };
>>>>
>>>> --
>>>> 1.6.2.6
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

