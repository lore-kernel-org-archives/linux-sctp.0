From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 31 Mar 2019 08:53:45 +0000
Subject: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <cover.1554022192.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

sctp memory accounting is added in this patchset by using
these kernel APIs on send side:

  - sk_mem_charge()
  - sk_mem_uncharge()
  - sk_wmem_schedule()
  - sk_under_memory_pressure()
  - sk_mem_reclaim()

and these on receive side:

  - sk_mem_charge()
  - sk_mem_uncharge()
  - sk_rmem_schedule()
  - sk_under_memory_pressure()
  - sk_mem_reclaim()

With sctp memory accounting, we can limit the memory allocation by
either sysctl:

  # sysctl -w net.sctp.sctp_mem="10 20 50"

or cgroup:

  # echo $((8<<14)) > \
    /sys/fs/cgroup/memory/sctp_mem/memory.kmem.tcp.limit_in_bytes

When the socket is under memory pressure, the send side will block
and wait, while the receive side will renege or drop.

Xin Long (2):
  sctp: implement memory accounting on tx path
  sctp: implement memory accounting on rx path

 include/net/sctp/sctp.h |  2 +-
 net/sctp/sm_statefuns.c |  6 ++++--
 net/sctp/socket.c       | 10 ++++++++--
 net/sctp/ulpevent.c     | 19 ++++++++-----------
 net/sctp/ulpqueue.c     |  3 ++-
 5 files changed, 23 insertions(+), 17 deletions(-)

-- 
2.1.0
