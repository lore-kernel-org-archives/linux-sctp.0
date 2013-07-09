From: David Miller <davem@davemloft.net>
Date: Tue, 09 Jul 2013 19:50:22 +0000
Subject: Re: [PATCH] net: sctp: confirm route during forward progress
Message-Id: <20130709.125022.1233764359019010136.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1373379424-5843-1-git-send-email-dborkman@redhat.com>
	<20130709162323.GB955@hmsreliant.think-freely.org>
In-Reply-To: <20130709162323.GB955@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 9 Jul 2013 12:23:23 -0400

> On Tue, Jul 09, 2013 at 04:17:04PM +0200, Daniel Borkmann wrote:
>> This fix has been proposed originally by Vlad Yasevich. He says:
>> 
>>   When SCTP makes forward progress (receives a SACK that acks new chunks,
>>   renegs, or answeres 0-window probes) or when HB-ACK arrives, mark
>>   the route as confirmed so we don't unnecessarily send NUD probes.
>> 
>> Having a simple SCTP client/server that exchange data chunks every 1sec,
>> without this patch ARP requests are sent periodically every 40-60sec.
>> With this fix applied, an ARP request is only done once right at the
>> "session" beginning. Also, when clearing the related ARP cache entry
>> manually during the session, a new request is correctly done. I have
>> only "backported" this to net-next and tested that it works, so full
>> credit goes to Vlad.
>> 
>> Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks.
