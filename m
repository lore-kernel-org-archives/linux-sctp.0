From: David Miller <davem@davemloft.net>
Date: Thu, 03 Dec 2015 04:40:01 +0000
Subject: Re: [PATCH] sctp: convert sack_needed and sack_generation to bits
Message-Id: <20151202.234001.1035831453332214345.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f3803545e5d34adfe83cff5adf01317c56288d59.1448892562.git.marcelo.leitner@gmail.com>
In-Reply-To: <f3803545e5d34adfe83cff5adf01317c56288d59.1448892562.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, lucien.xin@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 30 Nov 2015 12:17:06 -0200

> They don't need to be any bigger than that and with this we start a new
> bitfield for tracking association runtime stuff, like zero window
> situation.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
