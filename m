From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 08 Aug 2017 18:47:40 +0000
Subject: Re: [PATCH] sctp: fully initialize the IPv6 address in sctp_v6_to_addr()
Message-Id: <20170808184740.GC7613@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170718145557.89616-1-glider@google.com>
In-Reply-To: <20170718145557.89616-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>
Cc: dvyukov@google.com, kcc@google.com, edumazet@google.com, davem@davemloft.net, vyasevich@gmail.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Jul 18, 2017 at 04:55:57PM +0200, Alexander Potapenko wrote:
> KMSAN reported use of uninitialized sctp_addr->v4.sin_addr.s_addr and
> sctp_addr->v6.sin6_scope_id in sctp_v6_cmp_addr() (see below).
> Make sure all fields of an IPv6 address are initialized, which
> guarantees that the IPv4 fields are also initialized.

Hi Alexander,

You missed to email netdev@ and thus Dave is unable to see this patch in
patchwork. Please resend it, including netdev@.

Thanks,
Marcelo
