From: subashab@codeaurora.org
Date: Tue, 10 Dec 2019 18:12:39 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <0101016ef1035a6a-d3a8b345-600a-4e28-b3da-12fd2fac72d1-000000@us-west-2.amazonses.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
 <0101016eee9bf9b5-f5615781-f0a6-41c4-8e9d-ed694eccf07c-000000@us-west-2.amazonses.com>
 <20191210091241.0c6df09e@cakuba.netronome.com>
In-Reply-To: <20191210091241.0c6df09e@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

> It's a form of one, agreed, although let's be honest - someone reading
> the transparent proxy use case in the commit message will not think of
> a complex AP scenario, but rather of a locally configured transparent
> proxy with IPtables or sockets or such.

Transparent proxy could be implemented using eBPF + XDP and those don't
need sockets. However, in that case we do need to block those specific 
ports
to avoid messing with unrelated traffic.
