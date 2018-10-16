From: David Miller <davem@davemloft.net>
Date: Tue, 16 Oct 2018 05:55:43 +0000
Subject: Re: [PATCH net] sctp: use the pmtu from the icmp packet to update transport pathmtu
Message-Id: <20181015.225543.331760686954565853.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <de1ad572beb97767e535b7cf60da7b1de6cbfd4f.1539604709.git.lucien.xin@gmail.com>
In-Reply-To: <de1ad572beb97767e535b7cf60da7b1de6cbfd4f.1539604709.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Oct 2018 19:58:29 +0800

> Other than asoc pmtu sync from all transports, sctp_assoc_sync_pmtu
> is also processing transport pmtu_pending by icmp packets. But it's
> meaningless to use sctp_dst_mtu(t->dst) as new pmtu for a transport.
> 
> The right pmtu value should come from the icmp packet, and it would
> be saved into transport->mtu_info in this patch and used later when
> the pmtu sync happens in sctp_sendmsg_to_asoc or sctp_packet_config.
> 
> Besides, without this patch, as pmtu can only be updated correctly
> when receiving a icmp packet and no place is holding sock lock, it
> will take long time if the sock is busy with sending packets.
> 
> Note that it doesn't process transport->mtu_info in .release_cb(),
> as there is no enough information for pmtu update, like for which
> asoc or transport. It is not worth traversing all asocs to check
> pmtu_pending. So unlike tcp, sctp does this in tx path, for which
> mtu_info needs to be atomic_t.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
