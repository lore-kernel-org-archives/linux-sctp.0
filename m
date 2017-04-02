From: David Miller <davem@davemloft.net>
Date: Sun, 02 Apr 2017 03:12:45 +0000
Subject: Re: [PATCH net] sctp: use right in and out stream cnt
Message-Id: <20170401.201245.1804602376522322384.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <046f41fee71d352458eccf900bcef54e24cb8aa8.1490954248.git.lucien.xin@gmail.com>
In-Reply-To: <046f41fee71d352458eccf900bcef54e24cb8aa8.1490954248.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Mar 2017 17:57:28 +0800

> Since sctp reconf was added in sctp, the real cnt of in/out stream
> have not been c.sinit_max_instreams and c.sinit_num_ostreams any
> more.
> 
> This patch is to replace them with stream->in/outcnt.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
