From: David Miller <davem@davemloft.net>
Date: Fri, 19 May 2017 23:22:56 +0000
Subject: Re: [PATCH net-next v3 0/7] fix CRC32c in the forwarding path
Message-Id: <20170519.192256.208527477868929921.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1495112301.git.dcaratti@redhat.com>
In-Reply-To: <cover.1495112301.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dcaratti@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, alexander.duyck@gmail.com, tom@herbertland.com, David.Laight@ACULAB.COM, marcelo.leitner@gmail.com

From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 18 May 2017 15:44:36 +0200

> Current kernel allows offloading CRC32c computation when SCTP packets
> are generated, setting skb->ip_summed to CHECKSUM_PARTIAL, if the
> underlying device features have NETIF_F_SCTP_CRC set. However, after these
> packets are forwarded, they may land on a device where CRC32c offloading is
> not available: as a consequence, transmission is done with wrong CRC32c.
> It's not possible to use sctp_compte_cksum() in the forwarding path
> and in most drivers, because it needs symbols exported by libcrc32c module.
> 
> Patch 1 and 2 of this series try to solve this problem, introducing a new
> helper function, namely skb_crc32c_csum_help(), that can be used to resolve
> CHECKSUM_PARTIAL when crc32c is needed instead of Internet Checksum.
> 
> Currently, we need to parse the packet headers to understand what algorithm
> is needed to resolve CHECKSUM_PARTIAL. We can speedup things by storing
> this information in the skb metadata, and use it to call an appropriate
> helper (skb_checksum_help or skb_crc32c_csum_help), or leave the packet
> unmodified when the NIC is able to offload the checksum computation.
> 
> Patch 3 deprecates skb->csum_bad to free one bit in skb metadata; patch 4
> introduces skb->csum_not_inet, providing skb with an indication on the
> algorithm needed to resolve CHECKSUM_PARTIAL.
> Patch 5 and 6 fix the kernel forwarding path and openvswitch datapath,
> where skb_checksum_help was unconditionally called to resolve CHECKSUM_PARTIAL,
> thus generating wrong CRC32c in forwarded SCTP packets.
> Finally, patch 7 updates documentation to provide a better description of
> possible values of skb->ip_summed.
> 
> Some further work is still possible:
> * drivers that parse the packet header to correctly resolve CHECKSUM_PARTIAL
> (e.g. ixgbe_tx_csum()) can benefit from testing skb->csum_not_inet to avoid
> calling ip_hdr(skb)->protocol or ixgbe_ipv6_csum_is_sctp(skb).
> 
> * drivers that call skb_checksum_help() to resolve CHECKSUM_PARTIAL can
> call skb_csum_hwoffload_help to avoid corrupting SCTP packets.
...

Ok, series applied.

I do kinda think that the crc32 module handling still isn't very nice.
If this is a core checksumming algorithm we support in the networking
stack, than seriously just like the standard internet checksum we should
statically build crc32 into the kernel image and not have this weird
situation where the code might not be there when we need it.

Thanks.
