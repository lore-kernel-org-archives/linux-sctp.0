From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 25 Jun 2019 11:18:09 +0000
Subject: Re: [PATCH net] sctp: change to hold sk after auth shkey is created successfully
Message-Id: <20190625111809.GB29902@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
In-Reply-To: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller-bugs@googlegroups.com

On Tue, Jun 25, 2019 at 12:21:45AM +0800, Xin Long wrote:
> Now in sctp_endpoint_init(), it holds the sk then creates auth
> shkey. But when the creation fails, it doesn't release the sk,
> which causes a sk defcnf leak,
> 
> Here to fix it by only holding the sk when auth shkey is created
> successfully.
> 
> Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
> Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
> Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/endpointola.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index e358437..69cebb2 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -118,10 +118,6 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
>  	/* Initialize the bind addr area */
>  	sctp_bind_addr_init(&ep->base.bind_addr, 0);
>  
> -	/* Remember who we are attached to.  */
> -	ep->base.sk = sk;
> -	sock_hold(ep->base.sk);
> -
>  	/* Create the lists of associations.  */
>  	INIT_LIST_HEAD(&ep->asocs);
>  
> @@ -154,6 +150,10 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
>  	ep->prsctp_enable = net->sctp.prsctp_enable;
>  	ep->reconf_enable = net->sctp.reconf_enable;
>  
> +	/* Remember who we are attached to.  */
> +	ep->base.sk = sk;
> +	sock_hold(ep->base.sk);
> +
>  	return ep;
>  
>  nomem_shkey:
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@redhat.com>
