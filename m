From: David Miller <davem@davemloft.net>
Date: Mon, 18 Dec 2017 18:22:15 +0000
Subject: Re: [PATCH net] sctp: fix the issue that a __u16 variable may overflow in sctp_ulpq_renege
Message-Id: <20171218.132215.2106189921344751013.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <047a7d68a197ff748b48eb8cda4b08fd5b9623fe.1513577245.git.lucien.xin@gmail.com>
In-Reply-To: <047a7d68a197ff748b48eb8cda4b08fd5b9623fe.1513577245.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Dec 2017 14:07:25 +0800

> Now when reneging events in sctp_ulpq_renege(), the variable freed
> could be increased by a __u16 value twice while freed is of __u16
> type. It means freed may overflow at the second addition.
> 
> This patch is to fix it by using __u32 type for 'freed', while at
> it, also to remove 'if (chunk)' check, as all renege commands are
> generated in sctp_eat_data and it can't be NULL.
> 
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
