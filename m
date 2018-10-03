From: David Miller <davem@davemloft.net>
Date: Wed, 03 Oct 2018 16:33:25 +0000
Subject: Re: [PATCH] sctp: fix fall-through annotation
Message-Id: <20181003.093325.94472342025577659.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181003104556.GA23489@embeddedor.com>
In-Reply-To: <20181003104556.GA23489@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gustavo@embeddedor.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 3 Oct 2018 12:45:56 +0200

> Replace "fallthru" with a proper "fall through" annotation.
> 
> This fix is part of the ongoing efforts to enabling
> -Wimplicit-fallthrough
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
