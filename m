From: David Miller <davem@davemloft.net>
Date: Wed, 25 Apr 2018 17:22:20 +0000
Subject: Re: [PATCH net-next] sctp: fix const parameter violation in sctp_make_sack
Message-Id: <20180425.132220.486012512001964938.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b9065b3cfb0a2bf3c83008ff53967f473e081766.1524603855.git.marcelo.leitner@gmail.com>
In-Reply-To: <b9065b3cfb0a2bf3c83008ff53967f473e081766.1524603855.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 24 Apr 2018 18:17:34 -0300

> sctp_make_sack() make changes to the asoc and this cast is just
> bypassing the const attribute. As there is no need to have the const
> there, just remove it and fix the violation.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
