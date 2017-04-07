From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 07 Apr 2017 14:16:03 +0000
Subject: [PATCH RFC net-next v3 0/7] improve CRC32c in the forwarding path
Message-Id: <cover.1491562390.git.dcaratti@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CALx6S34cSH+z+humkp5s7UHAqnafHHB-GTqobHyb-SfKNe+MiA@mail.gmail.com>
In-Reply-To: <CALx6S34cSH+z+humkp5s7UHAqnafHHB-GTqobHyb-SfKNe+MiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Herbert <tom@herbertland.com>, Alexander Duyck <alexander.duyck@gmail.com>, David Laight <David.Laight@aculab.com>, "David S . Miller" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

On Tue, 2017-03-07 at 10:06 -0800, Alexander Duyck wrote:
> You might even take this one step
> further.  You could convert crc32_csum into a 1 bit enum for now.
> Basically you would use 0 for 1's compliement csum, and 1 to represent
> a crc32c csum.  Then if we end up having to add another bit for
> something like FCoE in the future it would give us 4 possible checksum
> types instead of just giving us 1 with a bit mask.


On Sat, 2017-03-18 at 15:35 -0700, Tom Herbert wrote:
> Just create a non_ip_csum bit in skbuff.
> csum_bad can replaced with this I think. If the bit is set then more
> work can be done to differentiate between alternative checksums.

hello Alexander and Tom,

I refreshed the series including your suggestions.
Some followups are still possible:

* drivers that parse the packet header to correctly resolve CHECKSUM_PARTIAL
(e.g. ixgbe_tx_csum()) can benefit from skb->csum_algo savng some CPU cycles
(e.g. avoiding calling ip_hdr(skb)->protocol or ixgbe_ipv6_csum_is_sctp(skb)).

* drivers that call skb_checksum_help() to resolve CHECKSUM_PARTIAL can
call skb_crc32c_csum_help (or skb_csum_hwoffload_help(skb, 0)) to avoid
wrong CRC on SCTP packets.

thank you in advance for looking at this!
regards,
--
davide

v3:
 * review documentation
 * include a fix for corrupted SCTP packets in openvswitch datapath
 * skb->crc32c_csum renamed in skb->csum_algo and converted to enum
 * deprecate skb->csum_bad to free one bit in struct sk_buff
 * use 'CRC32c csum' terminology everywhere

