From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 10 Sep 2019 07:15:21 +0000
Subject: Re: [PATCH net] sctp: fix the missing put_user when dumping transport thresholds
Message-Id: <20190910071521.GA31884@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
In-Reply-To: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Sep 09, 2019 at 03:33:29PM +0800, Xin Long wrote:
> This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
> a transport thresholds info.
> 
> Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.
> 
> Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9d1f83b..ad87518 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -7173,7 +7173,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
>  		val.spt_pathmaxrxt = trans->pathmaxrxt;
>  		val.spt_pathpfthld = trans->pf_retrans;
>  
> -		return 0;
> +		goto out;
>  	}
>  
>  	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
> @@ -7191,6 +7191,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
>  		val.spt_pathmaxrxt = sp->pathmaxrxt;
>  	}
>  
> +out:
>  	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
>  		return -EFAULT;
>  
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
