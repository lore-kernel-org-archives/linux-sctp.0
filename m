From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 10 Dec 2019 17:12:41 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191210091241.0c6df09e@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
        <20191209161835.7c455fc0@cakuba.netronome.com>
        <0101016eee9bf9b5-f5615781-f0a6-41c4-8e9d-ed694eccf07c-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016eee9bf9b5-f5615781-f0a6-41c4-8e9d-ed694eccf07c-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: subashab@codeaurora.org
Cc: Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Tue, 10 Dec 2019 07:00:29 +0000, subashab@codeaurora.org wrote:
> > Okay, that's what I was suspecting.  It'd be great if the real
> > motivation for a patch was spelled out in the commit message :/
> > 
> > So some SoCs which run non-vanilla kernels require hacks to steal
> > ports from the networking stack for use by proprietary firmware.
> > 
> > I don't see how merging this patch benefits the community.
> 
> This is just a transparent proxy scenario though.
> We block the specific ports so that there is no unrelated traffic
> belonging to host proxied here incorrectly.

It's a form of one, agreed, although let's be honest - someone reading
the transparent proxy use case in the commit message will not think of
a complex AP scenario, but rather of a locally configured transparent
proxy with IPtables or sockets or such.
