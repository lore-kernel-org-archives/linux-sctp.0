From: David Miller <davem@davemloft.net>
Date: Thu, 15 Jun 2017 16:15:57 +0000
Subject: Re: [PATCH net] sctp: fix spinfo_srtt to be in msecs and not jiffies
Message-Id: <20170615.121557.573870132240215519.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ed45c6f580535de366377e20af519ecff5bdf28d.1497466458.git.marcelo.leitner@gmail.com>
In-Reply-To: <ed45c6f580535de366377e20af519ecff5bdf28d.1497466458.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Jun 2017 16:08:59 -0300

> RFC 6458 (SCTP Sockets API) Section 8.2.2.  Peer Address Information
> (SCTP_GET_PEER_ADDR_INFO) defines that spinfo_srtt is in miliseconds,
> yet we were using it in jiffies.
> 
> Fix it by converting before assigning, similarly to RTO.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> I hope this is not considered UAPI breakage. This is exported via
> getsockopt() calls.

Unfortunately it is UAPI breakage, it is too late to change this now.

SOrry.
