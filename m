From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 17 Jun 2008 12:10:23 +0000
Subject: Re: [PATCH] Kill unused macros...
Message-Id: <4857A9AF.3040707@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080617.004324.162289618.davem@davemloft.net>
In-Reply-To: <20080617.004324.162289618.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

David Miller wrote:
> I noticed this while working on something unrelated in the
> net-next-2.6 tree, applied and pushed to kernel.org
> 
> sctp: Kill SCTP_SOCK_SLEEP_{PRE,POST}, unused.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

OK, thanks.  It looks like there were supposed to be part
of some debug output that didn't get fully removed first
time around.

-vlad

> ---
>  include/net/sctp/sctp.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 5672d48..17b932b 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -220,8 +220,6 @@ extern struct kmem_cache *sctp_bucket_cachep __read_mostly;
>  #define sctp_release_sock(sk)    release_sock(sk)
>  #define sctp_bh_lock_sock(sk)    bh_lock_sock(sk)
>  #define sctp_bh_unlock_sock(sk)  bh_unlock_sock(sk)
> -#define SCTP_SOCK_SLEEP_PRE(sk)  SOCK_SLEEP_PRE(sk)
> -#define SCTP_SOCK_SLEEP_POST(sk) SOCK_SLEEP_POST(sk)
>  
>  /* SCTP SNMP MIB stats handlers */
>  DECLARE_SNMP_STAT(struct sctp_mib, sctp_statistics);
> 

