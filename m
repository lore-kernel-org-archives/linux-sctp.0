From: David Miller <davem@davemloft.net>
Date: Tue, 20 Jun 2017 19:33:07 +0000
Subject: Re: [PATCH net-next] sctp: uncork the old asoc before changing to the new one
Message-Id: <20170620.153307.400521275017001944.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <99205651b831cf7fd7b847f9b5c904fbf57ce416.1497945715.git.lucien.xin@gmail.com>
In-Reply-To: <99205651b831cf7fd7b847f9b5c904fbf57ce416.1497945715.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Jun 2017 16:01:55 +0800

> local_cork is used to decide if it should uncork asoc outq after processing
> some cmds, and it is set when replying or sending msgs. local_cork should
> always have the same value with current asoc q->cork in some way.
> 
> The thing is when changing to a new asoc by cmd SET_ASOC, local_cork may
> not be consistent with the current asoc any more. The cmd seqs can be:
> 
>   SCTP_CMD_UPDATE_ASSOC (asoc)
>   SCTP_CMD_REPLY (asoc)
>   SCTP_CMD_SET_ASOC (new_asoc)
>   SCTP_CMD_DELETE_TCB (new_asoc)
>   SCTP_CMD_SET_ASOC (asoc)
>   SCTP_CMD_REPLY (asoc)
> 
> The 1st REPLY makes OLD asoc q->cork and local_cork both are 1, and the cmd
> DELETE_TCB clears NEW asoc q->cork and local_cork. After asoc goes back to
> OLD asoc, q->cork is still 1 while local_cork is 0. The 2nd REPLY will not
> set local_cork because q->cork is already set and it can't be uncorked and
> sent out because of this.
> 
> To keep local_cork consistent with the current asoc q->cork, this patch is
> to uncork the old asoc if local_cork is set before changing to the new one.
> 
> Note that the above cmd seqs will be used in the next patch when updating
> asoc and handling errors in it.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
