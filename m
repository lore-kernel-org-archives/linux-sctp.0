From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 30 Oct 2013 00:54:11 +0000
Subject: Re: [lksctp-developers] [PATCH] sctp_status: server side should also receive msg_cnt times
Message-Id: <20131030005411.GC14331@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382842583-890-1-git-send-email-liuhangbin@gmail.com>
In-Reply-To: <1382842583-890-1-git-send-email-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sun, Oct 27, 2013 at 10:56:23AM +0800, Hangbin Liu wrote:
> As client side send msg_cnt times for each repeat. Server will exit too early
> if we only receive one time for each repeat and leave client keep sent, which
> makes client could not exit normally
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  src/apps/sctp_status.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/src/apps/sctp_status.c b/src/apps/sctp_status.c
> index 4e21af8..76f96e4 100644
> --- a/src/apps/sctp_status.c
> +++ b/src/apps/sctp_status.c
> @@ -547,6 +547,8 @@ int receive_r(int sk)
>  } /* receive_r () */
>  
>  void server(int sk) {
> +	int i;
> +
>  	if (max_msgsize > DEFAULT_MAX_WINDOW) {
>  		if (setsockopt(sk, IPPROTO_SCTP, SO_RCVBUF, &max_msgsize,
>  			       sizeof(max_msgsize)) < 0) {
> @@ -555,7 +557,10 @@ void server(int sk) {
>  		}
>  	}
>  
> -	receive_r(sk);
> +	for (i = 0; i < msg_cnt; i++) {
> +		receive_r(sk);
> +		DEBUG_PRINT(DEBUG_MIN, "count %d\n", i+1);
> +	}
>  } /* server() */
>  
>  void * build_msg(int len) {
> -- 
> 1.8.1.4
> 

How about this patch?

-- 

Thanks & Best Regards
Hangbin Liu <liuhangbin@gmail.com>
