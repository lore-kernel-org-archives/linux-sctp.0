From: David Miller <davem@redhat.com>
Date: Tue, 08 Apr 2014 18:19:18 +0000
Subject: Re: [PATCH net v2] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <20140408.141918.1353780924646899277.davem@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <53442A62.3050905@redhat.com>
	<20140408.131819.1373401078750444800.davem@davemloft.net>
	<53442FD0.5020609@redhat.com>
In-Reply-To: <53442FD0.5020609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com, vyasevic@redhat.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 08 Apr 2014 19:20:16 +0200

> On 04/08/2014 07:18 PM, David Miller wrote:
>> From: Daniel Borkmann <dborkman@redhat.com>
>> Date: Tue, 08 Apr 2014 18:57:06 +0200
>>
>>> Hm, I still found an issue, please hold on with this one, thanks.
>>
>> Ugh too late I pushed it out, you'll need to send a relative fix.
> 
> No problem, will do, thanks. I suggest to take it out from
> the stable queue for now. Sorry for any inconvenience.

I'm going to keep it in there and add the fixup when you submit it,
I'll make a mental note not to apply it until the fixup is in too.

I always re-read all of the discussion in the patchwork entry for
a patch when I backport it to -stable, so it's very unlikely that
I will accidently apply it without the fixup.

Thanks.
