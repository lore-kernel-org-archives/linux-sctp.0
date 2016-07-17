From: David Miller <davem@davemloft.net>
Date: Sun, 17 Jul 2016 05:02:36 +0000
Subject: Re: [PATCH net-next] sctp: fix GSO for IPv6
Message-Id: <20160716.220236.1000782551064979182.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cc3fc851d2ff9abfe104807381cc21280648410d.1468609983.git.marcelo.leitner@gmail.com>
In-Reply-To: <cc3fc851d2ff9abfe104807381cc21280648410d.1468609983.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 15 Jul 2016 16:40:02 -0300

> commit 90017accff61 ("sctp: Add GSO support") didn't register SCTP GSO
> offloading for IPv6 and yet didn't put any restrictions on generating
> GSO packets while in IPv6, which causes all IPv6 GSO'ed packets to be
> silently dropped.
> 
> The fix is to properly register the offload this time.
> 
> Fixes: 90017accff61 ("sctp: Add GSO support")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
