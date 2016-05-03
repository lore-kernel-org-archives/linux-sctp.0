From: David Miller <davem@davemloft.net>
Date: Tue, 03 May 2016 16:09:15 +0000
Subject: Re: [PATCH 0/2] sctp: Add GSO support
Message-Id: <20160503.120915.2184693151751282220.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1461965035.git.marcelo.leitner@gmail.com>
	<20160502.191614.608026435064266168.davem@davemloft.net>
	<20160503114918.GD5676@localhost.localdomain>
In-Reply-To: <20160503114918.GD5676@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, David.Laight@ACULAB.COM, alexander.duyck@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 3 May 2016 08:49:18 -0300

> So this is just for pure tx path, no forwarding involved.

And if that GSO segment is looped back into the stack via the
loopback interface, the packet classifier mirror action, or
netfilter?

You cannot just GSO things and then not handle such packets
properly on receive.

