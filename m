From: David Miller <davem@davemloft.net>
Date: Sat, 20 Aug 2016 00:10:16 +0000
Subject: Re: [PATCH net v2] sctp: linearize early if it's not GSO
Message-Id: <20160819.171016.2080741015571973906.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <c333cd2ab2c828577251c6f75a3cc5e5f3683eb8.1471542789.git.marcelo.leitner@gmail.com>
In-Reply-To: <c333cd2ab2c828577251c6f75a3cc5e5f3683eb8.1471542789.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, daniel@iogearbox.net, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 18 Aug 2016 14:58:35 -0300

> Because otherwise when crc computation is still needed it's way more
> expensive than on a linear buffer to the point that it affects
> performance.
> 
> It's so expensive that netperf test gives a perf output as below:
 ...
> Fixes: 3acb50c18d8d ("sctp: delay as much as possible skb_linearize")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
