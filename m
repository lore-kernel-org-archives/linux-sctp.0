From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Wed, 03 Dec 2014 15:30:44 +0000
Subject: Re: wrong family for IP addresses given by sctp library
Message-Id: <01A9A9B9-6A89-458A-84EA-AA5D458F6846@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03 Dec 2014, at 14:27, Boiteux Frederic <fboiteux@prosodie.com> wrote:

> 	Hello Ivan, Michael, Daniel,
> 
>> Isn't the returned address simply a IPv6-mapped IPv4 address (::ffff:1.2.3.4) ? You can test it with IN6_IS_ADDR_V4MAPPED.
> 
> Yes, it is (I've verified with the provided macro) ! I'll use this macro to detect and update provided addresses, thanks !
Not sure if LKSCTP supports it, but you can use
https://tools.ietf.org/html/rfc6458#section-8.1.15
to control if the addresses should be provided as IPv4 addresses or mapped IPv6 ones.

Best regards
Michael
> 
> 
> Daniel, I'll try to test it on a recent kernel, but it will take some time to set up... thanks for the commit's reference !
> 
> 	Regards,
> 		Fred.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

