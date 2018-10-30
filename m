From: David Miller <davem@davemloft.net>
Date: Tue, 30 Oct 2018 03:51:36 +0000
Subject: Re: [PATCH net] sctp: clear the transport of some out_chunk_list chunks in sctp_assoc_rm_peer
Message-Id: <20181029.205136.1748827502784008798.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f3d3a876b124a96a8e44913abfa552a278cd758c.1540825829.git.lucien.xin@gmail.com>
In-Reply-To: <f3d3a876b124a96a8e44913abfa552a278cd758c.1540825829.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Oct 2018 23:10:29 +0800

> If a transport is removed by asconf but there still are some chunks with
> this transport queuing on out_chunk_list, later an use-after-free issue
> will be caused when accessing this transport from these chunks in
> sctp_outq_flush().
> 
> This is an old bug, we fix it by clearing the transport of these chunks
> in out_chunk_list when removing a transport in sctp_assoc_rm_peer().
> 
> Reported-by: syzbot+56a40ceee5fb35932f4d@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
