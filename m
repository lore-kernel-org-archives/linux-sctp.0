From: David Miller <davem@davemloft.net>
Date: Fri, 29 May 2020 20:11:28 +0000
Subject: Re: remove kernel_setsockopt v4
Message-Id: <20200529.131128.495042470763103913.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
In-Reply-To: <20200529120943.101454-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: kuba@kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 29 May 2020 14:09:39 +0200

> now that only the dlm calls to sctp are left for kernel_setsockopt,
> while we haven't really made much progress with the sctp setsockopt
> refactoring, how about this small series that splits out a
> sctp_setsockopt_bindx_kernel that takes a kernel space address array
> to share more code as requested by Marcelo.  This should fit in with
> whatever variant of the refator of sctp setsockopt we go with, but
> just solved the immediate problem for now.
 ...

Series applied, thanks.
