From: David Miller <davem@davemloft.net>
Date: Sun, 01 Jul 2012 00:38:48 +0000
Subject: Re: [PATCH v5] sctp: be more restrictive in transport selection on bundled sacks
Message-Id: <20120630.173848.305653960513565624.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1341000929-22933-1-git-send-email-nhorman@tuxdriver.com>
	<20120629.163408.1111786778802302299.davem@davemloft.net>
	<20120630122647.GA22647@neilslaptop.think-freely.org>
In-Reply-To: <20120630122647.GA22647@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 30 Jun 2012 08:26:47 -0400

> This is wrong.  Its a counter that increments every time we call sctp_make_sack,
> so that we can create a unique generation identifier for use in tagging which
> transports move ctsn in a given generation.  It saves us from having to iterate
> over a list every time we send a sack. 

Sorry, I missed the counter bump.
