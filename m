From: David Miller <davem@davemloft.net>
Date: Mon, 15 Apr 2019 20:37:10 +0000
Subject: Re: [PATCHv2 net-next 0/2] sctp: fully support memory accounting
Message-Id: <20190415.133710.1332786540052304142.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1555319573.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1555319573.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, mcroce@redhat.com, vdronov@redhat.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Apr 2019 17:15:05 +0800

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
> v1->v2:
>   - add the missing Reported/Tested/Acked/-bys.

Series applied, thanks Xin.
