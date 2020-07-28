From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 28 Jul 2020 08:07:11 +0000
Subject: RE: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
Message-Id: <908ed73081cc42d58a5b01e0c97dbe47@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-13-hch@lst.de> <20200727150310.GA1632472@zx2c4.com>
 <20200727150601.GA3447@lst.de>
 <CAHmME9ric=chLJayn7Erve7WBa+qCKn-+Gjri=zqydoY6623aA@mail.gmail.com>
 <20200727162357.GA8022@lst.de>
In-Reply-To: <20200727162357.GA8022@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Eric Dumazet <edumazet@google.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>, "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>, "bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>, "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>, "dccp@vger.kernel.org" <dccp@vger.kernel.org>, "linux-decnet-user@lists.sourceforge.net" <linux-decnet-user@lists.sourceforge.net>, "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "mptcp@lists.01.org" <mptcp@lists.01.org>, "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>, "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>

From: Christoph Hellwig
> Sent: 27 July 2020 17:24
> 
> On Mon, Jul 27, 2020 at 06:16:32PM +0200, Jason A. Donenfeld wrote:
> > Maybe sockptr_advance should have some safety checks and sometimes
> > return -EFAULT? Or you should always use the implementation where
> > being a kernel address is an explicit bit of sockptr_t, rather than
> > being implicit?
> 
> I already have a patch to use access_ok to check the whole range in
> init_user_sockptr.

That doesn't make (much) difference to the code paths that ignore
the user-supplied length.
OTOH doing the user/kernel check on the base address (not an
incremented one) means that the correct copy function is always
selected.

Perhaps the functions should all be passed a 'const sockptr_t'.
The typedef could be made 'const' - requiring non-const items
explicitly use the union/struct itself.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
