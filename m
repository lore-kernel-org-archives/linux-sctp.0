From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 17 Oct 2018 20:42:01 +0000
Subject: Re: [PATCH net] sctp: fix race on sctp_id2asoc
Message-Id: <20181017204201.GB4824@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <081e1546a92f5bde8bdef0366561ff0b8ddd9eb2.1539707812.git.mleitner@redhat.com>
In-Reply-To: <081e1546a92f5bde8bdef0366561ff0b8ddd9eb2.1539707812.git.mleitner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Dmitry Vyukov <dvyukov@google.com>

On Tue, Oct 16, 2018 at 03:18:17PM -0300, Marcelo Ricardo Leitner wrote:
> syzbot reported an use-after-free involving sctp_id2asoc.  Dmitry Vyukov
> helped to root cause it and it is because of reading the asoc after it
> was freed:
> 
>         CPU 1                       CPU 2
> (working on socket 1)            (working on socket 2)
> 	                         sctp_association_destroy
> sctp_id2asoc
>    spin lock
>      grab the asoc from idr
>    spin unlock
>                                    spin lock
> 				     remove asoc from idr
> 				   spin unlock
> 				   free(asoc)
>    if asoc->base.sk != sk ... [*]
> 
> This can only be hit if trying to fetch asocs from different sockets. As
> we have a single IDR for all asocs, in all SCTP sockets, their id is
> unique on the system. An application can try to send stuff on an id
> that matches on another socket, and the if in [*] will protect from such
> usage. But it didn't consider that as that asoc may belong to another
> socket, it may be freed in parallel (read: under another socket lock).
> 
> We fix it by moving the checks in [*] into the protected region. This
> fixes it because the asoc cannot be freed while the lock is held.
> 
> Reported-by: syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/socket.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index f73e9d38d5ba734d7ee3347e4015fd30d355bbfa..a7722f43aa69801c31409d4914c99946ee5533f5 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -271,11 +271,10 @@ struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id)
>  
>  	spin_lock_bh(&sctp_assocs_id_lock);
>  	asoc = (struct sctp_association *)idr_find(&sctp_assocs_id, (int)id);
> +	if (asoc && (asoc->base.sk != sk || asoc->base.dead))
> +		asoc = NULL;
>  	spin_unlock_bh(&sctp_assocs_id_lock);
>  
> -	if (!asoc || (asoc->base.sk != sk) || asoc->base.dead)
> -		return NULL;
> -
>  	return asoc;
>  }
>  
> -- 
> 2.17.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
