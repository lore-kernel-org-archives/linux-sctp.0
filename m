From: David Miller <davem@davemloft.net>
Date: Sun, 25 Nov 2012 21:01:37 +0000
Subject: Re: [PATCH] sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
Message-Id: <20121125.160137.2302577116716864395.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353590491-12166-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1353590491-12166-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, davej@redhat.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 22 Nov 2012 15:21:31 +0200

> Trinity (the syscall fuzzer) discovered a memory leak in SCTP,
> reproducible e.g. with the sendto() syscall by passing invalid
> user space pointer in the second argument:
 ...
> As far as I can tell, the leak has been around since ~2003.
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

Looks good to me, Vlad please review.
