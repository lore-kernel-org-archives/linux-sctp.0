From: David Miller <davem@davemloft.net>
Date: Sun, 16 Dec 2012 01:16:20 +0000
Subject: Re: [PATCH v2] sctp: Change defaults on cookie hmac selection
Message-Id: <20121215.171620.1992551971037225064.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1355511060-27320-1-git-send-email-nhorman@tuxdriver.com>
	<1355534521-32719-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1355534521-32719-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, torvalds@linux-foundation.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 14 Dec 2012 20:22:01 -0500

> Recently I posted commit 3c68198e75 which made selection of the cookie hmac
> algorithm selectable.  This is all well and good, but Linus noted that it
> changes the default config:
> http://marc.info/?l=linux-netdev&m5536629004808&w=2
> 
> I've modified the sctp Kconfig file to reflect the recommended way of making
> this choice, using the thermal driver example specified, and brought the
> defaults back into line with the way they were prior to my origional patch
> 
> Also, on Linus' suggestion, re-adding ability to select default 'none' hmac
> algorithm, so we don't needlessly bloat the kernel by forcing a non-none
> default.  This also led me to note that we won't honor the default none
> condition properly because of how sctp_net_init is encoded.  Fix that up as
> well.
> 
> Tested by myself (allbeit fairly quickly).  All configuration combinations seems
> to work soundly.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied.
