From: David Miller <davem@davemloft.net>
Date: Tue, 05 Apr 2016 19:41:22 +0000
Subject: Re: [PATCH v2] sctp: flush if we can't fit another DATA chunk
Message-Id: <20160405.154122.24544897927296613.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a9e4f862b5f7a43eccca5966684d172e4de57b13.1459475764.git.marcelo.leitner@gmail.com>
In-Reply-To: <a9e4f862b5f7a43eccca5966684d172e4de57b13.1459475764.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  1 Apr 2016 14:05:48 -0300

> There is no point on delaying the packet if we can't fit a single byte
> of data on it anymore. So lets just reduce the threshold by the amount
> that a data chunk with 4 bytes (rounding) would use.
> 
> v2: based on the right tree
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thanks.
