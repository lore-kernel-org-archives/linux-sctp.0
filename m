From: David Miller <davem@davemloft.net>
Date: Mon, 11 Dec 2017 19:09:05 +0000
Subject: Re: [PATCH net] sctp: make sure stream nums can match optlen in sctp_setsockopt_reset_streams
Message-Id: <20171211.140905.1841726891785938849.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a6c86b9cb13c2b6e2ed2539c028557a6b1a713ef.1512891651.git.lucien.xin@gmail.com>
In-Reply-To: <a6c86b9cb13c2b6e2ed2539c028557a6b1a713ef.1512891651.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 10 Dec 2017 15:40:51 +0800

> Now in sctp_setsockopt_reset_streams, it only does the check
> optlen < sizeof(*params) for optlen. But it's not enough, as
> params->srs_number_streams should also match optlen.
> 
> If the streams in params->srs_stream_list are less than stream
> nums in params->srs_number_streams, later when dereferencing
> the stream list, it could cause a slab-out-of-bounds crash, as
> reported by syzbot.
> 
> This patch is to fix it by also checking the stream numbers in
> sctp_setsockopt_reset_streams to make sure at least it's not
> greater than the streams in the list.
> 
> Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
