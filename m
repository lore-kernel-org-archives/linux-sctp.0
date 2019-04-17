From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 17 Apr 2019 14:46:05 +0000
Subject: Re: [PATCH net-next 1/3] net: rework SIOCGSTAMP ioctl handling
Message-Id: <CAF=yD-K89Z2ea_iakjfP98GnfU-yXts8LU4GW3Rr_etJ+r92pw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190416203620.539628-1-arnd@arndb.de>
In-Reply-To: <20190416203620.539628-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>, Ralf Baechle <ralf@linux-mips.org>, Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, Gerrit Renker <gerrit@erg.abdn.ac.uk>, Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Andrew Hendry <andrew.hendry@gmail.com>, Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org, linux-x25@vger.kernel.org

On Tue, Apr 16, 2019 at 4:38 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The SIOCGSTAMP/SIOCGSTAMPNS ioctl commands are implemented by many
> socket protocol handlers, and all of those end up calling the same
> sock_get_timestamp()/sock_get_timestampns() helper functions, which
> results in a lot of duplicate code.
>
> With the introduction of 64-bit time_t on 32-bit architectures, this
> gets worse, as we then need four different ioctl commands in each
> socket protocol implementation.
>
> To simplify that, let's add a new .gettstamp() operation in
> struct proto_ops, and move ioctl implementation into the common
> sock_ioctl()/compat_sock_ioctl_trans() functions that these all go
> through.
>
> We can reuse the sock_get_timestamp() implementation, but generalize
> it so it can deal with both native and compat mode, as well as
> timeval and timespec structures.
>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Link: https://lore.kernel.org/lkml/CAK8P3a038aDQQotzua_QtKGhq8O9n+rdiz2=WDCp82ys8eUT+A@mail.gmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: reworked to not break sparc64 support

From the discussion of v1 I thought you planned to unconditionally
call sock_gettstamp() for all protocols, avoiding the need to plumb in
all these new callbacks?

That is more concise, though this closer to the existing behavior. So,
fine either way.
