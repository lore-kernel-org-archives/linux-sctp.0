From: David Miller <davem@davemloft.net>
Date: Mon, 06 Aug 2012 20:47:37 +0000
Subject: Re: [PATCH 00/13] SCTP: Enable netns
Message-Id: <20120806.134737.1358773847818872075.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <87mx27rig7.fsf@xmission.com>
	<50201928.2030802@gmail.com>
	<874noflrzd.fsf@xmission.com>
In-Reply-To: <874noflrzd.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ebiederm@xmission.com
Cc: vyasevich@gmail.com, jan.ariyasu@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jan.ariyasu@hp.com

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 06 Aug 2012 12:50:46 -0700

> Vlad Yasevich <vyasevich@gmail.com> writes:
> 
> 
>> Hi Eric
>>
>> Associations are looked up by ports, but then verifyed by addresses.
>> Also, associations belong to sockets and simply validating the socket
>> namespace should be sufficient.
> 
> True.  Your set of patches isn't quite as likely to malfunction as it
> looked at first glance.  It requires address reuse which happens accross
> namespaces but not too frequently.
> 
> As for validating the socket namespace I agree that is the fix and my
> patchset winds up doing it.

FWIW I much prefer Eric's patch set, it was so significantly easier to
read and validate than Jan's.
