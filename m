From: David Miller <davem@davemloft.net>
Date: Mon, 09 Jan 2017 15:53:01 +0000
Subject: Re: [PATCHv2 net-next 0/5] sctp: add support for generating stream reconf chunks
Message-Id: <20170109.105301.469495957021068521.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1483781759.git.lucien.xin@gmail.com>
        <20170109124325.GB20973@hmswarspite.think-freely.org>
In-Reply-To: <20170109124325.GB20973@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 9 Jan 2017 07:43:25 -0500

> These all look reasonably good, but it seems before we accept them,
> there should be an additional patch that actually makes use of the code.
> I presume that is forthcomming?

This all comes from my asking that the original huge set of patches be
split up.

People always just rush this kind of work and never think about laying
out the resubmission properly.

One should always only submit new interfaces along with an actual use
because only with a use can we properly review whether the new
interface is good or not.
