From: David Miller <davem@davemloft.net>
Date: Wed, 26 May 2010 07:40:20 +0000
Subject: Re: [patch] sctp: dubious bitfields in sctp_transport
Message-Id: <20100526.004020.59666337.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100522202024.GL22515@bicker>
In-Reply-To: <20100522202024.GL22515@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: error27@gmail.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, yjwei@cn.fujitsu.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Sat, 22 May 2010 22:20:24 +0200

> Sparse complains because these one-bit bitfields are signed.
>   include/net/sctp/structs.h:879:24: error: dubious one-bit signed bitfield
>   include/net/sctp/structs.h:889:31: error: dubious one-bit signed bitfield
>   include/net/sctp/structs.h:895:26: error: dubious one-bit signed bitfield
>   include/net/sctp/structs.h:898:31: error: dubious one-bit signed bitfield
>   include/net/sctp/structs.h:901:27: error: dubious one-bit signed bitfield
> 
> It doesn't cause a problem in the current code, but it would be better
> to clean it up.  This was introduced by c0058a35aacc7: "sctp: Save some
> room in the sctp_transport by using bitfields".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied, thanks Dan.
