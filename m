From: David Miller <davem@davemloft.net>
Date: Wed, 22 Mar 2017 01:31:14 +0000
Subject: Re: [PATCH net] sctp: remove temporary variable confirm from sctp_packet_transmit
Message-Id: <20170321.183114.2143246486541537142.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a1bef2ad80e5a7338fc5c6786ea61835014b8c61.1489835542.git.lucien.xin@gmail.com>
In-Reply-To: <a1bef2ad80e5a7338fc5c6786ea61835014b8c61.1489835542.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, ja@ssi.bg

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Mar 2017 19:12:22 +0800

> Commit c86a773c7802 ("sctp: add dst_pending_confirm flag") introduced
> a temporary variable "confirm" in sctp_packet_transmit.
> 
> But it broke the rule that longer lines should be above shorter ones.
> Besides, this variable is not necessary, so this patch is to just
> remove it and use tp->dst_pending_confirm directly.
> 
> Fixes: c86a773c7802 ("sctp: add dst_pending_confirm flag")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
