From: David Miller <davem@davemloft.net>
Date: Sat, 09 Jul 2016 04:08:54 +0000
Subject: Re: [PATCH] sctp: fix panic when sending auth chunks
Message-Id: <20160709.000854.945698278700890168.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <433dedb6a14cd5bd59ad2f82579d872b97171727.1467894889.git.marcelo.leitner@gmail.com>
In-Reply-To: <433dedb6a14cd5bd59ad2f82579d872b97171727.1467894889.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu,  7 Jul 2016 09:39:29 -0300

> When we introduced GSO support, if using auth the auth chunk was being
> left queued on the packet even after the final segment was generated.
> Later on sctp_transmit_packet it calls sctp_packet_reset, which zeroed
> the packet len while not accounting for this left-over. This caused more
> space to be used the next packet due to the chunk still being queued,
> but space which wasn't allocated as its size wasn't accounted.
> 
> The fix is to only queue it back when we know that we are going to
> generate another segment.
> 
> Fixes: 90017accff61 ("sctp: Add GSO support")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied to net-next.

Please make the target tree for your patch explicit in future
submissions.

Thanks.
