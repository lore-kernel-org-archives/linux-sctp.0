From: David Miller <davem@davemloft.net>
Date: Thu, 25 Jun 2020 23:12:06 +0000
Subject: Re: [PATCH net] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Message-Id: <20200625.161206.1619464748667177222.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200623160417.12418-1-minyard@acm.org>
        <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
In-Reply-To: <991916791cdcc37456ccb061779d485063b97129.1593030427.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, Michael.Tuexen@lurchi.franken.de, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cminyard@mvista.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 24 Jun 2020 17:34:18 -0300

> If a socket is set ipv6only, it will still send IPv4 addresses in the
> INIT and INIT_ACK packets. This potentially misleads the peer into using
> them, which then would cause association termination.
> 
> The fix is to not add IPv4 addresses to ipv6only sockets.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Corey Minyard <cminyard@mvista.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thank you.
