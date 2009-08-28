From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 28 Aug 2009 13:48:04 +0000
Subject: Re: [PATCH 1/1] sctp: Sysctl configuration for IPv4 Address Scoping
Message-Id: <4A97E014.3040707@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
In-Reply-To: <571fb4000908280410y724790cbj226a661da61da209@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Bhaskar

Some comments...

Bhaskar Dutta wrote:
> Hi,
> 
> This patch introduces a new sysctl option to make IPv4 Address Scoping
> configurable <draft-stewart-tsvwg-sctp-ipv4-00.txt>.
> 
> In networking environments where DNAT rules in prerouting chains convert dest
> IP's to link-local/private IP addresses, SCTP connections fail to establish
> as the INIT chunk is dropped by the kernel due to address scope match failure.
> For example to support overlapping IP addresses a Layer-5 application listens
> on link local IP's, and there is a DNAT rule that maps the dest IP  to a  link
> local IP. Such applications never get the SCTP INIT if the address-scoping draft
> is strictly followed.
> 
> This sysctl configuration allows SCTP to function in such  unconventional
> networking environments.
> 
> Sysctl options:
> 0 - Disable IPv4 address scoping draft altogether
> 1 - Enable IPv4 address scoping (default, current behavior)
> 2 - Enable address scoping but allow IPv4 private addresses (as
> defined in draft)
> 3 - Enable address scoping but allow IPv4 link local address (as
> defined in draft)
> 
> Regards,
> Bhaskar
> 
> Patch generated against kernel 2.6.31-rc7.
> 
> Signed-off-by: Bhaskar Dutta <bhaskar.dutta@globallogic.com>
> ---
>  Documentation/networking/ip-sysctl.txt |   10 ++++++++++
>  include/linux/sysctl.h                 |    1 +
>  include/net/sctp/constants.h           |    7 +++++++
>  include/net/sctp/structs.h             |   11 +++++++++++
>  kernel/sysctl_check.c                  |    1 +
>  net/sctp/bind_addr.c                   |   19 +++++++++++++++++++
>  net/sctp/protocol.c                    |   11 ++++++-----
>  net/sctp/sysctl.c                      |   12 ++++++++++++
>  8 files changed, 67 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt
> b/Documentation/networking/ip-sysctl.txt
> index 8be7623..da07602 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -1282,6 +1282,16 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
>  sctp_wmem  - vector of 3 INTEGERs: min, default, max
>  	See tcp_wmem for a description.
> 
> +addr_scope_policy - INTEGER
> +	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
> +
> +	0   - Disable IPv4 address scoping
> +	1   - Enable IPv4 address scoping
> +	2   - Follow draft but allow IPv4 private addresses
> +	3   - Follow draft but allow IPv4 link local addresses
> +
> +	Default: 1
> +
> 
>  /proc/sys/net/core/*
>  dev_weight - INTEGER
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index e76d3b2..5f3db20 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -779,6 +779,7 @@ enum {
>  	NET_SCTP_SNDBUF_POLICY		 = 15,
>  	NET_SCTP_SACK_TIMEOUT		 = 16,
>  	NET_SCTP_RCVBUF_POLICY		 = 17,
> +	NET_SCTP_SCOPE_POLICY		 = 18,

Please use CTL_UNNUMBERED for the new sysctl entries.  That way
you will not have to touch this file and other generic sysctl files
as well.

>  };
> 
>  /* /proc/sys/net/bridge */
> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> index b05b055..699e6ae 100644
> --- a/include/net/sctp/constants.h
> +++ b/include/net/sctp/constants.h
> @@ -361,6 +361,13 @@ typedef enum {
>  	SCTP_SCOPE_UNUSABLE,		/* IPv4 unusable addresses */
>  } sctp_scope_t;
> 
> +typedef enum {
> +	SCTP_SCOPE_POLICY_DISABLE,	/* Disable IPv4 address scoping */
> +	SCTP_SCOPE_POLICY_ENABLE,	/* Enable IPv4 address scoping */
> +	SCTP_SCOPE_POLICY_PRIVATE,	/* Follow draft but allow IPv4 private addresses */
> +	SCTP_SCOPE_POLICY_LINK,		/* Follow draft but allow IPv4 link local
> addresses */
> +} sctp_scope_policy_t;
> +
>  /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
>   * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
>   * 192.88.99.0/24.
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index edfcacf..547fbb1 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -219,6 +219,16 @@ extern struct sctp_globals {
>  	/* Flag to idicate if SCTP-AUTH is enabled */
>  	int auth_enable;
> 
> +	/*
> +	 * Policy to control SCTP IPv4 address scoping
> +	 * 0   - Disable IPv4 address scoping
> +	 * 1   - Enable IPv4 address scoping
> +	 * 2   - Selectively allow only IPv4 private addresses
> +	 * 3   - Selectively allow only IPv4 link local address
> +	 */
> +	int ipv4_scope_policy;
> +	
> +

extra spacing...

>  	/* Flag to indicate whether computing and verifying checksum
>  	 * is disabled. */
>          int checksum_disable;
> @@ -252,6 +262,7 @@ extern struct sctp_globals {
>  #define sctp_port_hashtable		(sctp_globals.port_hashtable)
>  #define sctp_local_addr_list		(sctp_globals.local_addr_list)
>  #define sctp_local_addr_lock		(sctp_globals.addr_list_lock)
> +#define sctp_scope_policy		(sctp_globals.ipv4_scope_policy)
>  #define sctp_addip_enable		(sctp_globals.addip_enable)
>  #define sctp_addip_noauth		(sctp_globals.addip_noauth_enable)
>  #define sctp_prsctp_enable		(sctp_globals.prsctp_enable)
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index b38423c..6a813a4 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -604,6 +604,7 @@ static const struct trans_ctl_table
> trans_net_sctp_table[] = {
>  	{ NET_SCTP_SNDBUF_POLICY,	"sndbuf_policy" },
>  	{ NET_SCTP_SACK_TIMEOUT,	"sack_timeout" },
>  	{ NET_SCTP_RCVBUF_POLICY,	"rcvbuf_policy" },
> +	{ NET_SCTP_SCOPE_POLICY,	"addr_scope_policy" },
>  	{}
>  };

Don't need it if you use CTL_UNNUMBERED.

> 
> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
> index 6d5944a..6d8e0b0 100644
> --- a/net/sctp/bind_addr.c
> +++ b/net/sctp/bind_addr.c
> @@ -510,9 +510,28 @@ int sctp_in_scope(const union sctp_addr *addr,
> sctp_scope_t scope)
>  	 * of requested destination address, sender and receiver
>  	 * SHOULD include all of its addresses with level greater
>  	 * than or equal to L.
> +	 *
> +	 * Address scoping can be selectively controlled via sysctl
> +	 * option
>  	 */
> +	switch (sctp_scope_policy) {
> +	case SCTP_SCOPE_POLICY_DISABLE:
> +		return 1;
> +	case SCTP_SCOPE_POLICY_ENABLE:
>  	if (addr_scope <= scope)
>  		return 1;
> +		break;

If you are turning this into a switch statement, please use consistent
formatting.

> +	case SCTP_SCOPE_POLICY_PRIVATE:
> +		if (addr_scope <= scope || SCTP_SCOPE_PRIVATE = addr_scope)
> +			return 1;
> +		break;
> +	case SCTP_SCOPE_POLICY_LINK:
> +		if (addr_scope <= scope || SCTP_SCOPE_LINK = addr_scope)
> +			return 1;
> +		break;
> +	default:
> +		break;
> +	}
> 
>  	return 0;
>  }
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index a76da65..5c65cac 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -431,16 +431,14 @@ static int sctp_v4_available(union sctp_addr
> *addr, struct sctp_sock *sp)
>   * of requested destination address, sender and receiver
>   * SHOULD include all of its addresses with level greater
>   * than or equal to L.
> + *
> + * IPv4 scoping can be controlled through sysctl option
> + * net.sctp.addr_scope_policy
>   */
>  static sctp_scope_t sctp_v4_scope(union sctp_addr *addr)
>  {
>  	sctp_scope_t retval;
> 
> -	/* Should IPv4 scoping be a sysctl configurable option
> -	 * so users can turn it off (default on) for certain
> -	 * unconventional networking environments?
> -	 */
> -
>  	/* Check for unusable SCTP addresses. */
>  	if (IS_IPV4_UNUSABLE_ADDRESS(addr->v4.sin_addr.s_addr)) {
>  		retval =  SCTP_SCOPE_UNUSABLE;
> @@ -1259,6 +1257,9 @@ SCTP_STATIC __init int sctp_init(void)
>  	/* Disable AUTH by default. */
>  	sctp_auth_enable = 0;
> 
> +	/* Set SCOPE policy to enabled */
> +	sctp_scope_policy = SCTP_SCOPE_POLICY_ENABLE;
> +	
>  	sctp_sysctl_register();
> 
>  	INIT_LIST_HEAD(&sctp_address_families);
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 63eabbc..9f1b412 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -51,6 +51,7 @@ static int timer_max = 86400000; /* ms in one day */
>  static int int_max = INT_MAX;
>  static int sack_timer_min = 1;
>  static int sack_timer_max = 500;
> +static int addr_scope_max = 3; /* check sctp_scope_policy_t in
> include/net/sctp/constants.h for max entries */
> 
>  extern int sysctl_sctp_mem[3];
>  extern int sysctl_sctp_rmem[3];
> @@ -272,6 +273,17 @@ static ctl_table sctp_table[] = {
>  		.proc_handler	= proc_dointvec,
>  		.strategy	= sysctl_intvec
>  	},
> +	{
> +		.ctl_name	= NET_SCTP_SCOPE_POLICY,
> +		.procname	= "addr_scope_policy",
> +		.data		= &sctp_scope_policy,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,
> +		.extra1		= &zero,
> +		.extra2		= &addr_scope_max,
> +	},
>  	{ .ctl_name = 0 }
>  };
> 

Again, use CTL_UNNUMBERED.


Additionally, for a correct NAT traversal functionality, you might want to look
at http://tools.ietf.org/html/draft-stewart-behave-sctpnat-04

-vlad
-vlad
