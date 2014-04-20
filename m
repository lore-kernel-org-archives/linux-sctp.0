From: David Miller <davem@davemloft.net>
Date: Sun, 20 Apr 2014 22:20:51 +0000
Subject: Re: [PATCH] sctp: add support for busy polling to sctp protocol
Message-Id: <20140420.182051.274562297709657182.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397762811-2989-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1397762811-2989-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, dborkman@redhat.com, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 17 Apr 2014 15:26:51 -0400

> The busy polling socket option adds support for sockets to busy wait on data
> arriving on the napi queue from which they have most recently received a frame.
> Currently only tcp and udp support this feature, but theres no reason sctp can't
> do so as well.  Add it in so appliations can take advantage of it
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied.
