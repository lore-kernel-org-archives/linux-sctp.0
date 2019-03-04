From: David Miller <davem@davemloft.net>
Date: Mon, 04 Mar 2019 19:04:46 +0000
Subject: Re: [PATCH net 0/3] sctp: process the error returned from sctp_sock_migrate()
Message-Id: <20190304.110446.183212698676561343.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  3 Mar 2019 17:54:52 +0800

> This patchset is to process the errs returned by sctp_auth_init_hmacs()
> and sctp_bind_addr_dup() from sctp_sock_migrate(). And also fix a panic
> caused by new ep->auth_hmacs was not set due to net->sctp.auth_enable
> changed by sysctl before accepting an assoc.

I'll give Neil and Marcelo a change to review this.
