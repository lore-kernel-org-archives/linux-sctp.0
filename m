From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Wed, 22 Nov 2017 19:37:04 +0000
Subject: RE: Multi-homed SCTP with NAT
Message-Id: <BL2PR03MB4024E3215FC11BF41CB6EC0D6200@BL2PR03MB402.namprd03.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <BY2PR03MB409F0A6B2B29B20B0201BCCD62E0@BY2PR03MB409.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR03MB409F0A6B2B29B20B0201BCCD62E0@BY2PR03MB409.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thanks for the good information. :-)

Peter



-----Original Message-----
From: Michael Tuexen [mailto:Michael.Tuexen@lurchi.franken.de] 
Sent: November-22-17 2:16 PM
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Butler, Peter <pbutler@sonusnet.com>; linux-sctp@vger.kernel.org
Subject: Re: Multi-homed SCTP with NAT

> On 22. Nov 2017, at 19:55, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> 
> On Thu, Nov 16, 2017 at 03:21:55PM +0000, Butler, Peter wrote:
>> Are there any Linux tools/tricks/hacks that would allow us to setup a 
>> multi-homed association through a NAT?
> 
> Not really, because
> 
>> 
>> I am aware of the information in the SCTP Applicability Statement 
>> (RFC 3257), however the NAT in question does not have an internal 
>> Application Layer Gateway (ALG) capable of intelligently translating 
>> the additional IP addresses embedded within the INIT and INIT ACK 
>> chunks (only the addresses in the IP header are translated).  As 
>> such, these additional address do not get translated to addresses 
>> that the remote end understands.
> 
> If you're really leveraging multi-homing, the router doing NAT for the 
> INIT chunk may not even know the public address for the other path, 
> rendering it unable to do the translation even if it knew how to 
> mangle the INIT chunk.
> 
> And the router on the secondary path may not know about the 
> association at all until a HEARTBEAT or so comes through.
> 
> In order to do it right we need
> https://datatracker.ietf.org/doc/html/draft-ietf-tsvwg-natsupp
> but we don't have that. (note that even the VTAG should be translated)
Neither the SCTP port number nor the vtag are translated. The idea is to use the vtag as part of a connection identifier to deal with port number collisions.

Best regards
Michael
> 
> As already suggested, probably setting up tunnels between the 
> endpoints and avoiding the translation at all is a better way to go.
> 
>  Marcelo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html

