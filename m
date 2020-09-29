From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 13:48:52 +0000
Subject: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Message-Id: <cover.1601387231.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

Description From the RFC:

   The Main Reasons:

   o  To allow SCTP traffic to pass through legacy NATs, which do not
      provide native SCTP support as specified in [BEHAVE] and
      [NATSUPP].

   o  To allow SCTP to be implemented on hosts that do not provide
      direct access to the IP layer.  In particular, applications can
      use their own SCTP implementation if the operating system does not
      provide one.

   Implementation Notes:

   UDP-encapsulated SCTP is normally communicated between SCTP stacks
   using the IANA-assigned UDP port number 9899 (sctp-tunneling) on both
   ends.  There are circumstances where other ports may be used on
   either end, and it might be required to use ports other than the
   registered port.

   Each SCTP stack uses a single local UDP encapsulation port number as
   the destination port for all its incoming SCTP packets, this greatly
   simplifies implementation design.

   An SCTP implementation supporting UDP encapsulation MUST maintain a
   remote UDP encapsulation port number per destination address for each
   SCTP association.  Again, because the remote stack may be using ports
   other than the well-known port, each port may be different from each
   stack.  However, because of remapping of ports by NATs, the remote
   ports associated with different remote IP addresses may not be
   identical, even if they are associated with the same stack.

   Because the well-known port might not be used, implementations need
   to allow other port numbers to be specified as a local or remote UDP
   encapsulation port number through APIs.

Patches:

   This patchset is using the udp4/6 tunnel APIs to implement the UDP
   Encapsulation of SCTP with not much change in SCTP protocol stack
   and with all current SCTP features keeped in Linux Kernel.

   1 - 4: Fix some UDP issues that may be triggered by SCTP over UDP.
   5 - 7: Process incoming UDP encapsulated packets and ICMP packets.
   8 -10: Remote encap port's update by sysctl, sockopt and packets.
   11-14: Process outgoing pakects with UDP encapsulated and its GSO.
      15: Enable this feature.

Tests:

  - lksctp-tools/src/func_tests with UDP Encapsulation enabled/disabled:

      Both make v4test and v6test passed.

  - sctp-tests with UDP Encapsulation enabled/disabled:

      repeatability/procdumps/sctpdiag/gsomtuchange/extoverflow/
      sctphashtable passed. Others failed as expected due to those
      "iptables -p sctp" rules.

  - netperf on lo/netns/virtio_net, with gso enabled/disabled and
    with ip_checksum enabled/disabled, with UDP Encapsulation
    enabled/disabled:

      No clear performance dropped.

Xin Long (15):
  udp: check udp sock encap_type in __udp_lib_err
  udp6: move the mss check after udp gso tunnel processing
  udp: do checksum properly in skb_udp_tunnel_segment
  udp: support sctp over udp in skb_udp_tunnel_segment
  sctp: create udp4 sock and add its encap_rcv
  sctp: create udp6 sock and set its encap_rcv
  sctp: add encap_err_lookup for udp encap socks
  sctp: add encap_port for netns sock asoc and transport
  sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
  sctp: allow changing transport encap_port by peer packets
  sctp: add udphdr to overhead when udp_port is set
  sctp: call sk_setup_caps in sctp_packet_transmit instead
  sctp: support for sending packet over udp4 sock
  sctp: support for sending packet over udp6 sock
  sctp: enable udp tunneling socks

 include/net/netns/sctp.h     |   8 +++
 include/net/sctp/constants.h |   2 +
 include/net/sctp/sctp.h      |   9 ++-
 include/net/sctp/sm.h        |   1 +
 include/net/sctp/structs.h   |  13 ++--
 include/uapi/linux/sctp.h    |   7 ++
 net/ipv4/udp.c               |   2 +-
 net/ipv4/udp_offload.c       |  16 +++--
 net/ipv6/udp.c               |   2 +-
 net/ipv6/udp_offload.c       | 154 +++++++++++++++++++++----------------------
 net/sctp/associola.c         |   4 ++
 net/sctp/ipv6.c              |  48 ++++++++++----
 net/sctp/output.c            |  22 +++----
 net/sctp/protocol.c          | 145 ++++++++++++++++++++++++++++++++++++----
 net/sctp/sm_make_chunk.c     |   1 +
 net/sctp/sm_statefuns.c      |   2 +
 net/sctp/socket.c            | 111 +++++++++++++++++++++++++++++++
 net/sctp/sysctl.c            |  53 +++++++++++++++
 18 files changed, 471 insertions(+), 129 deletions(-)

-- 
2.1.0
