From: David Miller <davem@davemloft.net>
Date: Sat, 10 Sep 2016 02:17:46 +0000
Subject: Re: [PATCH net] sctp: hold the transport before using it in sctp_hash_cmp
Message-Id: <20160909.191746.1850636311022712919.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
In-Reply-To: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Thu,  8 Sep 2016 17:49:04 +0800

> Now sctp uses the transport without holding it in sctp_hash_cmp,
> it can cause a use-after-free panic. As after it get transport from
> hashtable, another CPU may free it, then the members it accesses
> may be unavailable memory.
> 
> This patch is to use sctp_transport_hold, in which it checks the
> refcnt first, holds it if it's not 0.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Please add more detail to the commit message and add a proper
"Fixes: " tag right before your signoff.

Thanks.

