From: David Miller <davem@davemloft.net>
Date: Wed, 30 Dec 2015 21:58:03 +0000
Subject: Re: [PATCHv2 net] sctp: sctp should release assoc when sctp_make_abort_user return NULL in sctp_clos
Message-Id: <20151230.165803.1943612324215674129.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <038f05a2f35f3be88976ee1b59578bd5e5112112.1451382565.git.lucien.xin@gmail.com>
In-Reply-To: <038f05a2f35f3be88976ee1b59578bd5e5112112.1451382565.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Dec 2015 17:49:25 +0800

> In sctp_close, sctp_make_abort_user may return NULL because of memory
> allocation failure. If this happens, it will bypass any state change
> and never free the assoc. The assoc has no chance to be freed and it
> will be kept in memory with the state it had even after the socket is
> closed by sctp_close().
> 
> So if sctp_make_abort_user fails to allocate memory, we should abort
> the asoc via sctp_primitive_ABORT as well. Just like the annotation in
> sctp_sf_cookie_wait_prm_abort and sctp_sf_do_9_1_prm_abort said,
> "Even if we can't send the ABORT due to low memory delete the TCB.
> This is a departure from our typical NOMEM handling".
> 
> But then the chunk is NULL (low memory) and the SCTP_CMD_REPLY cmd would
> dereference the chunk pointer, and system crash. So we should add
> SCTP_CMD_REPLY cmd only when the chunk is not NULL, just like other
> places where it adds SCTP_CMD_REPLY cmd.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
