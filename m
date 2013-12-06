From: "David Laight" <David.Laight@ACULAB.COM>
Date: Fri, 06 Dec 2013 15:46:31 +0000
Subject: RE: [PATCH] sctp: properly latch and use autoclose value from sock to association
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B746B@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52A0A300.3010409@gmail.com> <1386343755-14130-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1386343755-14130-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Cc: Wang Weidong <wangweidong1@huawei.com>, David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org

> From: Neil Horman
> Currently, sctp associations latch a sockets autoclose value to an association
> at association init time, subject to capping constraints from the max_autoclose
> sysctl value.  This leads to an odd situation where an application may set a
> socket level autoclose timeout, but sliently sctp will limit the autoclose
> timeout to something less than that.
> 
> Fix this by modifying the autoclose setsockopt function to check the limit, cap
> it and warn the user via syslog that the timeout is capped.  This will allow
> getsockopt to return valid autoclose timeout values that reflect what subsequent
> associations actually use.
...
> +	if (sp->autoclose > net->sctp.max_autoclose) {
> +		pr_warn("Capping autoclose value %d to defined maximum of %lu\n",
> +			sp->autoclose, net->sctp.max_autoclose);
> +		sp->autoclose = net->sctp.max_autoclose;
> +	}

Is it really reasonable to allow a user to spam syslog this way?

	David



