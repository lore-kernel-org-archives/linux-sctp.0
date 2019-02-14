From: David Miller <davem@davemloft.net>
Date: Thu, 14 Feb 2019 00:34:26 +0000
Subject: Re: [PATCH net] sctp: set stream ext to NULL after freeing it in sctp_stream_outq_migrate
Message-Id: <20190213.163426.603453137542648612.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0cb9e543c21495df48c3723044d6c9f64f238eca.1549968661.git.lucien.xin@gmail.com>
In-Reply-To: <0cb9e543c21495df48c3723044d6c9f64f238eca.1549968661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Feb 2019 18:51:01 +0800

> In sctp_stream_init(), after sctp_stream_outq_migrate() freed the
> surplus streams' ext, but sctp_stream_alloc_out() returns -ENOMEM,
> stream->outcnt will not be set to 'outcnt'.
> 
> With the bigger value on stream->outcnt, when closing the assoc and
> freeing its streams, the ext of those surplus streams will be freed
> again since those stream exts were not set to NULL after freeing in
> sctp_stream_outq_migrate(). Then the invalid-free issue reported by
> syzbot would be triggered.
> 
> We fix it by simply setting them to NULL after freeing.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reported-by: syzbot+58e480e7b28f2d890bfd@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied and queued up for -stable, thanks.
