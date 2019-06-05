From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 05 Jun 2019 21:50:26 +0000
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-Id: <20190605215026.GB3778@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1559768607-17439-1-git-send-email-info@metux.net>
In-Reply-To: <1559768607-17439-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:03:27PM +0200, Enrico Weigelt, metux IT consult wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Hi,

This patch overlaps with
Jun 05 Kefeng Wang     (4.4K) [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)

  Marcelo
