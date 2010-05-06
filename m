From: David Miller <davem@davemloft.net>
Date: Thu, 06 May 2010 07:56:52 +0000
Subject: Re: [PATCH v2] sctp: Fix a race between ICMP protocol unreachable
Message-Id: <20100506.005652.123997294.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1273087783-18250-1-git-send-email-vladislav.yasevich@hp.com>
	<1273088166-18391-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1273088166-18391-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  5 May 2010 15:36:06 -0400

> ICMP protocol unreachable handling completely disregarded
> the fact that the user may have locket the socket.  It proceeded
> to destroy the association, even though the user may have
> held the lock and had a ref on the association.  This resulted
> in the following:
> 
> Attempt to release alive inet socket f6afcc00
 ...
> This was because the sctp_wait_for_connect() would aqcure the socket
> lock and then proceed to release the last reference count on the
> association, thus cause the fully destruction path to finish freeing
> the socket.
> 
> The simplest solution is to start a very short timer in case the socket
> is owned by user.  When the timer expires, we can do some verification
> and be able to do the release properly.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied and queued up for -stable, thanks Vlad.
