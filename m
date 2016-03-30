From: David Miller <davem@davemloft.net>
Date: Wed, 30 Mar 2016 19:42:21 +0000
Subject: Re: [PATCH] sctp: really allow using GFP_KERNEL on sctp_packet_transmit
Message-Id: <20160330.154221.1176908955449716860.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1459258863-21351-1-git-send-email-marcelo.leitner@gmail.com>
In-Reply-To: <1459258863-21351-1-git-send-email-marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 29 Mar 2016 10:41:03 -0300

> Somehow my patch for commit cea8768f333e ("sctp: allow
> sctp_transmit_packet and others to use gfp") missed two important
> chunks, which are now added.
> 
> Fixes: cea8768f333e ("sctp: allow sctp_transmit_packet and others to use gfp")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
