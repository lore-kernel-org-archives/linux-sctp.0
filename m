From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:06:43 +0000
Subject: [PATCH 0/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289524003.5167.64.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Urs Thuermann <urs.thuermann@volkswagen.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Pekka Savola

This patch series resolves the leakage of kernel heap addresses to
userspace via network protocol /proc interfaces.  Revealing this
information is a bad idea from a security perspective for a number of
reasons, the most obvious of which is it provides unprivileged users a
mechanism by which to create a structure in the kernel heap containing
function pointers, obtain the address of that structure, and overwrite
those function pointers by leveraging other vulnerabilities.  It is my
hope that by eliminating this information leakage, in conjunction with
making statically-declared function pointer tables read-only (to be done
in a separate patch series), we can at least add a small hurdle for the
exploitation of a subset of kernel vulnerabilities.

To maintain compatibility with userspace programs relying on
consistent /proc output, the output descriptions and number of fields
are not changed. When a unique identifier for the socket is desired, the
socket address has been replaced with the socket inode number. When the
inode number is already present in the output, the address has been
replaced with a 0. In these cases, the format specifier has been changed
to %d, because a %p output of 0 from kernel space is written as
"(null)", while userspace %p can only parse "(nil)".

To address feedback that this debugging information is often useful and
should not be removed, the original kernel addresses are printed when
the reader has CAP_NET_ADMIN.  The result is not especially pretty, but
I chose the more verbose option of providing separate print statements
for each case rather than inserting conditionals into the print
statements themselves, which would make for poor readability.


Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 net/atm/proc.c           |    2 +-
 net/can/bcm.c            |   17 +++--
 net/ipv4/raw.c           |   27 +++++--
 net/ipv4/tcp_ipv4.c      |  136 +++++++++++++++++++++++++-----------
 net/ipv4/udp.c           |   28 +++++--
 net/ipv6/tcp_ipv6.c      |  173 +++++++++++++++++++++++++++++++--------------
 net/key/af_key.c         |   27 +++++--
 net/netlink/af_netlink.c |   41 ++++++++---
 net/packet/af_packet.c   |   36 +++++++---
 net/phonet/socket.c      |   27 +++++--
 net/sctp/proc.c          |   56 +++++++++++----
 net/unix/af_unix.c       |   37 +++++++---
 12 files changed, 427 insertions(+), 180 deletions(-)




