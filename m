From: David Miller <davem@davemloft.net>
Date: Mon, 08 Jan 2018 19:19:29 +0000
Subject: Re: [PATCH net v3 0/2] SCTP PMTU discovery fixes
Message-Id: <20180108.141929.1523994358077527375.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515152627.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515152627.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  5 Jan 2018 11:17:16 -0200

> This patchset fixes 2 issues with PMTU discovery that can lead to flood
> of retransmissions.
> The first patch fixes the issue for when PMTUD is disabled by the
> application, while the second fixes it for when its enabled.
> 
> Please consider these to stable.

Applied and queued up for -stable, thank you.
