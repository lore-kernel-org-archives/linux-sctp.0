From: David Miller <davem@davemloft.net>
Date: Fri, 22 May 2020 23:11:33 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-Id: <20200522.161133.75296957266065703.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, kuba@kernel.org, David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 19:46:35 +0200

> based on the review of Davids patch to do something similar I dusted off
> the series I had started a few days ago to move the memdup_user or
> copy_from_user from the inidividual sockopts into sctp_setsockopt,
> which is done with one patch per option, so it might suit Marcelo's
> taste a bit better.  I did not start any work on getsockopt.

I think you and David still need to discuss how to move forward here,
there doesn't seem to be consensus yet.

Thanks.
