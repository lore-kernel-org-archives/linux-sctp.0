From: David Miller <davem@davemloft.net>
Date: Thu, 03 Aug 2017 16:46:05 +0000
Subject: Re: [PATCH net-next 00/14] sctp: remove typedefs from structures part 4
Message-Id: <20170803.094605.2134265917430921792.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1501745729.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1501745729.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu,  3 Aug 2017 15:42:08 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 4 to remove it for another 14 basic structures from linux/sctp.h.
> After this patchset, all typedefs are cleaned in linux/sctp.h.
> 
> Just as the part 1-3, No any code's logic would be changed in these patches,
> only cleaning up.

Series applied, thanks.
