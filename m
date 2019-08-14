From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 14 Aug 2019 00:10:37 +0000
Subject: Re: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Message-Id: <20190814001037.GB11098@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhengbin <zhengbin13@huawei.com>
Cc: vyasevich@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, yi.zhang@huawei.com

On Tue, Aug 13, 2019 at 10:05:50PM +0800, zhengbin wrote:
> If the stream outq is not empty, need to kfree nstr_list.
> 
> Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  net/sctp/stream.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 2594660..e83cdaa 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -316,6 +316,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
>  		nstr_list[i] = htons(str_list[i]);
> 
>  	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> +		kfree(nstr_list);
>  		retval = -EAGAIN;
>  		goto out;
>  	}
> --
> 2.7.4
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
