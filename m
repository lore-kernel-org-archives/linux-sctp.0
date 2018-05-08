From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 08 May 2018 18:57:32 +0000
Subject: Re: KASAN: use-after-free Read in sctp_do_sm
Message-Id: <20180508185732.GP5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <000000000000c10690056bb22ccd@google.com>
 <CADvbK_d8O7b9OCfCKGhaaQuBafi6rgkKEQh9Bk7pvZKX3KDKCg@mail.gmail.com>
In-Reply-To: <CADvbK_d8O7b9OCfCKGhaaQuBafi6rgkKEQh9Bk7pvZKX3KDKCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: syzbot <syzbot+141d898c5f24489db4aa@syzkaller.appspotmail.com>, davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vlad Yasevich <vyasevich@gmail.com>

On Wed, May 09, 2018 at 01:41:03AM +0800, Xin Long wrote:
...
> >  sctp_chunk_destroy net/sctp/sm_make_chunk.c:1481 [inline]
> >  sctp_chunk_put+0x321/0x440 net/sctp/sm_make_chunk.c:1504
> >  sctp_ulpevent_make_rcvmsg+0x955/0xd40 net/sctp/ulpevent.c:718
> There's no reason to put the chunk in sctp_ulpevent_make_rcvmsg's
> fail_mark err path before holding this chunk later there.
>
> We should just remove it.

Oups. Agreed.

  Marcelo
