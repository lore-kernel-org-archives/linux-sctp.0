From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 06 May 2020 06:47:17 +0000
Subject: Re: [PATCH 2/2] sctp: implement memory accounting on rx path
Message-Id: <20200506064717.GB2273049@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1588242081.git.ashwinh@vmware.com>
 <b2d9886afc672b4120f101eeb9217e68abb61471.1588242081.git.ashwinh@vmware.com>
In-Reply-To: <b2d9886afc672b4120f101eeb9217e68abb61471.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ashwin-h <ashwinh@vmware.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, srivatsab@vmware.com, srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com, ashwin.hiranniah@gmail.com, Xin Long <lucien.xin@gmail.com>

On Wed, May 06, 2020 at 07:50:54PM +0530, ashwin-h wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 9dde27de3e5efa0d032f3c891a0ca833a0d31911 upstream.
> 
> sk_forward_alloc's updating is also done on rx path, but to be consistent
> we change to use sk_mem_charge() in sctp_skb_set_owner_r().
> 
> In sctp_eat_data(), it's not enough to check sctp_memory_pressure only,
> which doesn't work for mem_cgroup_sockets_enabled, so we change to use
> sk_under_memory_pressure().
> 
> When it's under memory pressure, sk_mem_reclaim() and sk_rmem_schedule()
> should be called on both RENEGE or CHUNK DELIVERY path exit the memory
> pressure status as soon as possible.
> 
> Note that sk_rmem_schedule() is using datalen to make things easy there.
> 
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ashwin H <ashwinh@vmware.com>
> ---
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/sm_statefuns.c |  6 ++++--
>  net/sctp/ulpevent.c     | 19 ++++++++-----------
>  net/sctp/ulpqueue.c     |  3 ++-
>  4 files changed, 15 insertions(+), 15 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
