From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 10 Dec 2019 00:18:35 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191209161835.7c455fc0@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
In-Reply-To: <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

On Tue, 10 Dec 2019 01:02:08 +0100, Maciej =C5=BBenczykowski wrote:
> > Could you elaborate what protocols and products are in need of this
> > functionality? =20
>=20
> The ones I'm aware of are:
> (a) Google's servers
> (b) Android on at least some chipsets (Qualcomm at the bare minimum,
> but I think it's pretty standard a solution) where there's a complex
> port sharing scheme between the Linux kernel on the Application
> Processor and the Firmware running on the modem (for ipv4 we only get
> one ip address from the cellular carrier).  It's basically required
> for things like wifi calling to work.

Okay, that's what I was suspecting.  It'd be great if the real
motivation for a patch was spelled out in the commit message :/

So some SoCs which run non-vanilla kernels require hacks to steal
ports from the networking stack for use by proprietary firmware.

I don't see how merging this patch benefits the community.

> > Why can't the NIC just get its own IP like it usually does with NCSI?  =

>=20
> Because often these nics are deployed as in place upgrades in
> environments where there's a limited number of IPs.
> Say a rack with a /27 ipv4 subnet (2**5 =3D 32 -> 29 usable ips, since
> network/broadcast/gateway are burned) and 15+ pre-existing machines.
> This means there's not enough IPs to assign separate ones for the nics.
> Renumbering the rack, would imply renumbering the datacenter, etc...
> And ipv4 - even RFC1918 - has long run out - so even in new
> deployments there's not enough IPv4 ips to give to nics, and IPv6
> isn't yet deployed *everywhere*.

So the conditions for this are:
 - in-place upgrade of an existing rack
 - IPv4 only
 - the existing servers didn't have NCSI or otherwise IPs for OOB
   control

Unlike the AP one this sounds like a very rare scenario..
