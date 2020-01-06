From: David Miller <davem@redhat.com>
Date: Mon, 06 Jan 2020 21:29:22 +0000
Subject: Re: [PATCH net] sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY
Message-Id: <20200106.132922.717594592451500648.davem@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
In-Reply-To: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  4 Jan 2020 14:15:02 +0800

> This patch is to fix a memleak caused by no place to free cmd->obj.chunk
> for the unprocessed SCTP_CMD_REPLY. This issue occurs when failing to
> process a cmd while there're still SCTP_CMD_REPLY cmds on the cmd seq
> with an allocated chunk in cmd->obj.chunk.
> 
> So fix it by freeing cmd->obj.chunk for each SCTP_CMD_REPLY cmd left on
> the cmd seq when any cmd returns error. While at it, also remove 'nomem'
> label.
> 
> Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
