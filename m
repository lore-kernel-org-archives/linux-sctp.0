From: David Miller <davem@davemloft.net>
Date: Thu, 14 Aug 2008 22:33:40 +0000
Subject: Re: [PATCH v2] netns: Add network namespace argument to
Message-Id: <20080814.153340.241442105.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <48A4A5C4.4080109@hp.com>
In-Reply-To: <48A4A5C4.4080109@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brian.haley@hp.com
Cc: yoshfuji@linux-ipv6.org, containers@lists.osdl.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Brian Haley <brian.haley@hp.com>
Date: Thu, 14 Aug 2008 17:38:12 -0400

> ipv6_dev_get_saddr() blindly de-references dst_dev to get the network
> namespace, but some callers might pass NULL.  Change callers to pass a
> namespace pointer instead.
> 
> Signed-off-by: Brian Haley <brian.haley@hp.com>

This looks tons better than your first attempt :-)

Applied, thanks Brian.
