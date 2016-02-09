From: David Miller <davem@davemloft.net>
Date: Tue, 09 Feb 2016 09:54:09 +0000
Subject: Re: [PATCH net] sctp: translate network order to host order when users get a hmacid
Message-Id: <20160209.045409.1138087933631573325.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f763fd2125356a2484bef0b6d083fdd38b13e8db.1454513610.git.lucien.xin@gmail.com>
In-Reply-To: <f763fd2125356a2484bef0b6d083fdd38b13e8db.1454513610.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  3 Feb 2016 23:33:30 +0800

> Commit ed5a377d87dc ("sctp: translate host order to network order when
> setting a hmacid") corrected the hmacid byte-order when setting a hmacid.
> but the same issue also exists on getting a hmacid.
> 
> We fix it by changing hmacids to host order when users get them with
> getsockopt.
> 
> Fixes: Commit ed5a377d87dc ("sctp: translate host order to network order when setting a hmacid")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.

Thanks.
