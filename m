From: David Miller <davem@davemloft.net>
Date: Tue, 28 Nov 2017 16:00:54 +0000
Subject: Re: [PATCH net 0/3] sctp: fix some other sparse errors
Message-Id: <20171128.110054.556910942301586617.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511698478.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1511698478.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 20:16:05 +0800

> After the last fixes for sparse errors, there are still three sparse
> errors in sctp codes, two of them are type cast, and the other one
> is using extern.

Series applied.
