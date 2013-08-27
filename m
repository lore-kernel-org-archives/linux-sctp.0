From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 27 Aug 2013 14:11:12 +0000
Subject: Re: [PATCH net-next v2] net: sctp: sctp_verify_init: clean up mandatory checks and add comment
Message-Id: <20130827141112.GC7619@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377612363-10779-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377612363-10779-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Aug 27, 2013 at 04:06:03PM +0200, Daniel Borkmann wrote:
> Add a comment related to RFC4960 explaning why we do not check for initial
> TSN, and while at it, remove yoda notation checks and clean up code from
> checks of mandatory conditions. That's probably just really minor, but makes
> reviewing easier.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Thanks Daniel
Acked-by: Neil Horman <nhorman@tuxdriver.com>

