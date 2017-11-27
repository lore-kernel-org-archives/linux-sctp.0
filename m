From: David Miller <davem@davemloft.net>
Date: Mon, 27 Nov 2017 19:52:11 +0000
Subject: Re: [PATCH net 0/3] a couple of fixes for chunks abandoned in prsctp
Message-Id: <20171128.045211.1137933421042699285.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511615658.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1511615658.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 21:18:33 +0800

> Now when abandoning chunks in prsctp, it doesn't consider for frags in
> one msg, which would cause peer can never receive the whole frags for
> one msg to get them reassembled, these pieces of this msg will stay in
> the reasm queue forever and block the following chunks' receiving.
> 
> This patchset is to fix them in patch 2 and 3, and also fix another
> issue for prsctp in patch 1.

Series applied, thank you.
