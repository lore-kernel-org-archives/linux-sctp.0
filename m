From: David Miller <davem@davemloft.net>
Date: Wed, 24 May 2017 19:22:57 +0000
Subject: Re: [PATCH net 0/2] sctp: a bunch of fixes for processing dupcookie
Message-Id: <20170524.152257.2090892064722032542.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1495517205.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1495517205.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 May 2017 13:28:53 +0800

> After introducing transport hashtable and per stream info into sctp,
> some regressions were caused when processing dupcookie, this patchset
> is to fix them.

Series applied, thanks.
