From: David Miller <davem@davemloft.net>
Date: Fri, 24 Jul 2020 23:49:52 +0000
Subject: Re: [PATCH v2 net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Message-Id: <20200724.164952.472536620054081569.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200724064855.132552-1-hch@lst.de>
In-Reply-To: <20200724064855.132552-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hch@lst.de
Cc: marcelo.leitner@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 24 Jul 2020 08:48:55 +0200

> This sockopt accepts two kinds of parameters, using struct
> sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
> notice an implicit cast from the smaller (latter) struct to the bigger
> one (former) when copying the data from the user space, which now leads
> to an attempt to write beyond the buffer (because it assumes the storing
> buffer is bigger than the parameter itself).
> 
> Fix it by allocating a sctp_sack_info on stack and filling it out based
> on the small struct for the compat case.
> 
> Changelog stole from an earlier patch from Marcelo Ricardo Leitner.
> 
> Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
> Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied, thanks.
