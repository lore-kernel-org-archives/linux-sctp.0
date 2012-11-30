From: David Miller <davem@davemloft.net>
Date: Fri, 30 Nov 2012 17:21:46 +0000
Subject: Re: [PATCH] sctp: fix CONFIG_SCTP_DBG_MSG=y null pointer dereference in sctp_v6_get_dst()
Message-Id: <20121130.122146.1137813662572852735.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1354267062-15888-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1354267062-15888-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, davej@redhat.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Fri, 30 Nov 2012 11:17:42 +0200

> Trinity (the syscall fuzzer) triggered the following BUG, reproducible
> only when the kernel is configured with CONFIG_SCTP_DBG_MSG=y.
> 
> When CONFIG_SCTP_DBG_MSG is not set, the null pointer is never
> dereferenced.
 ...
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

Applied, thanks.
