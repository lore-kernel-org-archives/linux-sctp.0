From: David Miller <davem@davemloft.net>
Date: Mon, 17 Jul 2017 03:52:33 +0000
Subject: Re: [PATCHv2 net-next 00/11] sctp: remove typedefs from structures part 2
Message-Id: <20170716.205233.2087763419010615489.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1500261974.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1500261974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Jul 2017 11:29:48 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. This patchset is the
> part 2 to remove it for another 11 basic structures.
> 
> Just as the part 1, No any code's logic would be changed in these patches,
> only cleaning up.
> 
> Note that v1->v2, nothing changed, just because net-next were closed when
> posting v1.

Series applied, thank you.
