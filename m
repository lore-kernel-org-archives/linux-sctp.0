From: David Miller <davem@davemloft.net>
Date: Wed, 27 Aug 2008 23:10:18 +0000
Subject: Re: [PATCH 2/2] sctp: fix random memory dereference with
Message-Id: <20080827.161018.193134500.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com>
	<12198674171396-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12198674171396-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: eteo@redhat.com, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 27 Aug 2008 16:03:35 -0400

> The number of identifiers needs to be checked against the option
> length.  Also, the identifier index provided needs to be verified
> to make sure that it doesn't exceed the bounds of the array.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Also applied and queued to -stable, thanks Vlad.
