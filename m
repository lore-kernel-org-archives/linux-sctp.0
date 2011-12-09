From: David Miller <davem@davemloft.net>
Date: Fri, 09 Dec 2011 00:54:20 +0000
Subject: Re: [PATCH] sctp: fix incorrect overflow check on autoclose
Message-Id: <20111208.195420.1294225425698924505.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1323335350-18072-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1323335350-18072-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>
Date: Thu,  8 Dec 2011 04:09:10 -0500

> The commit 8ffd3208 voids the previous patches f6778aab and 810c0719
> for limiting the maximum autoclose value.  If userspace passes in -1
> on 32-bit platform, the overflow check didn't work and autoclose
> would be set to 0xffffffff.
> 
> CC: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrei Pelinescu-Onciul <andrei@iptel.org>
> Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

If you actually want me to apply this you absolutely must post it,
in it's entirety, to netdev.
