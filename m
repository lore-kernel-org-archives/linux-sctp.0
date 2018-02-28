From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 28 Feb 2018 20:10:18 +0000
Subject: Re: [PATCH net-next 0/6] tcp: remove non GSO code
Message-Id: <20180228201018.GA3887@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180219195652.242663-1-edumazet@google.com>
 <20180221.143748.516809068075257257.davem@davemloft.net>
In-Reply-To: <20180221.143748.516809068075257257.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: edumazet@google.com, netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com, soheil@google.com, oleksandr@natalenko.name, eric.dumazet@gmail.com, linux-sctp@vger.kernel.org

On Wed, Feb 21, 2018 at 02:37:48PM -0500, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 19 Feb 2018 11:56:46 -0800
> 
> > Switching TCP to GSO mode, relying on core networking layers
> > to perform eventual adaptation for dumb devices was overdue.
> > 
> > 1) Most TCP developments are done with TSO in mind.
> > 2) Less high-resolution timers needs to be armed for TCP-pacing
> > 3) GSO can benefit of xmit_more hint
> > 4) Receiver GRO is more effective (as if TSO was used for real on sender)
> >    -> less ACK packets and overhead.
> > 5) Write queues have less overhead (one skb holds about 64KB of payload)
> > 6) SACK coalescing just works. (no payload in skb->head)
> > 7) rtx rb-tree contains less packets, SACK is cheaper.
> > 8) Removal of legacy code. Less maintenance hassles.
> > 
> > Note that I have left the sendpage/zerocopy paths, but they probably can
> > benefit from the same strategy.
> > 
> > Thanks to Oleksandr Natalenko for reporting a performance issue for BBR/fq_codel,
> > which was the main reason I worked on this patch series.
> 
> Series applied, thanks Eric.
> 
> SCTP might want to do something similar, and if so we can get rid
> of sk_can_gso() too.

Cc'ing linux-sctp and adding to the ToDo here, although it may be too
soon for SCTP. GSO support was added just a few months ago and
considering that it is not that much widely used as TCP, I fear we may
have some issues that didn't show up yet.

  Marcelo
