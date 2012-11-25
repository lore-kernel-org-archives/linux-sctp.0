From: David Miller <davem@davemloft.net>
Date: Sun, 25 Nov 2012 21:03:11 +0000
Subject: Re: [PATCH] sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall
Message-Id: <20121125.160311.1193801954973499889.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, sri@us.ibm.com, davej@redhat.com

From: Tommi Rantala <tt.rantala@gmail.com>
Date: Thu, 22 Nov 2012 15:23:16 +0200

> Consider the following program, that sets the second argument to the
> sendto() syscall incorrectly:
 ...
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

This also looks good, Vlad please review this.

Thanks.
