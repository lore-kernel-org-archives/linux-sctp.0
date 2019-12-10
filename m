From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Tue, 10 Dec 2019 00:02:08 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com> <20191209154216.7e19e0c0@cakuba.netronome.com>
In-Reply-To: <20191209154216.7e19e0c0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

> Could you elaborate what protocols and products are in need of this
> functionality?

The ones I'm aware of are:
(a) Google's servers
(b) Android on at least some chipsets (Qualcomm at the bare minimum,
but I think it's pretty standard a solution) where there's a complex
port sharing scheme between the Linux kernel on the Application
Processor and the Firmware running on the modem (for ipv4 we only get
one ip address from the cellular carrier).  It's basically required
for things like wifi calling to work.

> Why can't the NIC just get its own IP like it usually does with NCSI?

Because often these nics are deployed as in place upgrades in
environments where there's a limited number of IPs.
Say a rack with a /27 ipv4 subnet (2**5 = 32 -> 29 usable ips, since
network/broadcast/gateway are burned) and 15+ pre-existing machines.
This means there's not enough IPs to assign separate ones for the nics.
Renumbering the rack, would imply renumbering the datacenter, etc...
And ipv4 - even RFC1918 - has long run out - so even in new
deployments there's not enough IPv4 ips to give to nics, and IPv6
isn't yet deployed *everywhere*.
