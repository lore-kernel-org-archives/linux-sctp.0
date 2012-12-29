From: David Miller <davem@davemloft.net>
Date: Sat, 29 Dec 2012 04:33:03 +0000
Subject: Re: [PATCH] sctp: make sctp_addr_wq_timeout_handler static
Message-Id: <20121228.203303.466763210063851049.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20121228201855.4275db64@nehalam.linuxnetplumber.net>
In-Reply-To: <20121228201855.4275db64@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shemminger@vyatta.com
Cc: vyasevich@gmail.com, sri@us.ibm.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 28 Dec 2012 20:18:55 -0800

> Fix sparse warning about local function that should be static.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
