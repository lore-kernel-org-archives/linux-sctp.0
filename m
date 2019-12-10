From: subashab@codeaurora.org
Date: Tue, 10 Dec 2019 07:00:30 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <0101016eee9bfacd-d60e502b-06b1-4870-87e6-c8402b096006-000000@us-west-2.amazonses.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
In-Reply-To: <20191209161835.7c455fc0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

> Okay, that's what I was suspecting.  It'd be great if the real
> motivation for a patch was spelled out in the commit message :/
> 
> So some SoCs which run non-vanilla kernels require hacks to steal
> ports from the networking stack for use by proprietary firmware.
> 
> I don't see how merging this patch benefits the community.
> 

This is just a transparent proxy scenario though.
We block the specific ports so that there is no unrelated traffic
belonging to host proxied here incorrectly.
