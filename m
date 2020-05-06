From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 06 May 2020 06:47:25 +0000
Subject: Re: [PATCH 1/2] sctp: implement memory accounting on tx path
Message-Id: <20200506064725.GC2273049@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1588242081.git.ashwinh@vmware.com>
 <4ce6c13946803700d235082b9c52460ed38dab1e.1588242081.git.ashwinh@vmware.com>
In-Reply-To: <4ce6c13946803700d235082b9c52460ed38dab1e.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ashwin-h <ashwinh@vmware.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, srivatsab@vmware.com, srivatsa@csail.mit.edu, rostedt@goodmis.org, srostedt@vmware.com, ashwin.hiranniah@gmail.com, Xin Long <lucien.xin@gmail.com>

On Wed, May 06, 2020 at 07:50:53PM +0530, ashwin-h wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> commit 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa upstream.
> 
> Now when sending packets, sk_mem_charge() and sk_mem_uncharge() have been
> used to set sk_forward_alloc. We just need to call sk_wmem_schedule() to
> check if the allocated should be raised, and call sk_mem_reclaim() to
> check if the allocated should be reduced when it's under memory pressure.
> 
> If sk_wmem_schedule() returns false, which means no memory is allowed to
> allocate, it will block and wait for memory to become available.
> 
> Note different from tcp, sctp wait_for_buf happens before allocating any
> skb, so memory accounting check is done with the whole msg_len before it
> too.
> 
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ashwin H <ashwinh@vmware.com>
> ---
>  net/sctp/socket.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
