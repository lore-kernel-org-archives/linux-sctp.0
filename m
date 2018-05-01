From: David Miller <davem@davemloft.net>
Date: Tue, 01 May 2018 16:13:53 +0000
Subject: Re: [PATCH net-next 0/2] sctp: unify sctp_make_op_error_fixed and sctp_make_op_error_space
Message-Id: <20180501.121353.1918662858023133319.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525017179.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1525017179.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sun, 29 Apr 2018 12:56:30 -0300

> These two variants are very close to each other and can be merged
> to avoid code duplication. That's what this patchset does.
> 
> First, we allow sctp_init_cause to return errors, which then allow us to
> add sctp_make_op_error_limited that handles both situations.

Series applied.

But generally, there are a lot of smtp_init_cause() call sites with non-zero
payload length that should start checking the return value now.
