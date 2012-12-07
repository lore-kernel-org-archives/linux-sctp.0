From: David Miller <davem@davemloft.net>
Date: Fri, 07 Dec 2012 19:15:58 +0000
Subject: Re: [PATCH 0/2 v2] sctp: RCU protection when accessing assoc members for procfs
Message-Id: <20121207.141558.432893641652497152.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1354821623.git.tgraf@suug.ch>
In-Reply-To: <cover.1354821623.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tgraf@suug.ch
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Thomas Graf <tgraf@suug.ch>
Date: Thu,  6 Dec 2012 20:25:03 +0100

> @Dave: This is a respin of the following patches:
>   [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
>   [PATCH] sctp: Add RCU protection to assoc->transport_addr_list
> 
> Thomas Graf (2):
>   sctp: proc: protect bind_addr->address_list accesses with
>     rcu_read_lock()
>   sctp: Add RCU protection to assoc->transport_addr_list

Series applied, thanks.
