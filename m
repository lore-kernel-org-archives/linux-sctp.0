From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 01 Apr 2019 11:31:10 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fully support memory accounting
Message-Id: <20190401113110.GA20717@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1554022192.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1554022192.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

On Sun, Mar 31, 2019 at 04:53:45PM +0800, Xin Long wrote:
> sctp memory accounting is added in this patchset by using
> these kernel APIs on send side:
> 
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_wmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
> 
> and these on receive side:
> 
>   - sk_mem_charge()
>   - sk_mem_uncharge()
>   - sk_rmem_schedule()
>   - sk_under_memory_pressure()
>   - sk_mem_reclaim()
> 
> With sctp memory accounting, we can limit the memory allocation by
> either sysctl:
> 
>   # sysctl -w net.sctp.sctp_mem="10 20 50"
> 
> or cgroup:
> 
>   # echo $((8<<14)) > \
>     /sys/fs/cgroup/memory/sctp_mem/memory.kmem.tcp.limit_in_bytes
> 
> When the socket is under memory pressure, the send side will block
> and wait, while the receive side will renege or drop.
> 
> Xin Long (2):
>   sctp: implement memory accounting on tx path
>   sctp: implement memory accounting on rx path
> 
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/socket.c       | 10 ++++++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  5 files changed, 23 insertions(+), 17 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
I don't have a problem with either of these patches in terms of altering memory
accounting, but SCTP has the notion of accounting buffers based on either
sockets space or association space (based on the sndbuf_policy and rcvbuf_policy
sysctls).  This patch eliminates them.  I don't see this patch addressing either
the removal of that functionality (as the proposed accounting scheme renders
those sysctls useless and ignored, which may cause regressions in some
environments), nor does it address the possibiliy of one association starving
others on the same socket when they share the same socket level accounting.  I
think you need to look how to address that (either by re-adding the ability to
account in either case based on the sysctls, or deprecating eliminating the
sysctls and addressing the starvation issue.

Best
Neil
