From: David Miller <davem@davemloft.net>
Date: Wed, 05 Jul 2017 08:06:58 +0000
Subject: Re: [PATCH net-next 00/11] sctp: remove typedefs from structures part 2
Message-Id: <20170705.090658.1783363888745270081.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1499214692.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1499214692.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  5 Jul 2017 08:32:18 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 2 to remove it for another 11 basic structures.
> 
> Just as the part 1, No any code's logic would be changed in these patches,
> only cleaning up.

net-next is closed, please resubmit this when the tree opens back
up.
