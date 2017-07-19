From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 19 Jul 2017 00:58:56 +0000
Subject: Re: [PATCH] sctp: fully initialize the IPv6 address in sctp_v6_to_addr()
Message-Id: <CADvbK_fD5H_FmCQX=p5eyN2261BerqR7=1_-LqdehS8o_M9Agg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170718145557.89616-1-glider@google.com> <CAG_fn=WPJb7k+nErwyvwvY54etVvvGmrDDnpvGqVkDMv5foJmA@mail.gmail.com>
In-Reply-To: <CAG_fn=WPJb7k+nErwyvwvY54etVvvGmrDDnpvGqVkDMv5foJmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Vladislav Yasevich <vyasevich@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org

On Wed, Jul 19, 2017 at 3:02 AM, Alexander Potapenko <glider@google.com> wrote:
> On Tue, Jul 18, 2017 at 4:55 PM, Alexander Potapenko <glider@google.com> wrote:
>> KMSAN reported use of uninitialized sctp_addr->v4.sin_addr.s_addr and
>> sctp_addr->v6.sin6_scope_id in sctp_v6_cmp_addr() (see below).
>> Make sure all fields of an IPv6 address are initialized, which
>> guarantees that the IPv4 fields are also initialized.
> I'm assuming here that the IPv4 address is known to overlap with the
> IPv6 one and doesn't need separate initialization.
>
Ok, addr->v6.sin6_scope_id = 0 will fix the call trace you posted here.

addr->v6.sin6_flowinfo = 0 is to fix uninitialized
sctp_addr->v4.sin_addr.s_addr,
I couldn't see how this happens, can you also post the call trace for
v4.sin_addr.s_addr ?

Thanks
