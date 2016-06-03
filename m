From: David Miller <davem@davemloft.net>
Date: Fri, 03 Jun 2016 23:37:50 +0000
Subject: Re: [PATCH v3 0/7] sctp: Add GSO support
Message-Id: <20160603.193750.2212448136295973014.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1464888549.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1464888549.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, nhorman@tuxdriver.com, David.Laight@ACULAB.COM, vyasevich@gmail.com, alexander.duyck@gmail.com, daniel@iogearbox.net, fw@strlen.de, eric.dumazet@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu,  2 Jun 2016 15:05:37 -0300

> This patchset adds sctp GSO support.
> 
> Performance tests indicates that increases throughput by 10% if using
> bigger chunk sizes, specially if bigger than MTU. For small chunks, it
> doesn't help much if not using heavy firewall rules.
> 
> For small chunks it will probably be of more use once we get something
> like MSG_MORE as David Laight had suggested.
> 
> overall changes:
> v1->v2:
> Added support for receiving GSO frames on SCTP stack, as requested by
> Dave Miller.
> 
> v2->v3:
> Consider sctphdr size in skb_gso_transport_seglen()
> rebased due to 5c7cdf339af5 ("gso: Remove arbitrary checks for
> unsupported GSO")

Series applied, thanks Marcelo.
