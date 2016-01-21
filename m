From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 21 Jan 2016 17:58:13 +0000
Subject: Re: [PATCH net 0/3] fix the transport dead race check by using atomic_add_unless on refcnt
Message-Id: <CADvbK_dzuMno_heOXfHF0xU78RDzk5XcVx_-N+UAYqo3fx_P4g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1453398443.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1453398443.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem <davem@davemloft.net>

On Fri, Jan 22, 2016 at 1:49 AM, Xin Long <lucien.xin@gmail.com> wrote:

Fixing a bug that was introduce in rhashtable patchset and a follow-up
cleanup that is now possible

> Xin Long (3):
>   sctp: fix the transport dead race check by using atomic_add_unless on
>     refcnt
>   sctp: hold transport before we access t->asoc in sctp proc
>   sctp: remove the dead field of sctp_transport
>
>  include/net/sctp/structs.h |  5 ++---
>  net/sctp/input.c           | 17 +++++++++++------
>  net/sctp/proc.c            | 12 ++++++++----
>  net/sctp/sm_sideeffect.c   | 12 ------------
>  net/sctp/transport.c       |  8 +++-----
>  5 files changed, 24 insertions(+), 30 deletions(-)
>
> --
> 2.1.0
>
