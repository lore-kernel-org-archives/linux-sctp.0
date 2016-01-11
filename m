From: David Miller <davem@davemloft.net>
Date: Mon, 11 Jan 2016 21:35:43 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <20160111.163543.869963270978192882.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160111160039.GA6061@mrl.redhat.com>
	<5693E451.2000306@gmail.com>
	<20160111180927.GG6061@mrl.redhat.com>
In-Reply-To: <20160111180927.GG6061@mrl.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mleitner@redhat.com
Cc: vyasevich@gmail.com, herbert@gondor.apana.org.au, lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevic@redhat.com, daniel@iogearbox.net

From: mleitner@redhat.com
Date: Mon, 11 Jan 2016 16:09:27 -0200

> There is still the other part of this thread to be worked on (re
> ->dead), maybe that will justify extra stuff in here but I really
> wouldn't like to add extra structures and locks on this just to satisfy
> an unreasonable scenario like this. This hash is very busy, the lean it
> is, the better.

It is never "unreasonable" if it is necessary to fix a real bug, which
this is.
