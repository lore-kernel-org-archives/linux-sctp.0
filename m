From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 17 Oct 2018 14:57:39 +0000
Subject: Re: [PATCH net] sctp: not free the new asoc when sctp_wait_for_connect returns err
Message-Id: <20181017145739.GG6761@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <6ee31cce8c2e36a7e189de11c13c257e8c45b42f.1539716772.git.lucien.xin@gmail.com>
In-Reply-To: <6ee31cce8c2e36a7e189de11c13c257e8c45b42f.1539716772.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, Oct 17, 2018 at 03:06:12AM +0800, Xin Long wrote:
> When sctp_wait_for_connect is called to wait for connect ready
> for sp->strm_interleave in sctp_sendmsg_to_asoc, a panic could
> be triggered if cpu is scheduled out and the new asoc is freed
> elsewhere, as it will return err and later the asoc gets freed
> again in sctp_sendmsg.
> 
> [  285.840764] list_del corruption, ffff9f0f7b284078->next is LIST_POISON1 (dead000000000100)
> [  285.843590] WARNING: CPU: 1 PID: 8861 at lib/list_debug.c:47 __list_del_entry_valid+0x50/0xa0
> [  285.846193] Kernel panic - not syncing: panic_on_warn set ...
> [  285.846193]
> [  285.848206] CPU: 1 PID: 8861 Comm: sctp_ndata Kdump: loaded Not tainted 4.19.0-rc7.label #584
> [  285.850559] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  285.852164] Call Trace:
> ...
> [  285.872210]  ? __list_del_entry_valid+0x50/0xa0
> [  285.872894]  sctp_association_free+0x42/0x2d0 [sctp]
> [  285.873612]  sctp_sendmsg+0x5a4/0x6b0 [sctp]
> [  285.874236]  sock_sendmsg+0x30/0x40
> [  285.874741]  ___sys_sendmsg+0x27a/0x290
> [  285.875304]  ? __switch_to_asm+0x34/0x70
> [  285.875872]  ? __switch_to_asm+0x40/0x70
> [  285.876438]  ? ptep_set_access_flags+0x2a/0x30
> [  285.877083]  ? do_wp_page+0x151/0x540
> [  285.877614]  __sys_sendmsg+0x58/0xa0
> [  285.878138]  do_syscall_64+0x55/0x180
> [  285.878669]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This is a similar issue with the one fixed in Commit ca3af4dd28cf
> ("sctp: do not free asoc when it is already dead in sctp_sendmsg").
> But this one can't be fixed by returning -ESRCH for the dead asoc
> in sctp_wait_for_connect, as it will break sctp_connect's return
> value to users.
> 
> This patch is to simply set err to -ESRCH before it returns to
> sctp_sendmsg when any err is returned by sctp_wait_for_connect
> for sp->strm_interleave, so that no asoc would be freed due to
> this.
> 
> When users see this error, they will know the packet hasn't been
> sent. And it also makes sense to not free asoc because waiting
> connect fails, like the second call for sctp_wait_for_connect in
> sctp_sendmsg_to_asoc.
> 
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index e25a20f..1baa9d9 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1946,8 +1946,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
>  		if (sp->strm_interleave) {
>  			timeo = sock_sndtimeo(sk, 0);
>  			err = sctp_wait_for_connect(asoc, &timeo);
> -			if (err)
> +			if (err) {
> +				err = -ESRCH;
>  				goto err;
> +			}
>  		} else {
>  			wait_connect = true;
>  		}
> -- 
> 2.1.0
> 
