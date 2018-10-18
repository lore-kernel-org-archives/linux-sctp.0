From: David Miller <davem@davemloft.net>
Date: Thu, 18 Oct 2018 18:24:01 +0000
Subject: Re: [PATCH net-next 0/2] sctp: fix sk_wmem_queued and use it to check for writable space
Message-Id: <20181018.112401.1272099069880898325.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1539716812.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1539716812.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 17 Oct 2018 03:07:49 +0800

> sctp doesn't count and use asoc sndbuf_used, sk sk_wmem_alloc and
> sk_wmem_queued properly, which also causes some problem.
> 
> This patchset is to improve it.

Series applied, thanks.
