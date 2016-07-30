From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 30 Jul 2016 13:25:35 +0000
Subject: Re: [PATCH net] sctp: change to use TCP_CLOSE_WAIT as SCTP_SS_CLOSING
Message-Id: <20160730132535.GE2967@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <0517133e5f1dee8136f3a1c3bfaac522fe98e599.1469880045.git.lucien.xin@gmail.com>
In-Reply-To: <0517133e5f1dee8136f3a1c3bfaac522fe98e599.1469880045.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

On Sat, Jul 30, 2016 at 08:00:45PM +0800, Xin Long wrote:
> Prior to this patch, sctp defined TCP_CLOSING as SCTP_SS_CLOSING.
> TCP_CLOSING is such a special sk state in TCP that inet common codes
> even exclude it.
> 
> For instance, inet_accept thinks the accept sk's state never be
> TCP_CLOSING, or it will give a WARN_ON. TCP works well with that
> while SCTP may trigger the call trace, as CLOSING state in SCTP
> has different meaning from TCP.
> 
> This fix is to change to use TCP_CLOSE_WAIT as SCTP_SS_CLOSING,
> instead of TCP_CLOSING. Some side-effects could be expected,
> regardless of not being used before. inet_accept will accept it
> now.
> 
> I did all the func_tests in lksctp-tools and ran sctp codnomicon
> fuzzer tests against this patch, no regression or failure found.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

I don't think this is -net material. It's a one line change but a core
one.
Dave please consider it for net-next instead.
Though, Xin you may need to re-post later..

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/constants.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
> index 8c337cd..5b847e4 100644
> --- a/include/net/sctp/constants.h
> +++ b/include/net/sctp/constants.h
> @@ -214,7 +214,7 @@ typedef enum {
>  	SCTP_SS_LISTENING      = TCP_LISTEN,
>  	SCTP_SS_ESTABLISHING   = TCP_SYN_SENT,
>  	SCTP_SS_ESTABLISHED    = TCP_ESTABLISHED,
> -	SCTP_SS_CLOSING        = TCP_CLOSING,
> +	SCTP_SS_CLOSING        = TCP_CLOSE_WAIT,
>  } sctp_sock_state_t;
>  
>  /* These functions map various type to printable names.  */
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
