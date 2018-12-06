From: David Miller <davem@davemloft.net>
Date: Thu, 06 Dec 2018 08:03:47 +0000
Subject: Re: [PATCH net] sctp: fix pr_warn max_data argument type mismatch
Message-Id: <20181206.000347.363769635369199993.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181206075837.13336-1-jakub.audykowicz@gmail.com>
In-Reply-To: <20181206075837.13336-1-jakub.audykowicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jakub.audykowicz@gmail.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org

From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Thu,  6 Dec 2018 08:58:37 +0100

> My previous patch introduced a compilation warning regarding a type
> mismatch (int vs size_t). This is a one-letter fix for good housekeeping.
> 
> Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>

Still wrong and I fixed it when I applied your patch.

You need to use the 'Z' prefix for size_t, so %Zu in this case.
