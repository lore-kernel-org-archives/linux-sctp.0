From: David Miller <davem@davemloft.net>
Date: Thu, 29 Aug 2013 19:55:27 +0000
Subject: Re: [PATCH net-next v3] net: sctp: sctp_verify_init: clean up mandatory checks and add comment
Message-Id: <20130829.155527.1331594681514143386.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377615232-11412-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377615232-11412-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 27 Aug 2013 16:53:52 +0200

> Add a comment related to RFC4960 explaning why we do not check for initial
> TSN, and while at it, remove yoda notation checks and clean up code from
> checks of mandatory conditions. That's probably just really minor, but makes
> reviewing easier.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks.
