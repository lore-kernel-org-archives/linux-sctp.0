From: Eric Dumazet <edumazet@google.com>
Date: Thu, 06 Sep 2018 19:33:58 +0000
Subject: Re: [PATCH] net/sock: move memory_allocated over to percpu_counter variables
Message-Id: <CANn89i+akEWrHELBkZJQOxok-ZfYy+FNPUWdPEfB6c4YyWLqJA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180906192034.8467-1-olof@lixom.net>
In-Reply-To: <20180906192034.8467-1-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olof Johansson <olof@lixom.net>
Cc: David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vladislav Yasevich <vyasevich@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, linux-decnet-user@lists.sourceforge.net, kernel-team <kernel-team@fb.com>

On Thu, Sep 6, 2018 at 12:21 PM Olof Johansson <olof@lixom.net> wrote:
>
> Today these are all global shared variables per protocol, and in
> particular tcp_memory_allocated can get hot on a system with
> large number of CPUs and a substantial number of connections.
>
> Moving it over to a per-cpu variable makes it significantly cheaper,
> and the added overhead when summing up the percpu copies is still smaller
> than the cost of having a hot cacheline bouncing around.

I am curious. We never noticed contention on this variable, at least for TCP.

Please share some numbers with us.
