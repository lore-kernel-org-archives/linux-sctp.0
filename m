From: David Miller <davem@davemloft.net>
Date: Tue, 01 Mar 2016 22:36:13 +0000
Subject: Re: [PATCH net] sctp: sctp_remaddr_seq_show use the wrong variable to dump transport info
Message-Id: <20160301.173613.295919796621489412.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <08f9ec3d48c3fffd7224e6eb0c129ed113d23fbd.1456626791.git.lucien.xin@gmail.com>
In-Reply-To: <08f9ec3d48c3fffd7224e6eb0c129ed113d23fbd.1456626791.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 28 Feb 2016 10:33:11 +0800

> Now in sctp_remaddr_seq_show(), we use variable *tsp to get the param *v.
> but *tsp is also used to traversal transport_addr_list, which will cover
> the previous value, and make sctp_transport_put work on the wrong transport.
> 
> So fix it by adding a new variable to get the param *v.
> 
> Fixes: fba4c330c5b9 ("sctp: hold transport before we access t->asoc in sctp proc")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
