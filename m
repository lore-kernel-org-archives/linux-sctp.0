From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 02 Dec 2014 14:15:05 +0000
Subject: [RFC-PATCH 0/3] SELinux: Support the SCTP protocol
Message-Id: <1417529705-2561-1-git-send-email-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux@tycho.nsa.gov, linux-sctp@vger.kernel.org

This is an RFC patch.
Tested on Fedora 20 using kernel kernel-3.17.3-200.fc20.x86_64

This is an updated patch that I hope will address the associations/multi-
homing comments from the last patch [1]. I've investigated these areas and I
think the additions of bindx and connectx to handle the situations by
permission checks is ok (but happy to be shot down). This is because if the
addresses do not pass the standard permission checks for bind/connect, the
association cannot take place. I've copied the SCTP list to get their
comments.

The only areas I'm not really sure about are:

1) There are many get/setsockopt options - I've picked the ones I think
   are important, there are probably others that need checking.

2) Because I've just extended the set/getsockopt security entries, I've
   had to copy code from net/sctp/sockets.c into SELinux sctp.c code to
   handle the case of CONNECTX3. The only alternative to this would be
   to create a new security entry (e.g. security_sk_setsockopt) and plug
   this into net/sctp/socket.c. I've tested this and it works ok but
   decided to try this patch first.

3) Obtaining the peer context using getpeercon(3) was an issue.
   I've worked around this by setting the peer context in:
     hooks.c - selinux_socket_sock_rcv_skb for network_peer_controls = 1
     netlabel.c - selinux_netlbl_sock_rcv_skb for network_peer_controls = 0

   I'm not sure it's the right thing to do but does work and I've not had any
   problems when using different peer labels such as:
netlabelctl unlbl add interface:lo address:0.0.0.0/0 label:unconfined_u:object_r:netlabel_peer_lo_t:s0
netlabelctl unlbl add interface:wlan0 address:0.0.0.0/0 label:unconfined_u:object_r:netlabel_peer_wlan_t:s0

   For Information: It should be possible to obtain the peer context using
   the 'cmsghdr' struct by setting in an app:
int one = 1;
setsockopt(fd, SOL_IP, IP_PASSSEC, &one, sizeof(one));

   However there are currently two obstacles to this:
      a) The code in net/sctp/socket.c - sctp_recvmsg() to process this
         is commented out with a FIXME. I did patch this with:
		if (inet_sk(sk)->cmsg_flags)
			ip_cmsg_recv(msg, skb);

         I could then see the peer context via hooks.c 
         selinux_socket_getpeersec_dgram().
     b) The current implementation of the SCTP library will not process
        this anyway, it will require the new rfc6458 sctp_recvv() function
        that has not been implemented yet.


Notes:
1) The following permissions have been tested:
   { read write create getattr bind connect listen accept getopt setopt
     name_bind node_bind name_connect bindx_add bindx_rem connectx
     peeloff set_addr set_params }

   There are patches for libsepol-2.4-rc5 enabling new "sctp" and "dccp"
   keywords for portcon statements (see [2]), for example:
portcon sctp 19000 system_u:object_r:sctp_port_t:s0

2) Checks using 'TCP_LISTEN' were equivalent to the SCTP socket states,
   for example:

       SCTP_SS_LISTENING = TCP_LISTEN

   I added various debug statements to see if there were any problems
   as raised in [1] but could not see any issues - but again !!!

3) The main test program used was a modified version of the lksctp-tools
   sctp_test.c program that printed the process, peer and socket contexts
   see [2].

[1] http://marc.info/?l=selinux&m1537832610364&w=2
[2] http://marc.info/?l=selinux&m1536871703018&w=2

Richard Haines (3):
  security: Extend security get/setsockopt entries
  net: Extend security get/setsockopt entries
  selinux: Add support for the SCTP protocol

 include/linux/security.h                |  24 ++-
 net/compat.c                            |   6 +-
 net/socket.c                            |   6 +-
 security/capability.c                   |   6 +-
 security/security.c                     |  12 +-
 security/selinux/Makefile               |   2 +
 security/selinux/hooks.c                | 334 +++++++++++++++++++++-----------
 security/selinux/include/classmap.h     |   4 +
 security/selinux/include/sctp.h         |  66 +++++++
 security/selinux/include/sctp_private.h |  46 +++++
 security/selinux/netlabel.c             |  12 +-
 security/selinux/sctp.c                 | 318 ++++++++++++++++++++++++++++++
 12 files changed, 701 insertions(+), 135 deletions(-)
 create mode 100644 security/selinux/include/sctp.h
 create mode 100644 security/selinux/include/sctp_private.h
 create mode 100644 security/selinux/sctp.c

-- 
1.9.3

