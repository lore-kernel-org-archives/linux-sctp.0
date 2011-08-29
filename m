From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Aug 2011 21:51:21 +0000
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
Message-Id: <1314654681.2563.10.camel@edumazet-laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1314650069.git.joe@perches.com>
	 <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
	 <1314654209.2563.7.camel@edumazet-laptop>
In-Reply-To: <1314654209.2563.7.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Joe Perches <joe@perches.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Le lundi 29 août 2011 à 23:43 +0200, Eric Dumazet a écrit :

> Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
> message, is it ?

It currently displays a message without context :

vmap allocation for size XXXXXX failed: use vmalloc=<size> to increase
size.

So we dont know which part of the kernel asked this allocation.

Please dont remove existing error messages after failed vmalloc() calls.



