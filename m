From: David Miller <davem@davemloft.net>
Date: Fri, 15 Apr 2016 21:30:25 +0000
Subject: Re: [PATCHv3 net-next 0/6] sctp: support sctp_diag in kernel
Message-Id: <20160415.173025.576682964050812112.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460618169.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1460618169.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, eric.dumazet@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Apr 2016 15:35:29 +0800

> This patchset will add sctp_diag module to implement diag interface on
> sctp in kernel.
 ...

Looks good to me, series applied, thanks.

Please follow up on the suggestion to use jiffies_to_ms(), thanks.
