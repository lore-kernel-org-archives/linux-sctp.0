From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 19 Aug 2009 14:48:27 +0000
Subject: Re: [PATCH 2/2] sctp: fix heartbeat count of path failure
Message-Id: <4A8C10BB.2040804@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1250665268-29770-1-git-send-email-chunbo.luo@windriver.com> <1250665268-29770-2-git-send-email-chunbo.luo@windriver.com>
In-Reply-To: <1250665268-29770-2-git-send-email-chunbo.luo@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chunbo Luo <chunbo.luo@windriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Chunbo Luo wrote:
> RFC4960 Section 8.2 defined that the transport should enter INACTIVE
> state only when the value in the error counter exceeds the protocol 
> parameter 'Path.Max.Retrans' of that destination address. This means 
> that the transport should enter INACTIVE state after pathmaxrxt+1
> heartbeats are not acknowledged.
> 
> 
> Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>

NAK.  This patch seems to resurface periodically and I have to keep
explaining that it's wrong.

Every time we send a HB, we tick up the error count and clear it when
the HB-ACK is received.  Each HB is separate and not a retransmission,
so we once we reach the pathmaxrxt, we've already sent max+1 HB, so we
have time out.  Walk through the code with some values and you'll see
what I mean.

-vlad

> ---
>  net/sctp/sm_sideeffect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 86426aa..0e2e269 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -447,7 +447,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
>  		asoc->overall_error_count++;
>  
>  	if (transport->state != SCTP_INACTIVE &&
> -	    (transport->error_count++ >= transport->pathmaxrxt)) {
> +	    (transport->error_count++ > transport->pathmaxrxt)) {
>  		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
>  					 " transport IP: port:%d failed.\n",
>  					 asoc,

