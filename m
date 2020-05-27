From: David Miller <davem@davemloft.net>
Date: Wed, 27 May 2020 22:08:14 +0000
Subject: Re: [PATCH] sctp: fix typo sctp_ulpevent_nofity_peer_addr_change
Message-Id: <20200527.150814.495554320366388162.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200527095943.271140-1-jonas.falkevik@gmail.com>
In-Reply-To: <20200527095943.271140-1-jonas.falkevik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jonas.falkevik@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Jonas Falkevik <jonas.falkevik@gmail.com>
Date: Wed, 27 May 2020 11:59:43 +0200

> change typo in function name "nofity" to "notify"
> sctp_ulpevent_nofity_peer_addr_change ->
> sctp_ulpevent_notify_peer_addr_change
> 
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>

Applied to net-next, thanks.
