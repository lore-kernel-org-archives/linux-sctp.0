From: David Miller <davem@davemloft.net>
Date: Mon, 04 Jan 2016 22:30:00 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <20160104.173000.1748782946936467170.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1451490447.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Dec 2015 23:50:45 +0800

> for telecom center, the usual case is that a server is connected by thousands
> of clients. but if the server with only one enpoint(udp style) use the same
> sport and dport to communicate with every clients, and every assoc in server
> will be hashed in the same chain of global assoc hashtable due to currently we
> choose dport and sport as the hash key.
> 
> when a packet is received, sctp_rcv try to find the assoc with sport and dport,
> since that chain is too long to find it fast, it make the performance turn to
> very low, some test data is as follow:
 ...
> we need to change the way to calculate the hash key, to use lport +
> rport + paddr as the hash key can avoid this issue.
> 
> besides, this patchset will use transport hashtable to replace
> association hashtable to lookup with rhashtable api. get transport
> first then get association by t->asoc. and also it will make tcp
> style work better.
 ...

I've applied this series, but...

If anything regresses and is not dealt with in a timely manner I
will revert this series.

Thanks.
