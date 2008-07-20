From: Jan Engelhardt <jengelh@medozas.de>
Date: Sun, 20 Jul 2008 14:07:44 +0000
Subject: Re: IPV6_V6ONLY ignored for SCTP
Message-Id: <alpine.LNX.1.10.0807162242030.32031@fbirervta.pbzchgretzou.qr>
List-Id: <linux-sctp.vger.kernel.org>
References: <alpine.LNX.1.10.0805181244480.15590@fbirervta.pbzchgretzou.qr> <1216239342994-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1216239342994-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org


On Wednesday 2008-07-16 22:15, Vlad Yasevich wrote:

>Hi Jan
>
>Can you give this patch a try.  I wrote a bunch of test that
>I could think off and this seems to pass all of them.
>
>At this point it might just need to run and have some eyes on
>it.


stg import sctpv6.diff
done
Importing patch "sctpv6.diff" ... 
<stdin>:35: trailing whitespace.
            
<stdin>:43: trailing whitespace.
/* Does the address 'addr' conflict with any addresses in 
warning: 2 lines add whitespace errors.
done
Now at patch "sctpv6.diff"


At least fix these ;-)

But the patch works, thanks!
Jan
