From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 07 Mar 2019 14:59:50 +0000
Subject: Re: [PATCH net 0/3] sctp: process the error returned from sctp_sock_migrate()
Message-Id: <20190307145950.GG13343@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
 <20190304.110446.183212698676561343.davem@davemloft.net>
In-Reply-To: <20190304.110446.183212698676561343.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

On Mon, Mar 04, 2019 at 11:04:46AM -0800, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Sun,  3 Mar 2019 17:54:52 +0800
> 
> > This patchset is to process the errs returned by sctp_auth_init_hmacs()
> > and sctp_bind_addr_dup() from sctp_sock_migrate(). And also fix a panic
> > caused by new ep->auth_hmacs was not set due to net->sctp.auth_enable
> > changed by sysctl before accepting an assoc.
> 
> I'll give Neil and Marcelo a change to review this.

Please give me one more day. I'm just back from a large holiday.

Thanks,
Marcelo
