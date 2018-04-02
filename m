From: Vladislav Yasevich <vyasevich@gmail.com>
Date: Mon, 02 Apr 2018 13:40:01 +0000
Subject: [PATCH net-next 0/5] virtio-net:  Add SCTP checksum offload support
Message-Id: <20180402134006.10111-1-vyasevic@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: nhorman@tuxdriver.com, mst@redhat.com, virtualization@lists.linux-foundation.org, linux-sctp@vger.kernel.org

Now that we have SCTP offload capabilities in the kernel, we can add
them to virtio as well.  First step is SCTP checksum.

We need a new freature in virtio to negotiate this support since
SCTP is excluded with the stardard checksum and requires a little
bit extra.  This series proposes VIRTIO_NET_F_SCTP_CSUM feature bit.

As the "little bit extra",  the kernel uses a new bit in the skb
(skb->csum_not_inet) to determine whether to use standard inet checksum
or the SCTP CRC32c checksum.  This bit has to be communicated between
the host and the guest.  This bit is carried in the vnet header.

Tap and macvtap support is added through an extra feature for the
TUNSETOFFLOAD ioctl.  Additionally macvtap will no correctly
do sctp checksumming if the receive doesn't support SCTP offload.
This also turns on sctp offloading for macvlan devices.

As for the perf numbers, I am seeing about a 5% increase in vm-to-vm
and vm-to-hos throughput which is the same as manually disabling
sctp checksumming,since this is exactly what we are emulatting.
Sending outside the host,  the increase about 2.5-3%.

As for GSO, the way sctp GSO is currently implemented buys us nothing
in added support to virtio.  To add true GSO, would require a lot of
re-work inside of SCTP and would require extensions to the virtio
net header to carry extra sctp data.


Vladislav Yasevich (5):
  virtio: Add support for SCTP checksum offloading
  sctp: Handle sctp packets with CHECKSUM_PARTIAL
  sctp: Build sctp offload support into the base kernel
  tun: Add support for SCTP checksum offload
  macvlan/macvtap: Add support for SCTP checksum offload.

 drivers/net/macvlan.c           |  5 +++--
 drivers/net/tap.c               |  8 +++++---
 drivers/net/tun.c               |  5 +++++
 drivers/net/virtio_net.c        | 10 +++++++---
 include/linux/virtio_net.h      |  6 ++++++
 include/net/sctp/sctp.h         |  5 -----
 include/uapi/linux/if_tun.h     |  1 +
 include/uapi/linux/virtio_net.h |  2 ++
 net/Kconfig                     |  1 +
 net/sctp/Kconfig                |  1 -
 net/sctp/Makefile               |  3 ++-
 net/sctp/input.c                | 11 ++++++++++-
 net/sctp/offload.c              |  4 +++-
 net/sctp/protocol.c             |  3 ---
 14 files changed, 45 insertions(+), 20 deletions(-)

-- 
2.9.5

