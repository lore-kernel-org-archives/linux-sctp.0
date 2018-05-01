From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 01 May 2018 23:28:23 +0000
Subject: Re: [PATCH net-next 0/2] sctp: unify sctp_make_op_error_fixed and sctp_make_op_error_space
Message-Id: <20180501232822.GB5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525017179.git.marcelo.leitner@gmail.com>
 <20180501.121353.1918662858023133319.davem@davemloft.net>
In-Reply-To: <20180501.121353.1918662858023133319.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com

On Tue, May 01, 2018 at 12:13:53PM -0400, David Miller wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Sun, 29 Apr 2018 12:56:30 -0300
>
> > These two variants are very close to each other and can be merged
> > to avoid code duplication. That's what this patchset does.
> >
> > First, we allow sctp_init_cause to return errors, which then allow us to
> > add sctp_make_op_error_limited that handles both situations.
>
> Series applied.

Thanks.

>
> But generally, there are a lot of smtp_init_cause() call sites with non-zero
> payload length that should start checking the return value now.

They are safe as is, because they follow the pattern:
- sctp_make_abort(...., somesize)
- sctp_init_cause(size)
where size is considered in somesize, so sctp_init_cause cannot fail
in there.

This new usage in sctp_make_op_error_limited is the only one where it
allocates a buffer without knowing how much data will actually be
pushed into it.

  Marcelo
