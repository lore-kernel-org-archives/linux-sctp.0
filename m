From: David Miller <davem@davemloft.net>
Date: Mon, 24 Jul 2017 23:01:42 +0000
Subject: Re: [PATCH net-next 00/11] sctp: remove typedefs from structures part 3
Message-Id: <20170724.160142.2083958119525898930.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500773578.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1500773578.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 23 Jul 2017 09:34:25 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 3 to remove it for another 11 basic structures from linux/sctp.h.
> 
> Just as the part 1 and 2, No any code's logic would be changed in these
> patches, only cleaning up.

Series applied, thanks.
