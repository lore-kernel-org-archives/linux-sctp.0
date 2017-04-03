From: David Miller <davem@davemloft.net>
Date: Mon, 03 Apr 2017 22:01:30 +0000
Subject: Re: [PATCH net] sctp: check for dst and pathmtu update in sctp_packet_config
Message-Id: <20170403.150130.1161020461020101697.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <7d69e45b3cc8f84658e04ab07288a9fe09254e12.1491038159.git.lucien.xin@gmail.com>
In-Reply-To: <7d69e45b3cc8f84658e04ab07288a9fe09254e12.1491038159.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  1 Apr 2017 17:15:59 +0800

> This patch is to move sctp_transport_dst_check into sctp_packet_config
> from sctp_packet_transmit and add pathmtu check in sctp_packet_config.
> 
> With this fix, sctp can update dst or pathmtu before appending chunks,
> which can void dropping packets in sctp_packet_transmit when dst is
> obsolete or dst's mtu is changed.
> 
> This patch is also to improve some other codes in sctp_packet_config.
> It updates packet max_size with gso_max_size, checks for dst and
> pathmtu, and appends ecne chunk only when packet is empty and asoc
> is not NULL.
> 
> It makes sctp flush work better, as we only need to set up them once
> for one flush schedule. It's also safe, since asoc is NULL only when
> the packet is created by sctp_ootb_pkt_new in which it just gets the
> new dst, no need to do more things for it other than set packet with
> transport's pathmtu.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin.
