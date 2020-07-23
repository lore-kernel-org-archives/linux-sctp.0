From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 23 Jul 2020 08:39:57 +0000
Subject: Re: [MPTCP] [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Message-Id: <1056b902-fd25-1c13-758d-cd4341dd403b@tessares.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
In-Reply-To: <20200723060908.50081-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org, Stefan Schmidt <stefan@datenfreihafen.org>

Hi Christoph,

On 23/07/2020 08:09, Christoph Hellwig wrote:
> Rework the remaining setsockopt code to pass a sockptr_t instead of a
> plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
> outside of architecture specific code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> [ieee802154]
> ---
>   net/mptcp/protocol.c                      | 12 +++----

Thank you for the v2!

For MPTCP-related code:

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
