From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 07 Sep 2018 03:32:57 +0000
Subject: Re: [PATCH] net/sock: move memory_allocated over to percpu_counter variables
Message-Id: <20180907033257.2nlgiqm2t4jiwhzc@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180906192034.8467-1-olof@lixom.net>
 <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
In-Reply-To: <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet@google.com>
Cc: Olof Johansson <olof@lixom.net>, David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, linux-decnet-user@lists.sourceforge.net, kernel-team <kernel-team@fb.com>

On Thu, Sep 06, 2018 at 12:33:58PM -0700, Eric Dumazet wrote:
> On Thu, Sep 6, 2018 at 12:21 PM Olof Johansson <olof@lixom.net> wrote:
> >
> > Today these are all global shared variables per protocol, and in
> > particular tcp_memory_allocated can get hot on a system with
> > large number of CPUs and a substantial number of connections.
> >
> > Moving it over to a per-cpu variable makes it significantly cheaper,
> > and the added overhead when summing up the percpu copies is still smaller
> > than the cost of having a hot cacheline bouncing around.
> 
> I am curious. We never noticed contention on this variable, at least for TCP.

Yes these variables are heavily amortised so I'm surprised that
they would cause much contention.

> Please share some numbers with us.

Indeed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
