From: David Miller <davem@davemloft.net>
Date: Tue, 28 Nov 2017 20:56:19 +0000
Subject: Re: [PATCH net] sctp: use right member as the param of list_for_each_entry
Message-Id: <20171128.155619.1927237670822390286.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4c3e5049eae1f90d5b74588fa0e115393a173056.1511700966.git.lucien.xin@gmail.com>
In-Reply-To: <4c3e5049eae1f90d5b74588fa0e115393a173056.1511700966.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 20:56:07 +0800

> Commit d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues
> when migrating a sock") made a mistake that using 'list' as the param of
> list_for_each_entry to traverse the retransmit, sacked and abandoned
> queues, while chunks are using 'transmitted_list' to link into these
> queues.
> 
> It could cause NULL dereference panic if there are chunks in any of these
> queues when peeling off one asoc.
> 
> So use the chunk member 'transmitted_list' instead in this patch.
> 
> Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
