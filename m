From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 09 Dec 2019 23:42:16 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191209154216.7e19e0c0@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
In-Reply-To: <20191209224530.156283-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc: Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

On Mon,  9 Dec 2019 14:45:30 -0800, Maciej =C5=BBenczykowski wrote:
> Example use cases might be:
>  - a port being stolen by the nic for remote serial console, remote
>    power management or some other sort of debugging functionality
>    (crash collection, gdb, direct access to some other microcontroller
>    on the nic or motherboard, remote management of the nic itself).

This use case makes me a little uncomfortable.

Could you elaborate what protocols and products are in need of this
functionality?

Why can't the NIC just get its own IP like it usually does with NCSI?
