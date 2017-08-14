From: Alexander Potapenko <glider@google.com>
Date: Mon, 14 Aug 2017 18:43:58 +0000
Subject: Re: [PATCH] sctp: fully initialize the IPv6 address in sctp_v6_to_addr()
Message-Id: <CAG_fn=WmgFntPKFRZZ37=fs=S372FLbEhjo6B+h0xJ0CFeXw4w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170718145557.89616-1-glider@google.com> <20170808184740.GC7613@localhost.localdomain>
In-Reply-To: <20170808184740.GC7613@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Vladislav Yasevich <vyasevich@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org

On Tue, Aug 8, 2017 at 8:47 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Tue, Jul 18, 2017 at 04:55:57PM +0200, Alexander Potapenko wrote:
>> KMSAN reported use of uninitialized sctp_addr->v4.sin_addr.s_addr and
>> sctp_addr->v6.sin6_scope_id in sctp_v6_cmp_addr() (see below).
>> Make sure all fields of an IPv6 address are initialized, which
>> guarantees that the IPv4 fields are also initialized.
>
> Hi Alexander,
>
> You missed to email netdev@ and thus Dave is unable to see this patch in
> patchwork. Please resend it, including netdev@.
>
> Thanks,
> Marcelo
Sorry, I've missed your reply.
Resent including netdev@.


-- 
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Straße, 33
80636 München

Geschäftsführer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
