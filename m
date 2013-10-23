From: David Miller <davem@davemloft.net>
Date: Wed, 23 Oct 2013 20:57:36 +0000
Subject: Re: [PATCH net] net: sctp: fix ASCONF to allow non SCTP_ADDR_SRC addresses in ipv6
Message-Id: <20131023.165736.804778459722407050.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382459696-1732-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1382459696-1732-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, micchie@sfc.wide.ad.jp

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 22 Oct 2013 18:34:56 +0200

> Commit 8a07eb0a50 ("sctp: Add ASCONF operation on the single-homed host")
> implemented possible use of IPv4 addresses with non SCTP_ADDR_SRC state
> as source address when sending ASCONF (ADD) packets, but IPv6 part for
> that was not implemented in 8a07eb0a50. Therefore, as this is not restricted
> to IPv4-only, fix this up to allow the same for IPv6 addresses in SCTP.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Michio Honda <micchie@sfc.wide.ad.jp>

Applied, thanks.
