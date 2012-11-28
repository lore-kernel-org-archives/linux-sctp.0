From: David Miller <davem@davemloft.net>
Date: Wed, 28 Nov 2012 16:11:48 +0000
Subject: Re: [PATCH] sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
Message-Id: <20121128.111148.259100136370359105.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20121126.173429.323283427379416132.davem@davemloft.net>
	<1354024906-1925-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1354024906-1925-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, davej@redhat.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Tue, 27 Nov 2012 16:01:46 +0200

> Trinity (the syscall fuzzer) discovered a memory leak in SCTP,
> reproducible e.g. with the sendto() syscall by passing invalid
> user space pointer in the second argument:
...
> As far as I can tell, the leak has been around since ~2003.
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

Applied.
