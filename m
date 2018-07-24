From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 24 Jul 2018 17:36:47 +0000
Subject: Re: [PATCH net-next 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180724173647.GA8881@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180426222814.GA10301@localhost.localdomain>
 <b5ab1199-629b-1803-7826-ad74200bb34d@virtuozzo.com>
In-Reply-To: <b5ab1199-629b-1803-7826-ad74200bb34d@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Tue, Jul 24, 2018 at 06:35:35PM +0300, Konstantin Khorenko wrote:
> Hi Marcelo,
> 
> pity to abandon Oleg's attempt to avoid high order allocations and use
> flex_array instead, so i tried to do the performance measurements with
> options you kindly suggested.

Nice, thanks!

...
> As we can see single stream tests do not show any noticeable degradation,
> and SCTP_*_MANY tests spread decreased significantly when -S/-s options are used,
> but still too big to consider the performance test pass or fail.
> 
> Can you please advise anything else to try - to decrease the dispersion rate -

In addition, you can try also using a veth tunnel or reducing lo mtu
down to 1500, and also make use of sctp tests (need to be after the --
) option -m 1452.  These will alleaviate issues with cwnd handling
that happen on loopback due to the big MTU and minimize issues with
rwnd/buffer size too.

Even with -S, -s, -m and the lower MTU, it is usual to see some
fluctuation, but not that much.

> or can we just consider values are fine and i'm reworking the patch according
> to your comment about sctp_stream_in(asoc, sid)/sctp_stream_in_ptr(stream, sid)
> and that's it?

Ok, thanks. It seems so, yes.

  Marcelo
