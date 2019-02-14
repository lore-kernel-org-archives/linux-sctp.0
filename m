From: David Miller <davem@davemloft.net>
Date: Thu, 14 Feb 2019 00:33:09 +0000
Subject: Re: [PATCH net] sctp: call gso_reset_checksum when computing checksum in sctp_gso_segment
Message-Id: <20190213.163309.1448482672803486233.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <5b8187d1eabd52e4db7d3e4506d98c33571c1c83.1549968450.git.lucien.xin@gmail.com>
In-Reply-To: <5b8187d1eabd52e4db7d3e4506d98c33571c1c83.1549968450.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Feb 2019 18:47:30 +0800

> Jianlin reported a panic when running sctp gso over gre over vlan device:
 ...
> It was caused by SKB_GSO_CB(skb)->csum_start not set in sctp_gso_segment.
> sctp_gso_segment() calls skb_segment() with 'feature | NETIF_F_HW_CSUM',
> which causes SKB_GSO_CB(skb)->csum_start not to be set in skb_segment().
> 
> For TCP/UDP, when feature supports HW_CSUM, CHECKSUM_PARTIAL will be set
> and gso_reset_checksum will be called to set SKB_GSO_CB(skb)->csum_start.
> 
> So SCTP should do the same as TCP/UDP, to call gso_reset_checksum() when
> computing checksum in sctp_gso_segment.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
