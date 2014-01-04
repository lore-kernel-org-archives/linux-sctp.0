From: David Miller <davem@davemloft.net>
Date: Sat, 04 Jan 2014 00:37:17 +0000
Subject: Re: [PATCH] sctp: Add process name and pid to deprecation warnings
Message-Id: <20140103.193717.760371809302807301.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1388685267-18319-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1388685267-18319-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, bhutchings@solarflare.com, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu,  2 Jan 2014 12:54:27 -0500

> Recently I updated the sctp socket option deprecation warnings to be both a bit
> more clear and ratelimited to prevent user processes from spamming the log file.
> Ben Hutchings suggested that I add the process name and pid to these warnings so
> that users can tell who is responsible for using the deprecated apis.  This
> patch accomplishes that.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

This is a net positive improvement, so I'm applying this.

Thanks Neil.
