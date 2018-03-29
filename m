From: David Miller <davem@davemloft.net>
Date: Thu, 29 Mar 2018 18:38:42 +0000
Subject: Re: [PATCH] [net-next] sctp: fix unused lable warning
Message-Id: <20180329.143842.1841942043775921475.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180328141512.3083992-1-arnd@arndb.de>
In-Reply-To: <20180328141512.3083992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: arnd@arndb.de
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, viro@ZenIV.linux.org.uk, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 28 Mar 2018 16:14:56 +0200

> The proc file cleanup left a label possibly unused:
> 
> net/sctp/protocol.c: In function 'sctp_defaults_init':
> net/sctp/protocol.c:1304:1: error: label 'err_init_proc' defined but not used [-Werror=unused-label]
> 
> This adds an #ifdef around it to match the respective 'goto'.
> 
> Fixes: d47d08c8ca05 ("sctp: use proc_remove_subtree()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
