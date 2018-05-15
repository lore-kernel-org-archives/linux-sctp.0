From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2018 03:15:46 +0000
Subject: Re: [PATCH net-next v3 0/3] sctp: Introduce sctp_flush_ctx
Message-Id: <20180514.231546.1012648994902825567.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526319083.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526319083.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, lucien.xin@gmail.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 14:35:17 -0300

> This struct will hold all the context used during the outq flush, so we
> don't have to pass lots of pointers all around.
> 
> Checked on x86_64, the compiler inlines all these functions and there is no
> derreference added because of the struct.
> 
> This patchset depends on 'sctp: refactor sctp_outq_flush'
> 
> Changes since v1:
> - updated to build on top of v2 of 'sctp: refactor sctp_outq_flush'
> 
> Changes since v2:
> - fixed a rebase issue which reverted a change in patch 2.
> - rebased on v3 of 'sctp: refactor sctp_outq_flush'

Also applied, thanks Marcelo.
