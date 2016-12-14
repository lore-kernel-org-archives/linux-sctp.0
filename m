From: Casey Schaufler <casey@schaufler-ca.com>
Date: Wed, 14 Dec 2016 17:02:41 +0000
Subject: Re: [RFC PATCH 1/1] kernel: Add SELinux SCTP protocol support
Message-Id: <78b647ff-2c25-8207-f1cc-4c13dbed53fd@schaufler-ca.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20161214133959.3078-1-richard_c_haines@btinternet.com>
In-Reply-To: <20161214133959.3078-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Haines <richard_c_haines@btinternet.com>, selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org, linux-security-module@vger.kernel.org

On 12/14/2016 5:39 AM, Richard Haines wrote:
> Add SELinux support for the SCTP protocol. The SELinux-sctp.txt document
> describes how the patch has been implemented with an example policy and
> tests using lkstcp-tools.

Please separate the LSM support from the SELinux support
into patches 1/2 and 2/2 respectively. The documentation
needs to be separated along the same lines as well. While
I am only mildly concerned about the SELinux implementation
I am very concerned about the LSM side.


> Patches to assist the testing of this kernel patch are:
> 1) Support the new SCTP portcon statement used in the test CIL policy
> module shown in Documentation/security/SELinux-sctp.txt can be found
> at [1].
> 2) Add SELinux support for the http://lksctp.sourceforge.net/ apps
> sctp_test.c and sctp_darn.c can be found at [2].
>
> Built and tested on Fedora 25 with linux-4.8 kernel.
>
> [1] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/selinux-Add-support-for-the-SCTP-portcon-keyword.patch
> [2] http://arctic.selinuxproject.org/~rhaines/selinux-sctp/lksctp-tools-Add-SELinux-support-to-sctp_test-and-sc.patch
>
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> ---
>  Documentation/security/SELinux-sctp.txt | 508 ++++++++++++++++++++++++++++++++
>  include/linux/lsm_hooks.h               |  27 ++
>  include/linux/security.h                |  16 +
>  net/sctp/sm_statefuns.c                 |  12 +
>  net/sctp/socket.c                       |  16 +
>  security/security.c                     |  18 ++
>  security/selinux/Makefile               |   2 +
>  security/selinux/hooks.c                | 124 +++++++-
>  security/selinux/include/classmap.h     |   4 +
>  security/selinux/include/sctp.h         |  50 ++++
>  security/selinux/include/sctp_private.h |  39 +++
>  security/selinux/netlabel.c             |   3 +
>  security/selinux/sctp.c                 | 194 ++++++++++++
>  13 files changed, 1002 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/security/SELinux-sctp.txt
>  create mode 100644 security/selinux/include/sctp.h
>  create mode 100644 security/selinux/include/sctp_private.h
>  create mode 100644 security/selinux/sctp.c
>
> diff --git a/Documentation/security/SELinux-sctp.txt b/Documentation/security/SELinux-sctp.txt
> new file mode 100644
> index 0000000..dcad4b2
> --- /dev/null
> +++ b/Documentation/security/SELinux-sctp.txt

Break this into SELinux-sctp.txt and LSM-sctp.txt so that
maintainers of other security modules can review and possibly
use the information about the LSM interface.

> @@ -0,0 +1,508 @@
> +                               SCTP SELinux Support
> +                              ===========
> +
> +Security Hooks
> +=======> +security_sk_setsockopt()
> +-------------------------
> +A new security hook security_sk_setsockopt() is introduced that checks
> +permissions before setting the options associated with sock @sk.
> +This is supported in security/selinux/hooks.c and net/sctp/socket.c
> +
> +An example usage is where sctp_getsockopt_connectx3() and
> +__sctp_setsockopt_connectx() manage the @optval data into a certain
> +state before security_sk_setsockopt is called for permission checks. This
> +means that the code to manage options does not need to be replicated in the
> +security module. See include/linux/lsm_hooks.h for details.
> +
> +security_sctp_assoc_request()
> +-----------------------------
> +security/selinux/hooks.c selinux_sctp_assoc_request() has been introduced to
> +support SCTP and obtains the sock peer context if first association and
> +also checks the association permission as shown in the "SCTP Peer Labeling
> +and Permission Checks" section below.

This hook needs to support permissions based on security module
data that may not be an SELinux context. A Smack label, for example,
or a combination in the proposed "extreme stacking" case. It's
possible that it does, but the description of the LSM interface
should make that clear.

> +
> +The security_sctp_assoc_request() security hook has been added to
> +net/sctp/sm_statefuns.c where it passes the sk and chunk->skb to the security
> +module.

What is this hook supposed to do?

> +
> +security_sk_clone()
> +--------------------
> +Added to net/sctp/socket.c sctp_sock_migrate() for cloning the security
> +context on a new socket.
> +
> +

All the following talk about SELinux policy needs to go in
the SELinux specific documentation.

> +Policy Statements
> +=========
> +A new object class "sctp_socket" has been introduced with the following SCTP
> +specific permissions: "association" "bindx_add" "bindx_rem" "connectx"
> +"peeloff" "set_addr" and "set_params". These are explained in the sections
> +below.
> +
> +Kernel policy language
> +-----------------------
> +class sctp_socket
> +class sctp_socket inherits socket { node_bind name_connect association
> +        bindx_add bindx_rem connectx peeloff set_addr set_params }
> +
> +CIL policy language
> +--------------------
> +(classcommon sctp_socket socket)
> +(class sctp_socket (node_bind name_connect association bindx_add bindx_rem
> +       connectx peeloff set_addr set_params))
> +(classorder (unordered sctp_socket))
> +
> +If userspace tools have been updated (see "Testing" section), then the portcon
> +statement may be used as shown in the following example:
> +(portcon sctp (2000 20000) (system_u object_r port_test_t ((s0) (s0))))
> +
> +Rule validation parameters used when 'network_peer_controls = 1':
> +-------------------------------------------------------------------------------
> +Rule  Source   Target     Class        Permissions
> +-------------------------------------------------------------------------------
> +allow domain_t self     : sctp_socket {connectx peeloff set_addr set_params};
> +allow domain_t socket_t : sctp_socket {bindx_add bindx_rem set_params peeloff};
> +allow socket_t port_t   : sctp_socket {name_bind name_connect};
> +allow socket_t node_t   : sctp_socket {node_bind};
> +allow socket_t peer_t   : sctp_socket {associate};
> +allow peer_t   netif_t  : netif       {ingress egress};
> +allow peer_t   node_t   : node        {recvfrom sendto};
> +allow socket_t peer_t   : peer        {recv};
> +allow domain_t packet_t : packet      {send recv relabelto}
> +
> +
> +SCTP Socket Option Permissions
> +===============> +The permissions consist of: "bindx_add" "bindx_rem" "connectx" "set_addr" and
> +"set_params" that are validated on setsockopt(2) calls, and "peeloff" that is
> +validated on getsockopt(2) calls.
> +
> +SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> +                         associated after (optionally) calling bind(2)
> +                         if given the "bind_add" permission.
> +
> +SCTP_SOCKOPT_CONNECTX  - Allows the allocation of multiple
> +                         addresses for reaching a multi-homed peer
> +                         if given the "connectx" permission.
> +
> +  Together they are used to form SCTP associations with information being
> +  passed over the link to inform the peer of any changes. As these two options
> +  can support multiple addresses, each address is checked via
> +  selinux_socket_bind() or selinux_socket_connect() to determine whether they
> +  have the correct permissions:
> +    bindx_add: bind, name_bind, node_bind + node SID + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +    connectx:  connect, name_connect + port SID via the
> +               (portcon sctp port ctx) policy statement.
> +
> +SCTP_SOCKOPT_BINDX_REM - Allows additional bind addresses to be removed
> +                         if given the "bind_rem" permission.
> +
> +SCTP_PEER_ADDR_PARAMS - Alter heartbeats and address max retransmissions.
> +SCTP_PEER_ADDR_THLDS  - Alter the thresholds.
> +SCTP_ASSOCINFO        - Alter association and endpoint parameters.
> + These require the "set_params" permission.
> +
> +SCTP_PRIMARY_ADDR          - Set local primary address.
> +SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as association primary.
> + These require the "set_addr" permission.
> +
> +SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket that
> +will be a one-to-one style socket. As SELinux already handles the creation
> +of new sockets, only the "peeloff" permission is checked.

Where is the SELinux specific decision? In the hook placement or the
SELinux code?

> +
> +
> +SCTP Peer Labeling and Permission Checks
> +====================> +An SCTP socket will only have one peer label assigned to it. This will be
> +assigned during the establishment of the first association. Once the peer label
> +has been assigned, the "association" permission will be checked as follows:
> +
> +       allow socket_t peer_t : sctp_socket { associate };
> +
> +As SCTP supports multiple endpoints on a single socket it is possible that
> +each interface may be configured with a different peer label, however it is
> +recommended that the labels are consistent.
> +
> +NOTES:
> +   1) If peer labeling is not enabled, then the peer context will always be
> +      SECINITSID_UNLABELED (unlabeled_t in Reference Policy).
> +
> +   2) If using NetLabel fallback labeling "netlabelctl unlbl ..." be aware
> +      that if a label is assigned to a specific interface, and that interface
> +      'goes down' (as in the "Multi-homing Test" section), then the NetLabel
> +      service will remove the entry. Therefore ensure that the network
> +      startup scripts call netlabelctl(8) to set the required label (see
> +      netlabel-config(8) helper script for details).
> +
> +   3) SCTP sockets inherit their labels from the creating process (unless
> +      there are policy rules to change this). They do NOT follow the TCP
> +      labeling method even for TCP-style sockets. For reference: TCP child
> +      sockets take the TE information from the parent server socket, but the
> +      MLS/MCS information from the connection when CIPSO is enabled.

Is this a detail of SCTP, of the SELinux implementation or of SELinux policy?

> +
> +   4) getpeercon(3) may be used by userspace apps to retrieve the sockets
> +      peer context.
> +
> +   5) The peer labeling rules apply as discussed in the following set of
> +      posts tagged "netlabel" at: http://www.paul-moore.com/blog/t

Is this SCTP, netlabel or SELinux?

> +
> +
> +      SCTP endpoint "A"                                SCTP endpoint "Z"
> +      =========                                ========> +    sctp_sf_do_prm_asoc()
> + Initiate an association to
> + SCTP peer endpoint "Z".
> + Send INIT first as we need to obtain
> + a peer label before checking whether
> + this is allowed or not. This will be
> + checked once the INIT ACK has been
> + received.
> +         INIT --------------------------------------------->
> +                                                   sctp_sf_do_5_1B_init()
> +                                                 Respond to an INIT chunk.
> +                                             SCTP peer endpoint "A" is
> +                                             asking for an association. Call
> +                                             security_sctp_assoc_request()
> +                                             to set the peer label if first
> +                                             association, then check ASSOCIATE
> +                                             permission:
> +                             allow socket_t peer_t : sctp_socket { associate };
> +                                             IF valid send:
> +          <----------------------------------------------- INIT ACK
> +          |                                  ELSE audit event and silently
> +          |                                       discard the packet.
> +    sctp_sf_do_5_1C_ack
> + Respond to an INIT ACK chunk.
> + SCTP peer endpoint"A" initiated
> + this association to SCTP peer
> + endpoint "Z". The security checks
> + are done now as we have a peer
> + label to check against, so call
> + security_sctp_assoc_request()
> + to set the peer label if first
> + association, then check ASSOCIATE
> + permission:
> +    allow socket_t peer_t : sctp_socket { associate };
> + IF valid send:
> +    COOKIE ECHO ------------------------------------------------>
> + ELSE audit event and silently                                  |
> +      discard the packet.                                       |
> +                                                                |
> +          <----------------------------------------------- COOKIE ACK
> +          |                                                     |
> +   sctp_sf_do_5_1E_ca                                  sctp_sf_do_5_1D_ce
> +      ESTABLISHED                                          ESTABLISHED
> +          |                                                     |
> +    ------------------------------------------------------------------
> +    |                     Association Established                    |
> +    ------------------------------------------------------------------
> +
> +
> +Testing
> +====
> +Requirements:
> + 1) libsepol 2.5 or greater. If the sctp portcon statement is required, then
> +    libsepol must be updated with the following patch:
> +         http://arctic.selinuxproject.org/~rhaines/selinux-sctp/
> +         selinux-Add-support-for-the-SCTP-portcon-keyword.patch
> +
> + 2) A patched version of lksctp-tools (1.0.17 used for testing) to support
> +    where sctp_test and sctp_darn have been modified to display the process,
> +    peer and socket fd SELinux contexts using the -Z option. This patch is
> +    available from:
> +         http://arctic.selinuxproject.org/~rhaines/selinux-sctp/
> +         lksctp-tools-Add-SELinux-support-to-sctp_test-and-sc.patch
> +
> +    lksctp-tools can be obtained by:
> +         git clone git://github.com/sctp/lksctp-tools.git
> +
> +    The tools can then be built by adding the patch first (as it modifies
> +    Makefile.am and configure.ac), then:
> +        ./bootstrap
> +        ./configure
> +        make
> +
> +
> +All lksctp-tools/src/func_tests run correctly in enforcing mode except when
> +specific permissions are denied (e.g. test_peeloff_v6 will fail with
> +"test_peeloff.c  1 BROK : sctp_peeloff: Permission denied").
> +
> +Tests involving removal of the "association" permission will wait, simply
> +because the INIT or INIT ACK packets will be silently discarded, however as
> +with all AVC denials they are audited in the audit log.
> +
> +The following sections describe the tests run using a CIL module added to the
> +Fedora 'targeted' policy. The CIL policy is listed at the end of this document.
> +
> +During tests the audit.log should be monitored as there are 'auditallow'
> +statements in the policy to show packet labels.
> +
> +The tests cover:
> + 1) All the lksctp-tools/src/func_tests. To check that permissions are
> +    correctly denied, use '(not ( <perm> ...' rules as shown in the
> +    CIL policy "Define SCTP class and permissions" section.
> +
> + 2) Using lksctp-tools/src/apps/sctp_test and sctp_darn that has been modified
> +    to display the process, peer and socket fd SELinux contexts using the -Z
> +    option.
> +
> + 3) Running lksctp-tools/src/apps/sctp_darn for multi-homing tests between
> +    client/server as shown in the following diagram:
> +
> +                      ------- Wireless Router -------
> +                     /                               \
> +                    /                                 \
> +                   /                                   \
> +             192.168.1.77                          192.168.1.66
> +                 /                                       \
> +           ----------  Ethernet         193.168.1.67 ----------
> +           | CLIENT | <----------------------------> | SERVER |
> +           ---------- 193.168.1.78                   ----------
> +
> +
> +;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Testing Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
> +
> +Tested on Fedora 25 with kernel 4.8.11, only the client side results are shown.
> +
> +Initial setup before running any tests (modifying interfaces and addresses
> +as required):
> +
> +1) Create and add the CIL policy module (see the "CIL policy module" section):
> +       semodule --priority 400 -i sctp_test_module.cil
> +
> +2) Update iptables to allow sctp traffic (MUST be run on client and server):
> +      iptables -I INPUT 1 -p sctp -j ACCEPT
> +
> +3) Set the fallback peer labels:
> +      netlabelctl unlbl add interface:lo address:127.0.0.0/8 label:system_u:object_r:netlabel_peer_lo_t:s0
> +      netlabelctl unlbl add interface:lo address:::1 label:system_u:object_r:netlabel_peer_lo_t:s0
> +      netlabelctl unlbl add interface:wlp6s0 address:192.168.1.0/24 label:system_u:object_r:netlabel_peer_wlan_t:s0
> +      netlabelctl unlbl add interface:enp7s0 address:193.168.1.0/24 label:system_u:object_r:netlabel_peer_eth_t:s0
> +
> +   The 'netlabelctl unlbl list' command can then be used to check the entries.
> +
> +4) Set SECMARK labels on SCTP packets. It is easier to paste the 'security' iptable
> +   entries below into a script:
> +
> +############################ SECMARK IPTABLE ENTRIES ########################
> +#
> +# Flush the security table first:
> +iptables -t security -F
> +
> +#-------------- INPUT IP Stream --------------------#
> +# This INPUT rule sets all packets to default_packet_t:
> +iptables -t security -A INPUT -j SECMARK --selctx system_u:object_r:default_packet_t:s0
> +
> +# These rules will replace the above context if sctp ports 1024:1035 are found in the packets:
> +iptables -t security -A INPUT -i lo -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_lo_t:s0
> +iptables -t security -A INPUT -i enp7s0 -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_eth_t:s0
> +iptables -t security -A INPUT -i wlp6s0 -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_wlan_t:s0
> +
> +iptables -t security -A INPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --save
> +
> +#-------------- OUTPUT IP Stream --------------------#
> +# This OUTPUT rule sets all packets to default_packet_t:
> +iptables -t security -A OUTPUT -j SECMARK --selctx system_u:object_r:default_packet_t:s0
> +
> +# These rules will replace the above context if sctp ports 1024:1035 are found in the packets:
> +iptables -t security -A OUTPUT -o lo -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_lo_t:s0
> +iptables -t security -A OUTPUT -o enp7s0 -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_eth_t:s0
> +iptables -t security -A OUTPUT -o wlp6s0 -p sctp -m multiport --port 1024:1035 -j SECMARK --selctx system_u:object_r:sctp_packet_wlan_t:s0
> +
> +iptables -t security -A OUTPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --save
> +
> +iptables -t security -L
> +#
> +#################### END OF IPTABLES SECURITY TABLE ##################
> +
> +;
> +;;;;;;;;;;;;;;;;;;;; Running func_tests ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
> +;
> +1) Paste below into script and run tests by passing over fqn path to lksctp-tools
> +   All tests should pass.
> +
> +   To test denial of permissions see the "Define SCTP class and permissions"
> +   section in the sample CIL policy.
> +
> +#!/bin/bash
> +
> +list="test_1_to_1_accept_close test_1_to_1_addrs test_1_to_1_connect test_1_to_1_connectx test_1_to_1_events test_1_to_1_initmsg_connect test_1_to_1_nonblock test_1_to_1_recvfrom test_1_to_1_recvmsg test_1_to_1_rtoinfo test_1_to_1_send test_1_to_1_sendmsg test_1_to_1_sendto test_1_to_1_shutdown test_1_to_1_socket_bind_listen test_1_to_1_sockopt test_1_to_1_threads test_assoc_abort test_assoc_shutdown test_autoclose test_basic test_basic_v6 test_connect test_connectx test_fragments test_fragments_v6 test_getname test_getname_v6 test_inaddr_any test_inaddr_any_v6 test_peeloff test_peeloff_v6 test_recvmsg test_sctp_sendrecvmsg test_sctp_sendrecvmsg_v6 test_sockopt test_sockopt_v6 test_tcp_style test_tcp_style_v6 test_timetolive test_timetolive_v6"
> +
> +if [ "$1" = "" ]; then
> +	echo "Require path to lksctp-tools"
> +	exit
> +fi
> +
> +for i in $list
> +    do  "$1/lksctp-tools/src/func_tests/$i"
> +        if [ $? != 0 ]; then
> +            echo -e "\nfunc_test $i FAILED\n"
> +            exit
> +       fi
> +    done
> +
> +echo -e "\nAll func_tests passed.\n"
> +
> +;
> +;;;;;;;;;;;;;;;;;;; Running sctp_test to check Peer contexts ;;;;;;;;;;;;;;;;;;
> +;
> +1) To check peer contexts run the following on the Server:
> +    /path/to/lksctp-tools/src/apps/sctp_test -H 192.168.1.66 -B 193.168.1.67 -P 1035 -l -Z
> +
> +2) To check WLAN peer context run the following on the Client:
> +    /path/to/lksctp-tools/src/apps/sctp_test -H 192.168.1.77 -P 1024 -C 192.168.1.66 -p 1035 -a 1 -c 4 -x 1 -o 2 -m 65515 -s -Z
> +
> +    The Client peer context should be:
> +       sendmsg peer context=system_u:object_r:netlabel_peer_wlan_t:s0
> +    The Client SECMARK context from the audit log should be:
> +       tcontext=system_u:object_r:sctp_packet_wlan_t:s0 tclass=packet
> +
> +3) To check ETH peer context run the following on the Client:
> +    /path/to/lksctp-tools/src/apps/sctp_test -H 193.168.1.78 -P 1024 -C 193.168.1.67 -p 1035 -a 1 -c 4 -x 1 -o 2 -m 65515 -s -Z
> +
> +    The Client peer context should be:
> +       sendmsg peer context=system_u:object_r:netlabel_peer_eth_t:s0
> +    The Client SECMARK context from the audit log should be:
> +       tcontext=system_u:object_r:sctp_packet_eth_t:s0 tclass=packet
> +
> +
> +;;;;;;;;;;;;;;;;;;;;; Running Multi-Homing Tests ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
> +
> +1) Run sctp_darn on server and client as follows:
> +    Server:
> +  /path/to/lksctp-tools/src/apps/sctp_darn -H 192.168.1.66 -B 193.168.1.67 -P 1035 -l -Z
> +    Client:
> +  /path/to/lksctp-tools/src/apps/sctp_darn -H 192.168.1.77 -B 193.168.1.78 -P 1024 -c 192.168.1.66 -c 193.168.1.67 -p 1035 -s -Z
> +
> +2) Send data from Client to Server - saddr 192.168.1.77 daddr 192.168.1.66
> +3) Turn Server Wifi off (192.168.1.66)
> +4) Send data from Client to Server - saddr 192.168.1.77 daddr 193.168.1.67
> +
> +Note that the peer context will be "netlabel_peer_wlan_t" even when the
> +Server side Wifi is turned off. This is because the first association
> +on the sctp socket sets the peer context to the first connection (in this
> +case from the Server's wireless lan addr (192.168.1.66). It is therefore
> +advised that the peer context is common across interfaces/addresses used
> +by SCTP, note however that the SECMARK packet contexts will reflect the
> +--selctx entry set in the iptables rules for interfaces/addresses.
> +
> +To set "netlabel_peer_eth_t", swap the peer socket 'connectx' (-c options)
> +addresses on the Client as follows:
> +
> +  /path/to/lksctp-tools/src/apps/sctp_darn -H 192.168.1.77 -B 193.168.1.78 -P 1024 -c 193.168.1.67 -c 192.168.1.66 -p 1035 -s -Z
> +
> +The first connection will then be from the Server's ethernet addr (193.168.1.67).
> +
> +tcpdump(8) or tshark(1) may be used to monitor traffic on each interface,
> +for example:
> +    tcpdump -v -x -i lo sctp
> +    tshark -O SCTP -P -x -i enp7s0
> +
> +;
> +;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CIL policy module ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
> +;
> +Paste the following CIL policy module into a file named "sctp_test_module.cil"
> +The policy needs to be modified if libsepol has NOT been updated to support the
> +new sctp portcon statement (see "Select SCTP portcon" section).
> +To load the policy use:
> +   semodule --priority 400 -i sctp_test_module.cil
> +
> +The policy MUST be loaded before attempting to set any netlabel or iptables
> +entries.
> +
> +Once testing is complete the CIL policy module may be removed by:
> +   semodule -r sctp_test_module
> +
> +;
> +;;;;;;;;;;;;;;;;;;;;;;;; CIL SCTP POLICY MODULE START ;;;;;;;;;;;;;;;;;;;;;;;;;
> +;
> +;;;;;;;;;;;;;;;;;;;;;;;; Define SCTP class and permissions ;;;;;;;;;;;;;;;;;;;;
> +;
> +; Add class for sctp_socket (requires libsepol 2.5+)
> +(classorder (unordered sctp_socket))
> +(classcommon sctp_socket socket)
> +(class sctp_socket (node_bind name_connect association bindx_add bindx_rem
> +    connectx peeloff set_addr set_params))
> +;
> +; Add permission for testing (see notes below)
> +(classpermission sctp_socket_all_perms)
> +;
> +; For testing whether the "bindx_add bindx_rem connectx peeloff set_addr
> +; set_params" permissions deny access use (not ( <perm> ... rules,
> +; for example:
> +;   (classpermissionset sctp_socket_all_perms (sctp_socket (not (set_params))))
> +;
> +; Once completed use this to grant all required permissions:
> +(classpermissionset sctp_socket_all_perms (sctp_socket (all)))
> +;
> +; To test that "node_bind name_connect association" permissions deny access
> +; remove the permissions from the applicable allow rules below.
> +;
> +;;;;;;;;;;;;;;;;;;;;;;;; Define peer labels and rules ;;;;;;;;;;;;;;;;;;;;;;;;;
> +;
> +(type netlabel_peer_lo_t)
> +(type netlabel_peer_wlan_t)
> +(type netlabel_peer_eth_t)
> +(roletype object_r netlabel_peer_wlan_t)
> +(roletype object_r netlabel_peer_eth_t)
> +(typeattribute sctp_peers)
> +(typeattributeset sctp_peers (netlabel_peer_lo_t netlabel_peer_wlan_t
> +    netlabel_peer_eth_t))
> +
> +(allow unconfined_t sctp_peers (sctp_socket (association)))
> +(allow unconfined_t sctp_peers (peer (recv)))
> +(allow sctp_peers netif_t (netif (ingress egress)))
> +(allow sctp_peers node_t (node (recvfrom)))
> +
> +;
> +;;;;;;;;;;;;;;;;;;; Define SECMARK packet labels and rules ;;;;;;;;;;;;;;;;;;;;
> +;
> +; All packets other than sctp with ports 1024 - 1035 are SECMARK'ed using
> +; iptables with default_packet_t. There is an 'allow' rule for this because
> +; SCTP func_tests try illegal addresses, so needed to pass tests, plus all
> +; other network traffic requires system access.
> +(type default_packet_t)
> +(type sctp_packet_lo_t)
> +(type sctp_packet_wlan_t)
> +(type sctp_packet_eth_t)
> +(roletype object_r default_packet_t)
> +(roletype object_r sctp_packet_lo_t)
> +(roletype object_r sctp_packet_wlan_t)
> +(roletype object_r sctp_packet_eth_t)
> +(typeattribute sctp_packets)
> +(typeattributeset sctp_packets (default_packet_t sctp_packet_lo_t
> +    sctp_packet_wlan_t sctp_packet_eth_t))
> +
> +(allow unconfined_t sctp_packets (packet(send recv relabelto)))
> +
> +; Add audit rule to monitor packet labeling:
> +(typeattribute audit_sctp_packets)
> +(typeattributeset audit_sctp_packets (sctp_packet_lo_t sctp_packet_wlan_t
> +    sctp_packet_eth_t))
> +(auditallow unconfined_t audit_sctp_packets (packet(send recv)))
> +
> +;
> +;;;;;;;;;;;;;;;;;;;;;;;;;;; Select SCTP portcon ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
> +;
> +; If libsepol has been updated to support the "sctp" portcon keyword then
> +; enable the TRUE set of statements, else use FALSE statement.
> +;
> +; TRUE:
> +    (type sctp_port_t)
> +    (roletype object_r sctp_port_t)
> +    ; Set to (1024 1035) as func_tests start at 1024 with 10 clients (10 + 1).
> +    (portcon sctp (1024 1035) (system_u object_r sctp_port_t ((s0) (s0))))
> +    ; This allows port 0 otherwise test_1_to_1_connectx will fail as it
> +    ; tests illegal addr.
> +    (portcon sctp 0 (system_u object_r sctp_port_t ((s0) (s0))))
> +    (allow unconfined_t sctp_port_t (sctp_socket (name_bind name_connect)))
> +;
> +; FALSE:
> +;    ; need to allow port initial SID:
> +;    (allow unconfined_t port_t (sctp_socket (name_bind name_connect)))
> +
> +; Common allow rules:
> +(allow unconfined_t self sctp_socket_all_perms)
> +(allow unconfined_t node_t (sctp_socket (node_bind)))
> +
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index f2af2af..6a7ddaf 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -813,6 +813,22 @@
>   *	@level contains the protocol level to set options for.
>   *	@optname contains the name of the option to set.
>   *	Return 0 if permission is granted.
> + * @sk_setsockopt:
> + *	Check permissions before setting the options associated with sock @sk.
> + *	This is equivalent to @socket_setsockopt, except that it has the
> + *	option parameters, as it is intended to support permission checking
> + *	of options and their parameters within network services.
> + *	An example usage is in net/sctp/socket.c where
> + *	sctp_getsockopt_connectx3() manages the @optval data into a certain
> + *	state before calling __sctp_setsockopt_connectx() that calls
> + *	@sk_setsockopt for permission checks. This means the code to manage
> + *	@optval does not need to be replicated in the security module.
> + *	@sk contains the sock structure.
> + *	@level contains the protocol level to set options for.
> + *	@optname contains the name of the option to set.
> + *	@optval contains the value(s) to set (already copied from userspace).
> + *	@optlen contains the length of the value(s) to be set.
> + *	Return 0 if permission is granted.
>   * @socket_shutdown:
>   *	Checks permission before all or part of a connection on the socket
>   *	@sock is shut down.
> @@ -902,6 +918,12 @@
>   *	This hook can be used by the module to update any security state
>   *	associated with the TUN device's security structure.
>   *	@security pointer to the TUN devices's security structure.
> + * @sctp_assoc_request:
> + *	Update socket peer label if first association on @sk then check
> + *	whether association allowed.
> + *	@sk contains the sock structure.
> + *	@skb skbuff of association packet (INIT or INIT ACK) being queried.
> + *	Return 0 on success, error on failure.
>   *
>   * Security hooks for XFRM operations.
>   *
> @@ -1582,6 +1604,8 @@ union security_list_options {
>  	int (*socket_getpeername)(struct socket *sock);
>  	int (*socket_getsockopt)(struct socket *sock, int level, int optname);
>  	int (*socket_setsockopt)(struct socket *sock, int level, int optname);
> +	int (*sk_setsockopt)(struct sock *sk, int level, int optname,
> +				    char *optval, int optlen);
>  	int (*socket_shutdown)(struct socket *sock, int how);
>  	int (*socket_sock_rcv_skb)(struct sock *sk, struct sk_buff *skb);
>  	int (*socket_getpeersec_stream)(struct socket *sock,
> @@ -1610,6 +1634,7 @@ union security_list_options {
>  	int (*tun_dev_attach_queue)(void *security);
>  	int (*tun_dev_attach)(struct sock *sk, void *security);
>  	int (*tun_dev_open)(void *security);
> +	int (*sctp_assoc_request)(struct sock *sk, struct sk_buff *skb);
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
> @@ -1819,6 +1844,7 @@ struct security_hook_heads {
>  	struct list_head socket_getpeername;
>  	struct list_head socket_getsockopt;
>  	struct list_head socket_setsockopt;
> +	struct list_head sk_setsockopt;
>  	struct list_head socket_shutdown;
>  	struct list_head socket_sock_rcv_skb;
>  	struct list_head socket_getpeersec_stream;
> @@ -1841,6 +1867,7 @@ struct security_hook_heads {
>  	struct list_head tun_dev_attach_queue;
>  	struct list_head tun_dev_attach;
>  	struct list_head tun_dev_open;
> +	struct list_head sctp_assoc_request;
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	struct list_head xfrm_policy_alloc_security;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index a6c6d5d..9572b8b 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1174,6 +1174,8 @@ int security_socket_getsockname(struct socket *sock);
>  int security_socket_getpeername(struct socket *sock);
>  int security_socket_getsockopt(struct socket *sock, int level, int optname);
>  int security_socket_setsockopt(struct socket *sock, int level, int optname);
> +int security_sk_setsockopt(struct sock *sk, int level, int optname,
> +				char *optval, int optlen);
>  int security_socket_shutdown(struct socket *sock, int how);
>  int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
>  int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> @@ -1200,6 +1202,7 @@ int security_tun_dev_create(void);
>  int security_tun_dev_attach_queue(void *security);
>  int security_tun_dev_attach(struct sock *sk, void *security);
>  int security_tun_dev_open(void *security);
> +int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb);
>  
>  #else	/* CONFIG_SECURITY_NETWORK */
>  static inline int security_unix_stream_connect(struct sock *sock,
> @@ -1289,6 +1292,13 @@ static inline int security_socket_setsockopt(struct socket *sock,
>  	return 0;
>  }
>  
> +static inline int security_sk_setsockopt(struct sock *sk, int level,
> +					    int optname, char *optval,
> +					    int optlen)
> +{
> +	return 0;
> +}
> +
>  static inline int security_socket_shutdown(struct socket *sock, int how)
>  {
>  	return 0;
> @@ -1392,6 +1402,12 @@ static inline int security_tun_dev_open(void *security)
>  {
>  	return 0;
>  }
> +
> +static inline int security_sctp_assoc_request(struct sock *sk,
> +			struct sk_buff *skb)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 920469e..920b101 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -315,6 +315,12 @@ sctp_disposition_t sctp_sf_do_5_1B_init(struct net *net,
>  	sctp_unrecognized_param_t *unk_param;
>  	int len;
>  
> +	/* Update socket peer label if first association then check
> +	 * whether association allowed.
> +	 */
> +	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	/* 6.10 Bundling
>  	 * An endpoint MUST NOT bundle INIT, INIT ACK or
>  	 * SHUTDOWN COMPLETE with any other chunks.
> @@ -508,6 +514,12 @@ sctp_disposition_t sctp_sf_do_5_1C_ack(struct net *net,
>  	struct sctp_chunk *err_chunk;
>  	struct sctp_packet *packet;
>  
> +	/* Update socket peer label if first association then check
> +	 * whether association allowed.
> +	 */
> +	if (security_sctp_assoc_request(ep->base.sk, chunk->skb))
> +		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> +
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>  
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 7b0e059..ff4f1a8 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1009,6 +1009,12 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	/* Do the work. */
>  	switch (op) {
>  	case SCTP_BINDX_ADD_ADDR:
> +		/* Allow security module to validate bindx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +					     SCTP_SOCKOPT_BINDX_ADD,
> +					     (char *)kaddrs, addrs_size);
> +		if (err)
> +			goto out;
>  		err = sctp_bindx_add(sk, kaddrs, addrcnt);
>  		if (err)
>  			goto out;
> @@ -1329,9 +1335,17 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
>  		err = -EFAULT;
>  	} else {
> +		/* Allow security module to validate connectx addresses. */
> +		err = security_sk_setsockopt(sk, SOL_SCTP,
> +					     SCTP_SOCKOPT_CONNECTX,
> +					    (char *)kaddrs, addrs_size);
> +		if (err)
> +			goto out_free;
> +
>  		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
>  	}
>  
> +out_free:
>  	kfree(kaddrs);
>  
>  	return err;
> @@ -7826,6 +7840,8 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>  		newsk->sk_state = SCTP_SS_ESTABLISHED;
>  	}
>  
> +	/* Ensure newsk has the same security attributes. */
> +	security_sk_clone(oldsk, newsk);
>  	release_sock(newsk);
>  }
>  
> diff --git a/security/security.c b/security/security.c
> index f825304..23ce9ea 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1307,6 +1307,14 @@ int security_socket_setsockopt(struct socket *sock, int level, int optname)
>  	return call_int_hook(socket_setsockopt, 0, sock, level, optname);
>  }
>  
> +int security_sk_setsockopt(struct sock *sk, int level, int optname,
> +				    char *optval, int optlen)
> +{
> +	return call_int_hook(sk_setsockopt, 0, sk, level, optname, optval,
> +				    optlen);
> +}
> +EXPORT_SYMBOL(security_sk_setsockopt);
> +
>  int security_socket_shutdown(struct socket *sock, int how)
>  {
>  	return call_int_hook(socket_shutdown, 0, sock, how);
> @@ -1439,6 +1447,12 @@ int security_tun_dev_open(void *security)
>  }
>  EXPORT_SYMBOL(security_tun_dev_open);
>  
> +int security_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
> +{
> +	return call_int_hook(sctp_assoc_request, 0, sk, skb);
> +}
> +EXPORT_SYMBOL(security_sctp_assoc_request);
> +
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
> @@ -1856,6 +1870,8 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.socket_getsockopt),
>  	.socket_setsockopt >  		LIST_HEAD_INIT(security_hook_heads.socket_setsockopt),
> +	.sk_setsockopt > +		LIST_HEAD_INIT(security_hook_heads.sk_setsockopt),
>  	.socket_shutdown >  		LIST_HEAD_INIT(security_hook_heads.socket_shutdown),
>  	.socket_sock_rcv_skb > @@ -1897,6 +1913,8 @@ struct security_hook_heads security_hook_heads = {
>  	.tun_dev_attach >  		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach),
>  	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
> +	.sctp_assoc_request > +		LIST_HEAD_INIT(security_hook_heads.sctp_assoc_request),
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	.xfrm_policy_alloc_security > diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index 3411c33..f60a8a3 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -13,6 +13,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
>  
>  selinux-$(CONFIG_NETLABEL) += netlabel.o
>  
> +selinux-$(subst m,y,$(CONFIG_IP_SCTP)) += sctp.o
> +
>  ccflags-y := -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
>  
>  $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e15e560..491599c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -65,6 +65,7 @@
>  #include <linux/tcp.h>
>  #include <linux/udp.h>
>  #include <linux/dccp.h>
> +#include <linux/sctp.h>
>  #include <linux/quota.h>
>  #include <linux/un.h>		/* for Unix socket types */
>  #include <net/af_unix.h>	/* for Unix socket types */
> @@ -93,6 +94,7 @@
>  #include "netlabel.h"
>  #include "audit.h"
>  #include "avc_ss.h"
> +#include "sctp.h"
>  
>  /* SECMARK reference count */
>  static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
> @@ -1280,8 +1282,11 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
>  	case PF_INET6:
>  		switch (type) {
>  		case SOCK_STREAM:
> +		case SOCK_SEQPACKET:
>  			if (default_protocol_stream(protocol))
>  				return SECCLASS_TCP_SOCKET;
> +			else if (protocol = IPPROTO_SCTP)
> +				return SECCLASS_SCTP_SOCKET;
>  			else
>  				return SECCLASS_RAWIP_SOCKET;
>  		case SOCK_DGRAM:
> @@ -4034,6 +4039,23 @@ static int selinux_parse_skb_ipv4(struct sk_buff *skb,
>  		break;
>  	}
>  
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +	case IPPROTO_SCTP: {
> +		struct sctphdr _sctph, *sh;
> +
> +		if (ntohs(ih->frag_off) & IP_OFFSET)
> +			break;
> +
> +		offset += ihlen;
> +		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
> +		if (sh = NULL)
> +			break;
> +
> +		ad->u.net->sport = sh->source;
> +		ad->u.net->dport = sh->dest;
> +		break;
> +	}
> +#endif
>  	default:
>  		break;
>  	}
> @@ -4107,6 +4129,19 @@ static int selinux_parse_skb_ipv6(struct sk_buff *skb,
>  		break;
>  	}
>  
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +	case IPPROTO_SCTP: {
> +		struct sctphdr _sctph, *sh;
> +
> +		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
> +		if (sh = NULL)
> +			break;
> +
> +		ad->u.net->sport = sh->source;
> +		ad->u.net->dport = sh->dest;
> +		break;
> +	}
> +#endif
>  	/* includes fragments */
>  	default:
>  		break;
> @@ -4236,7 +4271,7 @@ static int socket_sockcreate_sid(const struct task_security_struct *tsec,
>  				       socksid);
>  }
>  
> -static int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
> +int sock_has_perm(struct task_struct *task, struct sock *sk, u32 perms)
>  {
>  	struct sk_security_struct *sksec = sk->sk_security;
>  	struct common_audit_data ad;
> @@ -4306,7 +4341,8 @@ static int selinux_socket_post_create(struct socket *sock, int family,
>     Need to determine whether we should perform a name_bind
>     permission check between the socket and the port number. */
>  
> -static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
> +int selinux_socket_bind(struct socket *sock, struct sockaddr *address,
> +								int addrlen)
>  {
>  	struct sock *sk = sock->sk;
>  	u16 family;
> @@ -4318,8 +4354,8 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
>  
>  	/*
>  	 * If PF_INET or PF_INET6, check name_bind permission for the port.
> -	 * Multiple address binding for SCTP is not supported yet: we just
> -	 * check the first address now.
> +	 * Multiple address binding for SCTP is supported via
> +	 * selinux_sctp_setsockopt().
>  	 */
>  	family = sk->sk_family;
>  	if (family = PF_INET || family = PF_INET6) {
> @@ -4377,6 +4413,10 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
>  			node_perm = DCCP_SOCKET__NODE_BIND;
>  			break;
>  
> +		case SECCLASS_SCTP_SOCKET:
> +			node_perm = SCTP_SOCKET__NODE_BIND;
> +			break;
> +
>  		default:
>  			node_perm = RAWIP_SOCKET__NODE_BIND;
>  			break;
> @@ -4405,7 +4445,8 @@ out:
>  	return err;
>  }
>  
> -static int selinux_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
> +int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
> +								int addrlen)
>  {
>  	struct sock *sk = sock->sk;
>  	struct sk_security_struct *sksec = sk->sk_security;
> @@ -4416,10 +4457,12 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
>  		return err;
>  
>  	/*
> -	 * If a TCP or DCCP socket, check name_connect permission for the port.
> +	 * If a TCP, DCCP or SCTP socket, check name_connect permission
> +	 * for the port.
>  	 */
>  	if (sksec->sclass = SECCLASS_TCP_SOCKET ||
> -	    sksec->sclass = SECCLASS_DCCP_SOCKET) {
> +	    sksec->sclass = SECCLASS_DCCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET) {
>  		struct common_audit_data ad;
>  		struct lsm_network_audit net = {0,};
>  		struct sockaddr_in *addr4 = NULL;
> @@ -4443,8 +4486,12 @@ static int selinux_socket_connect(struct socket *sock, struct sockaddr *address,
>  		if (err)
>  			goto out;
>  
> -		perm = (sksec->sclass = SECCLASS_TCP_SOCKET) ?
> -		       TCP_SOCKET__NAME_CONNECT : DCCP_SOCKET__NAME_CONNECT;
> +		if (sksec->sclass = SECCLASS_TCP_SOCKET)
> +			perm = TCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_DCCP_SOCKET)
> +			perm = DCCP_SOCKET__NAME_CONNECT;
> +		else if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> +			perm = SCTP_SOCKET__NAME_CONNECT;
>  
>  		ad.type = LSM_AUDIT_DATA_NET;
>  		ad.u.net = &net;
> @@ -4516,13 +4563,35 @@ static int selinux_socket_setsockopt(struct socket *sock, int level, int optname
>  	if (err)
>  		return err;
>  
> +	err = selinux_sctp_setsockopt(sock->sk, level, optname, NULL, 0);
> +	if (err)
> +		return err;
> +
>  	return selinux_netlbl_socket_setsockopt(sock, level, optname);
>  }
>  
> +static int selinux_sk_setsockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	int err;
> +
> +	err = sock_has_perm(current, sk, SOCKET__SETOPT);
> +	if (err)
> +		return err;
> +
> +	return selinux_sctp_setsockopt(sk, level, optname, optval, optlen);
> +}
> +
>  static int selinux_socket_getsockopt(struct socket *sock, int level,
>  				     int optname)
>  {
> -	return sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	int err;
> +
> +	err = sock_has_perm(current, sock->sk, SOCKET__GETOPT);
> +	if (err)
> +		return err;
> +
> +	return selinux_sctp_getsockopt(sock->sk, level, optname);
>  }
>  
>  static int selinux_socket_shutdown(struct socket *sock, int how)
> @@ -4715,7 +4784,8 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
>  	u32 peer_sid = SECSID_NULL;
>  
>  	if (sksec->sclass = SECCLASS_UNIX_STREAM_SOCKET ||
> -	    sksec->sclass = SECCLASS_TCP_SOCKET)
> +	    sksec->sclass = SECCLASS_TCP_SOCKET ||
> +	    sksec->sclass = SECCLASS_SCTP_SOCKET)
>  		peer_sid = sksec->peer_sid;
>  	if (peer_sid = SECSID_NULL)
>  		return -ENOPROTOOPT;
> @@ -4828,6 +4898,36 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
>  	sksec->sclass = isec->sclass;
>  }
>  
> +static int selinux_sctp_assoc_request(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct sk_security_struct *sksec = sk->sk_security;
> +	struct common_audit_data ad;
> +	struct lsm_network_audit net = {0,};
> +	u8 peerlbl_active;
> +	int err;
> +
> +	peerlbl_active = selinux_peerlbl_enabled();
> +
> +	if (sksec->peer_sid = SECINITSID_UNLABELED && peerlbl_active) {
> +		/* Here because this is the first association on this
> +		 * socket that is always unlabeled, therefore set
> +		 * sksec->peer_sid to new peer ctx. For further info see:
> +		 *    Documentation/security/SELinux-sctp.txt
> +		 */
> +		err = selinux_skb_peerlbl_sid(skb, sk->sk_family,
> +				    &sksec->peer_sid);
> +		if (err)
> +			return err;
> +	}
> +
> +	ad.type = LSM_AUDIT_DATA_NET;
> +	ad.u.net = &net;
> +	ad.u.net->sk = sk;
> +
> +	return avc_has_perm(sksec->sid, sksec->peer_sid, sksec->sclass,
> +				    SCTP_SOCKET__ASSOCIATION, &ad);
> +}
> +
>  static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
>  				     struct request_sock *req)
>  {
> @@ -6243,6 +6343,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(socket_getpeername, selinux_socket_getpeername),
>  	LSM_HOOK_INIT(socket_getsockopt, selinux_socket_getsockopt),
>  	LSM_HOOK_INIT(socket_setsockopt, selinux_socket_setsockopt),
> +	LSM_HOOK_INIT(sk_setsockopt, selinux_sk_setsockopt),
>  	LSM_HOOK_INIT(socket_shutdown, selinux_socket_shutdown),
>  	LSM_HOOK_INIT(socket_sock_rcv_skb, selinux_socket_sock_rcv_skb),
>  	LSM_HOOK_INIT(socket_getpeersec_stream,
> @@ -6253,6 +6354,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(sk_clone_security, selinux_sk_clone_security),
>  	LSM_HOOK_INIT(sk_getsecid, selinux_sk_getsecid),
>  	LSM_HOOK_INIT(sock_graft, selinux_sock_graft),
> +	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
>  	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
>  	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
>  	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 1f1f4b2..353183a 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -165,5 +165,9 @@ struct security_class_mapping secclass_map[] = {
>  	  { COMMON_CAP_PERMS, NULL } },
>  	{ "cap2_userns",
>  	  { COMMON_CAP2_PERMS, NULL } },
> +	{ "sctp_socket",
> +	  { COMMON_SOCK_PERMS, "node_bind", "name_connect", "association",
> +	    "bindx_add", "bindx_rem", "connectx", "peeloff", "set_addr",
> +	    "set_params", NULL } },
>  	{ NULL }
>    };
> diff --git a/security/selinux/include/sctp.h b/security/selinux/include/sctp.h
> new file mode 100644
> index 0000000..cee8e2d
> --- /dev/null
> +++ b/security/selinux/include/sctp.h
> @@ -0,0 +1,50 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#ifndef _SELINUX_SCTP_H_
> +#define _SELINUX_SCTP_H_
> +
> +#include <linux/types.h>
> +#include <linux/net.h>
> +#include <net/sock.h>
> +#include "objsec.h"
> +
> +#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> +int selinux_sctp_setsockopt(struct sock *sk,
> +				    int level,
> +				    int optname,
> +				    char *optval,
> +				    int optlen);
> +
> +int selinux_sctp_getsockopt(struct sock *sk,
> +				    int level,
> +				    int optname);
> +#else
> +static inline int selinux_sctp_setsockopt(struct sock *sk,
> +				    int level,
> +				    int optname,
> +				    char *optval,
> +				    int optlen)
> +{
> +	return 0;
> +}
> +static inline int selinux_sctp_getsockopt(struct sock *sk,
> +				    int level,
> +				    int optname)
> +{
> +	return 0;
> +}
> +#endif  /* CONFIG_IP_SCTP */
> +
> +#endif
> diff --git a/security/selinux/include/sctp_private.h b/security/selinux/include/sctp_private.h
> new file mode 100644
> index 0000000..eaa9f4c
> --- /dev/null
> +++ b/security/selinux/include/sctp_private.h
> @@ -0,0 +1,39 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/net.h>
> +#include <net/sock.h>
> +#include <linux/sctp.h>
> +#include <uapi/linux/sctp.h>	/* For bindx setsocket option checks */
> +#include <net/ip.h>
> +#include <linux/skbuff.h>
> +
> +#include "security.h"
> +#include "avc.h"
> +#include "objsec.h"
> +
> +extern int sock_has_perm(struct task_struct *task,
> +				    struct sock *sk, u32 perms);
> +
> +extern int selinux_socket_bind(struct socket *sock,
> +				    struct sockaddr *address,
> +					    int addrlen);
> +
> +extern int selinux_socket_connect(struct socket *sock,
> +				    struct sockaddr *address,
> +				    int addrlen);
> +
> diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
> index aaba667..300a195 100644
> --- a/security/selinux/netlabel.c
> +++ b/security/selinux/netlabel.c
> @@ -399,6 +399,9 @@ int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
>  	case SECCLASS_TCP_SOCKET:
>  		perm = TCP_SOCKET__RECVFROM;
>  		break;
> +	case SECCLASS_SCTP_SOCKET:
> +		perm = SCTP_SOCKET__RECVFROM;
> +		break;
>  	default:
>  		perm = RAWIP_SOCKET__RECVFROM;
>  	}
> diff --git a/security/selinux/sctp.c b/security/selinux/sctp.c
> new file mode 100644
> index 0000000..bd25712
> --- /dev/null
> +++ b/security/selinux/sctp.c
> @@ -0,0 +1,194 @@
> +/*
> + * SELinux SCTP Support
> + *
> + * Provides security checks for the SCTP protocol.
> + *
> + * Author: Richard Haines <richard_c_haines@btinternet.com>
> + *
> + * This program is free software;  you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include "sctp_private.h"
> +
> +/**
> + * selinux_sctp_setsockopt - Check setsockopt values.
> + * @sk: the socket
> + * @level: contains the protocol level to validate
> + * @optname: contains the name of the option to validate
> + * @optval: contains the value(s) to set
> + * @optlen: contains the length of the value(s) to be set
> + *
> + * Description:
> + * Check whether SCTP socket options are allowed or not. Returns zero on
> + * success, negative values on failure.
> + *
> + * setsockopt(2) option support:
> + *
> + *    SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> + *                             associated after (optionally) calling bind(3).
> + *                             sctp_bindx(3) adds or removes a set of bind
> + *                             addresses on a socket.
> + *
> + *    SCTP_SOCKOPT_CONNECTX - Allows the allocation of multiple addresses for
> + *                            reaching a peer (multi-homed).
> + *                            sctp_connectx(3) initiates a connection on an
> + *                            SCTP socket using multiple destination addresses.
> + *                            May also return an association id.
> + *
> + *   Together they form SCTP associations and will be passed over the
> + *   link to inform peer of any changes. As these two options can support
> + *   multiple addresses, each address is checked via selinux_socket_bind() or
> + *   selinux_socket_connect() to determine whether they have the correct
> + *   permissions:
> + *     bindx_add: bind, name_bind, node_bind + node SID + port SID via the
> + *                (portcon sctp port ctx) policy statement.
> + *     connectx:  connect, name_connect + port SID via the
> + *                (portcon sctp port ctx) policy statement.
> + *
> + *  These options require set_params permission:
> + *    SCTP_SOCKOPT_BINDX_REM - As the addresses would have already been
> + *                             allowed, only the bindx_rem permission
> + *                             is checked.
> + *
> + *    SCTP_PEER_ADDR_PARAMS  - Set heartbeats and address max
> + *                             retransmissions.
> + *
> + *    SCTP_PEER_ADDR_THLDS   - Set thresholds.
> + *
> + *    SCTP_ASSOCINFO         - Set association and endpoint parameters.
> + *
> + *  These options require the set_addr permission.
> + *    SCTP_PRIMARY_ADDR          - Set local primary address.
> + *
> + *    SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
> + *                                 association primary.
> + */
> +int selinux_sctp_setsockopt(struct sock *sk, int level, int optname,
> +					    char *optval, int optlen)
> +{
> +	int err, addrlen;
> +	void *addr_buf;
> +	struct sockaddr *address;
> +	struct socket *sock;
> +	int walk_size = 0;
> +
> +	if (level != SOL_SCTP || level != IPPROTO_SCTP)
> +		return 0;
> +
> +	switch (optname) {
> +	case SCTP_SOCKOPT_BINDX_ADD:
> +	case SCTP_SOCKOPT_CONNECTX:
> +		/* Note that for SCTP_SOCKOPT_BINDX_ADD and
> +		 * SCTP_SOCKOPT_CONNECTX the sctp kernel code has already
> +		 * copied the optval to kernel space. See net/sctp/socket.c
> +		 * security_sk_setsockopt() calls.
> +		 */
> +		err = sock_has_perm(current, sk,
> +			    (optname = SCTP_SOCKOPT_BINDX_ADD ?
> +			     SCTP_SOCKET__BINDX_ADD :
> +			     SCTP_SOCKET__CONNECTX));
> +		if (err)
> +			return err;
> +
> +		sock = sk->sk_socket;
> +		addr_buf = optval;
> +		/* Process list - may contain IPv4 or IPv6 addr's */
> +		while (walk_size < optlen) {
> +			address = addr_buf;
> +
> +			switch (address->sa_family) {
> +			case PF_INET:
> +				addrlen = sizeof(struct sockaddr_in);
> +				break;
> +			case PF_INET6:
> +				addrlen = sizeof(struct sockaddr_in6);
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +
> +			err = -EINVAL;
> +			if (optname = SCTP_SOCKOPT_BINDX_ADD) {
> +				err = selinux_socket_bind(sock,
> +					    address, addrlen);
> +			} else if (optname = SCTP_SOCKOPT_CONNECTX) {
> +				err = selinux_socket_connect(sock,
> +					    address, addrlen);
> +			}
> +			if (err)
> +				return err;
> +
> +			addr_buf += addrlen;
> +			walk_size += addrlen;
> +		}
> +		break;
> +
> +	case SCTP_SOCKOPT_BINDX_REM:
> +		/* The addresses have been checked as they were
> +		 * added, so just see if allowed to be removed.
> +		 */
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__BINDX_REM);
> +		if (err)
> +			return err;
> +		break;
> +
> +	/* Set heartbeats and address max retransmissions. */
> +	case SCTP_PEER_ADDR_PARAMS:
> +	/* Set thresholds. */
> +	case SCTP_PEER_ADDR_THLDS:
> +	/* Set association and endpoint parameters */
> +	case SCTP_ASSOCINFO:
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__SET_PARAMS);
> +		if (err)
> +			return err;
> +		break;
> +
> +	/* Set local primary address. */
> +	case SCTP_PRIMARY_ADDR:
> +	/* Request peer sets address as association primary. */
> +	case SCTP_SET_PEER_PRIMARY_ADDR:
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__SET_ADDR);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * selinux_sctp_getsockopt - Check getsockopt values.
> + * @sk: the socket
> + * @level: contains the protocol level to validate
> + * @optname: contains the name of the option to validate
> + *
> + * Description:
> + * Check whether SCTP socket options are allowed or not. Returns zero on
> + * success, negative values on failure.
> + *
> + *    SCTP_SOCKOPT_PEELOFF - Branch off an association into a new socket that
> + *                           will be a one-to-one style socket. As SELinux
> + *                           already handles the creation of new sockets, only
> + *                           the peeloff permission is checked.
> + */
> +int selinux_sctp_getsockopt(struct sock *sk, int level, int optname)
> +{
> +	int err;
> +
> +	if (level != SOL_SCTP || level != IPPROTO_SCTP)
> +		return 0;
> +
> +	switch (optname) {
> +	case SCTP_SOCKOPT_PEELOFF:
> +		err = sock_has_perm(current, sk, SCTP_SOCKET__PEELOFF);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +
> +	return 0;
> +}

