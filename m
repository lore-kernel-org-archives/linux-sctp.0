From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 22 Jul 2020 20:42:31 +0000
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Message-Id: <20200722204231.GA3398@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
In-Reply-To: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Christoph Hellwig <hch@lst.de>, linux-sctp@vger.kernel.org

Cc'ing linux-sctp@vger.kernel.org.

On Wed, Jul 22, 2020 at 05:38:58PM -0300, Marcelo Ricardo Leitner wrote:
> This sockopt accepts two kinds of parameters, using struct
> sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
> notice an implicit cast from the smaller (latter) struct to the bigger
> one (former) when copying the data from the user space, which now leads
> to an attempt to write beyond the buffer (because it assumes the storing
> buffer is bigger than the parameter itself).
> 
> Fix it by giving it a special buffer if the smaller struct is used by
> the application.
> 
> Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
> Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/socket.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9a767f35971865f46b39131fc8d96d8c3c2aa1a8..b71c36af7687247b4fc9e160219b76f5c41b2fe2 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2756,6 +2756,7 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
>  {
>  	struct sctp_sock *sp = sctp_sk(sk);
>  	struct sctp_association *asoc;
> +	struct sctp_sack_info _params;
>  
>  	if (optlen = sizeof(struct sctp_sack_info)) {
>  		if (params->sack_delay = 0 && params->sack_freq = 0)
> @@ -2767,7 +2768,9 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
>  				    "Use struct sctp_sack_info instead\n",
>  				    current->comm, task_pid_nr(current));
>  
> -		if (params->sack_delay = 0)
> +		memcpy(&_params, params, sizeof(struct sctp_assoc_value));
> +		params = &_params;
> +		if (((struct sctp_assoc_value *)params)->assoc_value = 0)
>  			params->sack_freq = 1;
>  		else
>  			params->sack_freq = 0;
> -- 
> 2.25.4
> 
