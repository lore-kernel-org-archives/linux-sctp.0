From: David Miller <davem@davemloft.net>
Date: Wed, 03 Jan 2018 16:30:24 +0000
Subject: Re: [PATCH net] sctp: fix error path in sctp_stream_init
Message-Id: <20180103.113024.1172104926214846601.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <74b65f56d6912704f3ef79a46242cc2ca567e4e3.1514928664.git.marcelo.leitner@gmail.com>
In-Reply-To: <74b65f56d6912704f3ef79a46242cc2ca567e4e3.1514928664.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue,  2 Jan 2018 19:44:37 -0200

> syzbot noticed a NULL pointer dereference panic in sctp_stream_free()
> which was caused by an incomplete error handling in sctp_stream_init().
> By not clearing stream->outcnt, it made a for() in sctp_stream_free()
> think that it had elements to free, but not, leading to the panic.
> 
> As suggested by Xin Long, this patch also simplifies the error path by
> moving it to the only if() that uses it.
> 
> See-also: https://www.spinics.net/lists/netdev/msg473756.html
> See-also: https://www.spinics.net/lists/netdev/msg465024.html
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thank you.
