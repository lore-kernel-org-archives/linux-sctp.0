From: David Miller <davem@davemloft.net>
Date: Wed, 25 Dec 2019 00:08:21 +0000
Subject: Re: [PATCH net] sctp: fix err handling of stream initialization
Message-Id: <20191224.160821.1089187984359085837.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
In-Reply-To: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Dec 2019 15:03:44 -0300

> The fix on 951c6db954a1 fixed the issued reported there but introduced
> another. When the allocation fails within sctp_stream_init() it is
> okay/necessary to free the genradix. But it is also called when adding
> new streams, from sctp_send_add_streams() and
> sctp_process_strreset_addstrm_in() and in those situations it cannot
> just free the genradix because by then it is a fully operational
> association.
> 
> The fix here then is to only free the genradix in sctp_stream_init()
> and on those other call sites  move on with what it already had and let
> the subsequent error handling to handle it.
> 
> Tested with the reproducers from this report and the previous one,
> with lksctp-tools and sctp-tests.
> 
> Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
> Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and since I backported the commit mentioned in the Fixes: tag to
-stable, I queued this up for -stable as well.

Thanks.
