From: Christoph Hellwig <hch@lst.de>
Date: Mon, 20 Jul 2020 17:43:38 +0000
Subject: Re: get rid of the address_space override in setsockopt
Message-Id: <20200720174338.GB21785@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200720124737.118617-1-hch@lst.de> <20200720163836.GB1292162@gmail.com>
In-Reply-To: <20200720163836.GB1292162@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, mptcp@lists.01.org, lvs-devel@vger.kernel.org, rds-devel@oss.oracle.com, linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org

On Mon, Jul 20, 2020 at 09:38:36AM -0700, Eric Biggers wrote:
> Please mention what git tree your patchset applies to.

net-next/master
