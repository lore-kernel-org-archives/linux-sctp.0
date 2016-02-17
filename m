From: David Miller <davem@davemloft.net>
Date: Wed, 17 Feb 2016 20:42:31 +0000
Subject: Re: [PATCH net 0/3] sctp: some cleanups for sctp
Message-Id: <20160217.154231.1059835157683583160.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1455517541.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1455517541.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Feb 2016 14:28:02 +0800

> There are some unused function and redundant rcu locks should be
> removed.

Series applied to net-next, please target cleanups to the appropriate
tree in the future.

Also, please respond to Neil Horman's query about the use of BH
RCU locking wrt. patch #1.

Thanks.
