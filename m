From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 09 Sep 2015 20:39:57 +0000
Subject: Re: SCTP PMTU calculation not accounting chunk padding.
Message-Id: <55F0991D.6080509@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On 09/09/2015 03:00 AM, Deepak Khandelwal wrote:
> Hi,
> 
> 
> It looks like the PMTU calculation in SCTP kernel / RFC, seems to be not
> accounting the chunk padding
> 
> 
> SCTP calculate the fragmentation point to fragment the packet.
> 
> 
> 
> Frag_point = PMTU – (sctp header length + sctp chunk length) – IP header
> length
> 
> 
> 
> After the frag_point, user data fragmentation happens at SCTP layer, but
> while sending packet due the need of chunk padding, data size still more
> then mtu of in between router, and packet doesn’t pass through to the
> channel . local SCPT stack always end up receiving the ICMP FRAG _NEEDED
> messages.
> 
> I am using Kernel version 2.6.34.9-WR4.3
> 

You are missing

commit c08751c851b78514f6ec5f77f7cbebaac63d15c0
Author: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Date:   Mon Sep 2 15:58:25 2013 +0200

    net: sctp: Fix data chunk fragmentation for MTU values which are not multiple of 4


-vlad
> Thanks !
> Best Regards,
> Deepak
> 

