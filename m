From: David Miller <davem@davemloft.net>
Date: Mon, 29 Jun 2020 04:46:09 +0000
Subject: Re: [PATCH net-next] sctp: use list_is_singular in sctp_list_single_entry
Message-Id: <20200628.214609.196707051608892793.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1ae93f6e86ea0baf9ffb4068caed46d951076d12.1593336592.git.geliangtang@gmail.com>
In-Reply-To: <1ae93f6e86ea0baf9ffb4068caed46d951076d12.1593336592.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: geliangtang@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Sun, 28 Jun 2020 17:32:25 +0800

> Use list_is_singular() instead of open-coding.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied, thanks.
