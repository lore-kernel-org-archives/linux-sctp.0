From: David Miller <davem@davemloft.net>
Date: Sat, 03 Aug 2019 18:03:39 +0000
Subject: Re: [PATCH v3] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Message-Id: <20190803.110339.449734752227362483.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1564500633-7419-1-git-send-email-cai@lca.pw>
In-Reply-To: <1564500633-7419-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cai@lca.pw
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, David.Laight@ACULAB.COM, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Tue, 30 Jul 2019 11:30:33 -0400

> There are a lot of those warnings with GCC8+ 64-bit,
 ...
> This is because the commit 20c9c825b12f ("[SCTP] Fix SCTP socket options
> to work with 32-bit apps on 64-bit kernels.") added "packed, aligned(4)"
> GCC attributes to some structures but one of the members, i.e, "struct
> sockaddr_storage" in those structures has the attribute,
> "aligned(__alignof__ (struct sockaddr *)" which is 8-byte on 64-bit
> systems, so the commit overwrites the designed alignments for
> "sockaddr_storage".
> 
> To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
> it is only used in those packed sctp structure which is part of UAPI,
> and "struct __kernel_sockaddr_storage" is used in some other
> places of UAPI that need not to change alignments in order to not
> breaking userspace.
> 
> Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
> can keep the same alignments as a member in both packed and un-packed
> structures without breaking UAPI.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Qian Cai <cai@lca.pw>

Ok, this just changes how the alignment is declared from using the
aligned attribute to using a union member which requires the same
alignment.

Applied.
