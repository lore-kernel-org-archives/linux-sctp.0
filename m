From: David Miller <davem@davemloft.net>
Date: Mon, 07 Aug 2017 04:33:56 +0000
Subject: Re: [PATCH net-next 00/14] sctp: remove typedefs from structures part 5
Message-Id: <20170806.213356.1004665749442304915.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1501934086.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1501934086.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  5 Aug 2017 19:59:50 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 5 to remove all typedefs in include/net/sctp/constants.h.
> 
> Just as the part 1-4, No any code's logic would be changed in these patches,
> only cleaning up.

Series applied, thank you.
