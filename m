From: David Miller <davem@davemloft.net>
Date: Mon, 29 Jul 2019 21:02:30 +0000
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-Id: <20190729.140230.1634068737729359180.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564426521-22525-1-git-send-email-info@metux.net>
In-Reply-To: <1564426521-22525-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: info@metux.net
Cc: linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Date: Mon, 29 Jul 2019 20:55:21 +0200

> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Applied.
