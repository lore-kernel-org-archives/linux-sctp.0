From: 'Christoph Hellwig' <hch@lst.de>
Date: Thu, 23 Jul 2020 11:44:58 +0000
Subject: Re: [PATCH 13/26] bpfilter: switch bpfilter_ip_set_sockopt to sockptr_t
Message-Id: <20200723114458.GA31363@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-14-hch@lst.de> <621e193e4af74d8198ed87d6a9ce8260@AcuMS.aculab.com>
In-Reply-To: <621e193e4af74d8198ed87d6a9ce8260@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Christoph Hellwig' <hch@lst.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>, "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>, "bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>, "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>, "dccp@vger.kernel.org" <dccp@vger.kernel.org>, "linux-decnet-user@lists.sourceforge.net" <linux-decnet-user@lists.sourceforge.net>, "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "mptcp@lists.01.org" <mptcp@lists.01.org>, "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>, "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>

On Thu, Jul 23, 2020 at 11:16:16AM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 23 July 2020 07:09
> > 
> > This is mostly to prepare for cleaning up the callers, as bpfilter by
> > design can't handle kernel pointers.
> 
> You've failed to fix the sense of the above...

The sense still is correct.
