From: Stanislav Kozina <skozina@redhat.com>
Date: Wed, 14 Dec 2011 11:41:25 +0000
Subject: SCTP multihoming sends incorrect ARP request
Message-Id: <50cc07d6-006c-40ad-a846-f082e5365c08@zmail01.collab.prod.int.phx2.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Greetings,

I'd like to discuss obscure behavior of SCTP in multihoming environment.
SCTP connect() leads to incorrect ARP who-has request and reply.

Suppose we have two hosts (hostA, hostB), each with two NICs (nicA, nicB),
each NIC with two addresses (addrA, addrB). So in our scenario we have 8
addresses in total. All NICs are connected to the same physical network
switch.
Both addresses on both nicA are in one subnet, both addresses on both nicB are
in one different subnet.

So my settings looks like:

 ==hostA========      ==hostB========
 |192.168.100.4/24   nicA-\  /-nicB 192.168.100.5/24  |
 |192.168.100.14/24     |  ||  |    192.168.100.15/24 |
 |----------------------|  ||  |----------------------|
 |192.168.200.4/24   nicB-/  \-nicB 192.168.200.5/24  |
 |192.168.200.14/24     |      |    192.168.200.15/24 |
 ============      ============

(in real setup both subnets would be routed through different physical networks etc.)

Now suppose we are running SCTP server on hostB, which does:

  socket(AF_INET, SOCK_STREAM,IPPROTO_SCTP);
  bind(192.168.100.5)
  sctp_bindx(192.168.200.5)
  listen()
  accept()

And SCTP client running on hostA doing:

  socket(AF_INET, SOCK_STREAM,IPPROTO_SCTP);
  bind(192.168.100.4);
  sctp_bindx(192.168.200.4);
  connect(192.168.200.5);

So in short - the client does connect to the secondary interface of the server.

The problem here is ARP resolution before actual SCTP handshake. Here the
client sends incorrect ARP request, see **) below for tcpdump output.
In the showed packets, the ARP Who-has request contains incorrect combination
of Sender's MAC and IP address. It has Sender's MAC address of nicB, but
Sender's IP address of nicA.
The server then replies with the same wrong packet - Sender's MAC address of
his nicA, but IP address from nicB.
This leads to wrong ARP tables on both hosts - they both only only one MAC
address of their respective partner.
Wrong ARP tables leads for incorrect source IP in future SCTP packets.

Possible workaround is to ping all partners before starting SCTP connection to
fill ARP tables correctly.

I was testing this on yesterday's build of the kernel:

$ git log | head
commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Dec 9 15:09:32 2011 -0800

    Linux 3.2-rc5

hostA$ uname -a
Linux hostA-2 3.2.0-rc5 #1 SMP Mon Dec 12 17:31:15 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

The question is - do you agree that this is a bug, and the ARP who-has request
should be sent with matching pair of MAC and IP address?
In that case - I would be happy to propose a patch with fix (which might take
me some time...).

Thanks for reply and regards,
-Stanislav Kozina

*) IP configuration of both hosts
hostA# ip addr show
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:92:35:7a brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.14/16 brd 192.168.200.255 scope global eth0
    inet 192.168.100.4/24 brd 192.168.100.255 scope global eth0:1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:92:35:7b brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.14/24 brd 192.168.200.255 scope global eth1
    inet 192.168.200.4/24 brd 192.168.200.255 scope global secondary eth1:1

hostB# ip addr show
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:16:36:d3:6a:5e brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.15/16 brd 192.168.200.255 scope global eth0
    inet 192.168.100.5/24 brd 192.168.100.255 scope global eth0:1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:16:36:d3:6a:5f brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.15/24 brd 192.168.200.255 scope global eth1
    inet 192.168.200.5/24 brd 192.168.200.255 scope global secondary eth1:1

**) Tcpdump of respective ARP packets
No.     Time        Source                Destination           Protocol Info
      7 7.185516    RealtekU_92:35:7b     Broadcast             ARP      Who has 192.168.200.5?  Tell 192.168.100.4

Frame 7 (42 bytes on wire, 42 bytes captured)
Ethernet II, Src: RealtekU_92:35:7b (52:54:00:92:35:7b), Dst: Broadcast (ff:ff:ff:ff:ff:ff)
Address Resolution Protocol (request)
<!SNIP>
    Sender MAC address: RealtekU_92:35:7b (52:54:00:92:35:7b)
    Sender IP address: 192.168.100.4 (192.168.100.4)  /** Here the Senders MAC and IP do not match */
    Target MAC address: 00:00:00_00:00:00 (00:00:00:00:00:00)
    Target IP address: 192.168.200.5 (192.168.200.5)

No.     Time        Source                Destination           Protocol Info
      8 7.185832    QuantaCo_d3:6a:5e     RealtekU_92:35:7b     ARP      192.168.200.5 is at 00:16:36:d3:6a:5e

Frame 8 (42 bytes on wire, 42 bytes captured)
Ethernet II, Src: QuantaCo_d3:6a:5e (00:16:36:d3:6a:5e), Dst: RealtekU_92:35:7b (52:54:00:92:35:7b)
Address Resolution Protocol (reply)
<!SNIP>
    Sender MAC address: QuantaCo_d3:6a:5e (00:16:36:d3:6a:5e)
    Sender IP address: 192.168.200.5 (192.168.200.5)  /** Here also Senders MAC and IP do not match */
    Target MAC address: RealtekU_92:35:7b (52:54:00:92:35:7b)
    Target IP address: 192.168.100.4 (192.168.100.4)
