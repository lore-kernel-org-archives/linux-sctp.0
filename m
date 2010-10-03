From: Robin Holt <holt@sgi.com>
Date: Sun, 03 Oct 2010 11:54:19 +0000
Subject: Re: sysctl_{tcp,udp,sctp}_mem overflow on 16TB system.
Message-Id: <20101003115419.GQ14068@sgi.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101001193958.GP14068@sgi.com>
 <20101001203022.GA28486@1wt.eu>
 <AANLkTin5wPvFQDFrupqGs_Jbh1rgrTjMupbPUFnvrBrv@mail.gmail.com>
In-Reply-To: <AANLkTin5wPvFQDFrupqGs_Jbh1rgrTjMupbPUFnvrBrv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Robin Holt <holt@sgi.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, linux-sctp@vger.kernel.org

On Sun, Oct 03, 2010 at 01:20:32AM -0700, Maciej =C5=BBenczykowski wrote:
> Isn't INT_MAX/2 just 1GB, which is only ~0.9 seconds at 10 Gbps?

Units matter.  1GB pages.  We can limit to 2GB pages or 8TB.

Robin
