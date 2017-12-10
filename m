From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 10 Dec 2017 13:51:49 +0000
Subject: Re: [PATCH net] sctp: make sure stream nums can match optlen in sctp_setsockopt_reset_streams
Message-Id: <20171210135149.GB4514@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <a6c86b9cb13c2b6e2ed2539c028557a6b1a713ef.1512891651.git.lucien.xin@gmail.com>
In-Reply-To: <a6c86b9cb13c2b6e2ed2539c028557a6b1a713ef.1512891651.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com

On Sun, Dec 10, 2017 at 03:40:51PM +0800, Xin Long wrote:
> Now in sctp_setsockopt_reset_streams, it only does the check
> optlen < sizeof(*params) for optlen. But it's not enough, as
> params->srs_number_streams should also match optlen.
> 
> If the streams in params->srs_stream_list are less than stream
> nums in params->srs_number_streams, later when dereferencing
> the stream list, it could cause a slab-out-of-bounds crash, as
> reported by syzbot.
> 
> This patch is to fix it by also checking the stream numbers in
> sctp_setsockopt_reset_streams to make sure at least it's not
> greater than the streams in the list.
> 
> Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 014847e..dbf140d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3891,13 +3891,17 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
>  	struct sctp_association *asoc;
>  	int retval = -EINVAL;
>  
> -	if (optlen < sizeof(struct sctp_reset_streams))
> +	if (optlen < sizeof(*params))
>  		return -EINVAL;
>  
>  	params = memdup_user(optval, optlen);
>  	if (IS_ERR(params))
>  		return PTR_ERR(params);
>  
> +	if (params->srs_number_streams * sizeof(__u16) >
> +	    optlen - sizeof(*params))
> +		goto out;
> +
>  	asoc = sctp_id2assoc(sk, params->srs_assoc_id);
>  	if (!asoc)
>  		goto out;
> -- 
> 2.1.0
> 
