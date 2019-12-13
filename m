From: subashab@codeaurora.org
Date: Fri, 13 Dec 2019 01:53:19 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <2e7ceea704ee71383d3f19d1de63dff4@codeaurora.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
 <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
 <20191210093111.7f1ad05d@cakuba.netronome.com>
 <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
 <20191212164749.4e4c8a4c@cakuba.netronome.com>
 <CAKD1Yr1V4S3cxvTaBs6pReEZ_3LPobnxdroY+vE3-injHyGt2A@mail.gmail.com>
In-Reply-To: <CAKD1Yr1V4S3cxvTaBs6pReEZ_3LPobnxdroY+vE3-injHyGt2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Colitti <lorenzo@google.com>, Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On 2019-12-12 17:57, Lorenzo Colitti wrote:
> On Fri, Dec 13, 2019 at 9:47 AM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>> How are the ports which get reserved communicated between the baseband
>> and the AP? Is this part of the standard? Is the driver that talks to
>> the base band in the user space and it knows which ports to reserve
>> statically? Or does the modem dynamically request ports to
>> reserve/inform the host of ports in use?
> 
> I'm not an expert in that part of the system, but my understanding is
> that the primary way this is used is to pre-allocate a block of ports
> to be used by the modem on boot, before other applications can bind to
> ports. Subash, do you have more details?

AFAIK these ports are randomly picked and not from a standard.
Userspace gets this information through qrtr during boot.

Atleast in our case, there cannot be any existing user of these ports
since these ports are blocked prior to mobile connection establishment.
We could call SOCK_DIAG_DESTROY on these ports from userspace as a
precaution as applications would gracefully handle the socket errors.
