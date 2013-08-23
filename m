From: David Miller <davem@davemloft.net>
Date: Fri, 23 Aug 2013 05:10:13 +0000
Subject: Re: [PATCH net-next] net: sctp_probe: simplify code by using %pISc format specifier
Message-Id: <20130822.221013.71778942538808574.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377184370-13721-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377184370-13721-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 22 Aug 2013 17:12:50 +0200

> We can simply use the %pISc format specifier that was recently added
> and thus remove some code that distinguishes between IPv4 and IPv6.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
