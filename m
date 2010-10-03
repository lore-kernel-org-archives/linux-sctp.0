From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Sun, 03 Oct 2010 08:20:32 +0000
Subject: Re: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
Message-Id: <AANLkTin5wPvFQDFrupqGs_Jbh1rgrTjMupbPUFnvrBrv@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101001193958.GP14068@sgi.com>
	<20101001203022.GA28486@1wt.eu>
In-Reply-To: <20101001203022.GA28486@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Willy Tarreau <w@1wt.eu>
Cc: Robin Holt <holt@sgi.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-sctp@vger.kernel.org

Isn't INT_MAX/2 just 1GB, which is only ~0.9 seconds at 10 Gbps?
