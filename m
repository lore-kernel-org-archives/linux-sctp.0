From: David Miller <davem@davemloft.net>
Date: Wed, 30 Dec 2015 17:52:04 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <20151230.125204.1385006803109278855.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
	<1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eric.dumazet@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 12:19:39 -0500

> Switching SCTP to rhashtable at this moment is premature, it is
> still moving fast.

I completely, and totally, disagree.

rhashtable actually _needs_ a strong active user like one of the
protocol socket hashes.

It's a step backwards to keep rhashtable in the shadows by only
allowing certain subsystems to convert to it.  That's really
incredibly stupid if you ask me.
