From: David Miller <davem@davemloft.net>
Date: Fri, 23 Dec 2016 19:01:59 +0000
Subject: Re: [PATCH net] sctp: do not loose window information if in rwnd_over
Message-Id: <20161223.140159.2291080991092269291.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <14d1eef1c9da4fcebc53d428a59ecaefab439b2c.1482510284.git.marcelo.leitner@gmail.com>
In-Reply-To: <14d1eef1c9da4fcebc53d428a59ecaefab439b2c.1482510284.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 23 Dec 2016 14:29:02 -0200

> It's possible that we receive a packet that is larger than current
> window. If it's the first packet in this way, it will cause it to
> increase rwnd_over. Then, if we receive another data chunk (specially as
> SCTP allows you to have one data chunk in flight even during 0 window),
> rwnd_over will be overwritten instead of added to.
> 
> In the long run, this could cause the window to grow bigger than its
> initial size, as rwnd_over would be charged only for the last received
> data chunk while the code will try open the window for all packets that
> were received and had its value in rwnd_over overwritten. This, then,
> can lead to the worsening of payload/buffer ratio and cause rwnd_press
> to kick in more often.
> 
> The fix is to sum it too, same as is done for rwnd_press, so that if we
> receive 3 chunks after closing the window, we still have to release that
> same amount before re-opening it.
> 
> Log snippet from sctp_test exhibiting the issue:
> [  146.209232] sctp: sctp_assoc_rwnd_decrease: asoc:ffff88013928e000
> rwnd decreased by 1 to (0, 1, 114221)
> [  146.209232] sctp: sctp_assoc_rwnd_decrease:
> association:ffff88013928e000 has asoc->rwnd:0, asoc->rwnd_over:1!
> [  146.209232] sctp: sctp_assoc_rwnd_decrease: asoc:ffff88013928e000
> rwnd decreased by 1 to (0, 1, 114221)
> [  146.209232] sctp: sctp_assoc_rwnd_decrease:
> association:ffff88013928e000 has asoc->rwnd:0, asoc->rwnd_over:1!
> [  146.209232] sctp: sctp_assoc_rwnd_decrease: asoc:ffff88013928e000
> rwnd decreased by 1 to (0, 1, 114221)
> [  146.209232] sctp: sctp_assoc_rwnd_decrease:
> association:ffff88013928e000 has asoc->rwnd:0, asoc->rwnd_over:1!
> [  146.209232] sctp: sctp_assoc_rwnd_decrease: asoc:ffff88013928e000
> rwnd decreased by 1 to (0, 1, 114221)
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
