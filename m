From: David Miller <davem@davemloft.net>
Date: Fri, 30 Sep 2016 06:14:02 +0000
Subject: Re: [PATCH v6 0/7] Reduce cache miss for snmp_fold_field
Message-Id: <20160930.021402.267441690910051825.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1475206144-23228-1-git-send-email-hejianet@gmail.com>
In-Reply-To: <1475206144-23228-1-git-send-email-hejianet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hejianet@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, vyasevich@gmail.com, nhorman@tuxdriver.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, marcelo.leitner@gmail.com

From: Jia He <hejianet@gmail.com>
Date: Fri, 30 Sep 2016 11:28:57 +0800

> In a PowerPc server with large cpu number(160), besides commit
> a3a773726c9f ("net: Optimize snmp stat aggregation by walking all
> the percpu data at once"), I watched several other snmp_fold_field
> callsites which would cause high cache miss rate.
 ...

Series applied, thank you.
