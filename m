From: David Miller <davem@davemloft.net>
Date: Fri, 12 Apr 2013 23:28:00 +0000
Subject: Re: [PATCH v3] sctp: Add buffer utilization fields to /proc/net/sctp/assocs
Message-Id: <20130412.192800.2206884577519855725.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1365808931.6961.14.camel@pro6455b.example.com>
In-Reply-To: <1365808931.6961.14.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dilip.daya@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, dborkman@redhat.com

From: Dilip Daya <dilip.daya@hp.com>
Date: Fri, 12 Apr 2013 19:22:11 -0400

> From: Dilip Daya <dilip.daya@hp.com>
> 
> This patch adds the following fields to /proc/net/sctp/assocs output:
> 
> 	- sk->sk_wmem_alloc as "wmema"	(transmit queue bytes committed)
> 	- sk->sk_wmem_queued as "wmemq"	(persistent queue size)
> 	- sk->sk_sndbuf as "sndbuf"	(size of send buffer in bytes)
> 	- sk->sk_rcvbuf as "rcvbuf"	(size of receive buffer in bytes)
 ...
> Signed-off-by: Dilip Daya <dilip.daya@hp.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Looks good, applied, thanks.
