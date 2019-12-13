From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 13 Dec 2019 00:47:49 +0000
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191212164749.4e4c8a4c@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
        <20191209161835.7c455fc0@cakuba.netronome.com>
        <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
        <20191210093111.7f1ad05d@cakuba.netronome.com>
        <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
In-Reply-To: <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Colitti <lorenzo@google.com>
Cc: Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>, "David S . Miller" <davem@davemloft.net>, Linux Network Development Mailing List <netdev@vger.kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Sean Tranchetti <stranche@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

On Fri, 13 Dec 2019 09:16:03 +0900, Lorenzo Colitti wrote:
> On Wed, Dec 11, 2019 at 2:31 AM Jakub Kicinski wrote:
> > I don't consider users of non-vanilla kernels to necessarily be a
> > reason to merge patches upstream, no. They carry literally millions
> > of lines of patches out of tree, let them carry this patch, too.
> > If I can't boot a vanilla kernel on those devices, and clearly there is
> > no intent by the device manufacturers for me to ever will, why would I
> > care?  
> 
> That's *not* the intent.
> https://arstechnica.com/gadgets/2019/11/google-outlines-plans-for-mainline-linux-kernel-support-in-android/
> 
> > > The reason Android runs non-vanilla kernels is *because* patches like
> > > this - that make Linux work in the real world - are missing from
> > > vanilla Linux  
> 
> That's exactly the point here. Saying, "Android will never use
> mainline, so why should mainline take their patches" is a
> self-fulfilling prophecy. Obviously, if mainline never takes Android
> patches, then yes, Android will never be able to use mainline. We do
> have an Android tree we can take this patch into. But we don't want to
> take it without at least attempting to get it into mainline first.
> 
> The use case here is pretty simple. There are many CPUs in a mobile
> phone. The baseband processor ("modem") implements much of the
> functionality required by cellular networks, so if you want cellular
> voice or data, it needs to be able to talk to the network. For many
> reasons (architectural, power conservation, security), the modem needs
> to be able to talk directly to the cellular network. This includes,
> for example, SIP/RTP media streams that go directly to the audio
> hardware, IKE traffic that is sent directly by the modem because only
> the modem has the keys, etc. Normally this happens directly on the
> cellular interface and Linux/Android is unaware of it. But, when using
> wifi calling (which is an IPsec tunnel over wifi to an endpoint inside
> the cellular network), the device only has one IPv4 address, and the
> baseband processor and the application processor (the CPU that runs
> Linux/Android) have to share it. This means that some ports have to be
> reserved so that the baseband processor can depend on using them. NAT
> cannot be used because the 3GPP standards require protocols that are
> not very NAT-friendly, and because the modem needs to be able to
> accept unsolicited inbound traffic.
> 
> Other than "commit message doesn't have a use case", are there
> technical concerns with this patch?

Maybe a minor question or two, but the main complaint is the commit
message.

How are the ports which get reserved communicated between the baseband
and the AP? Is this part of the standard? Is the driver that talks to
the base band in the user space and it knows which ports to reserve
statically? Or does the modem dynamically request ports to
reserve/inform the host of ports in use?

Should the sysfs interface make sure there are not existing sockets
using requested ports which would stop working? If we may need it one
day better add it now..
