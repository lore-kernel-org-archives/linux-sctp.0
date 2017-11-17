From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 17 Nov 2017 12:35:07 +0000
Subject: Re: Multi-homed SCTP with NAT
Message-Id: <20171117123507.GA12283@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <BY2PR03MB409F0A6B2B29B20B0201BCCD62E0@BY2PR03MB409.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR03MB409F0A6B2B29B20B0201BCCD62E0@BY2PR03MB409.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Nov 16, 2017 at 03:21:55PM +0000, Butler, Peter wrote:
> Are there any Linux tools/tricks/hacks that would allow us to setup a multi-homed association through a NAT?
> 
> I am aware of the information in the SCTP Applicability Statement (RFC 3257), however the NAT in question does not have an internal Application Layer Gateway (ALG) capable of intelligently translating the additional IP addresses embedded within the INIT and INIT ACK chunks (only the addresses in the IP header are translated).  As such, these additional address do not get translated to addresses that the remote end understands.
> 
> Peter Butler
> 
If you can't do that translation of init and ack chunks, you're pretty well out
of luck.  

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
