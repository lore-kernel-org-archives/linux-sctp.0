From: David Miller <davem@davemloft.net>
Date: Wed, 10 Jan 2018 19:53:41 +0000
Subject: Re: [PATCH net 0/3] Some sockopt optlen fixes
Message-Id: <20180110.145341.1475369360355738032.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515436112.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515436112.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, haliu@redhat.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon,  8 Jan 2018 19:02:26 -0200

> Hangbin Liu reported that some SCTP sockopt are allowing the user to get
> the kernel to allocate really large buffers by not having a ceiling on
> optlen.
> 
> This patchset address this issue (in patch 2), replace an GFP_ATOMIC
> that isn't needed and avoid calculating the option size multiple times
> in some setsockopt.

Series applied, thank you.
