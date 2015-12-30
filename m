From: David Miller <davem@davemloft.net>
Date: Wed, 30 Dec 2015 17:50:46 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <20151230.125046.310343849422003518.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
	<2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
	<1451494651.8255.22.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1451494651.8255.22.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eric.dumazet@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 11:57:31 -0500

> I am against using rhashtable in SCTP (or TCP) at this stage, given the
> number of bugs we have with it.

Come on Eric, we've largely dealt with all of these problems.  I haven't
seen a serious report in a while.
