From: David Miller <davem@davemloft.net>
Date: Mon, 10 Jun 2019 16:38:16 +0000
Subject: Re: [PATCH] Free cookie before we memdup a new one
Message-Id: <20190610.093816.262800300265390788.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
In-Reply-To: <20190610163456.7778-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, marcelo.leitner@gmail.com, lucien.xin@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 10 Jun 2019 12:34:56 -0400

> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Please post with an appropriate subsystem prefix in the Subject.

Thank you.
