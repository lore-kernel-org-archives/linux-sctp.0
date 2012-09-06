From: David Miller <davem@davemloft.net>
Date: Thu, 06 Sep 2012 18:10:19 +0000
Subject: Re: [PATCH] sctp: check dst validity after IPsec operations
Message-Id: <20120906.141019.129727465932440024.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1346953229-3825-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1346953229-3825-1-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nicolas.dichtel@6wind.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu,  6 Sep 2012 13:40:29 -0400

> dst stored in struct sctp_transport needs to be recalculated when ipsec policy
> are updated. We use flow_cache_genid for that.
> 
> For example, if a SCTP connection is established and then an IPsec policy is
> set, the old SCTP flow will not be updated and thus will not use the new
> IPsec policy.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

I don't like that SCTP need to perform special DST validation.

The normal DST validation mechanism already in place should be
sufficient.

Otherwise this problem must exist in other protocols too, and
fixing a tree wide issue privately inside of one protocol is
not acceptable.
