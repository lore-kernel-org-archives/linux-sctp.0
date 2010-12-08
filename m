From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 08 Dec 2010 01:22:34 +0000
Subject: Re: [34/44] Limit sysctl_tcp_mem and sysctl_udp_mem initializers to
Message-Id: <AANLkTimTw3O-OM-5Cgv0ELNj8SmMjaaeMHMd2NNezxi7@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101208003205.GA4286@kroah.com> <20101208000642.975564500@clark.site>
In-Reply-To: <20101208000642.975564500@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, "David S. Miller" <davem@davemloft.net>, stable-review@kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Robin Holt <holt@sgi.com>, Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>

On Tue, Dec 7, 2010 at 4:04 PM, Greg KH <gregkh@suse.de> wrote:
>
> From: Robin Holt <holt@sgi.com>
>
> [ Problem was fixed differently upstream. -DaveM ]

Gaah. I'd really like to see more of a description for things like
this. A commit ID for the alternate fix, or at least a few words about
the different fix or reason why upstream doesn't need the stable
commit.

                  Linus
