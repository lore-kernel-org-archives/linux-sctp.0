From: David Miller <davem@davemloft.net>
Date: Mon, 05 Feb 2018 14:58:51 +0000
Subject: Re: [PATCH net v2] sctp: fix dst refcnt leak in sctp_v4_get_dst
Message-Id: <20180205.095851.568720869636736573.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180205133311.2620-1-tommi.t.rantala@nokia.com>
In-Reply-To: <20180205133311.2620-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tommi.t.rantala@nokia.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, alexey.kodanev@oracle.com, marcelo.leitner@gmail.com

From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Mon,  5 Feb 2018 15:33:11 +0200

> Fixes: 410f03831 ("sctp: add routing output fallback")
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>

I would add another Fixes tag mentioning commit:

	0ca50d12fe46cdf3c0dc9ec5ca98607a52afdc62
	("sctp: fix src address selection if using secondary addresses")

because it is another origin for this dst leak.

Otherwise your patch looks great, please respin it with a second
Fixes: tag added for the above commit and I'll apply this.

Thanks!
