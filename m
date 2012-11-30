From: David Miller <davem@davemloft.net>
Date: Fri, 30 Nov 2012 17:26:34 +0000
Subject: Re: [PATCH] sctp: verify length provided in heartbeat information parameter
Message-Id: <20121130.122634.395602436506279741.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20121130121627.GG30697@casper.infradead.org>
	<20121130160156.GC6039@hmsreliant.think-freely.org>
In-Reply-To: <20121130160156.GC6039@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: tgraf@suug.ch, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 30 Nov 2012 11:01:57 -0500

> On Fri, Nov 30, 2012 at 12:16:27PM +0000, Thomas Graf wrote:
>> If the variable parameter length provided in the mandatory
>> heartbeat information parameter exceeds the calculated payload
>> length the packet has been corrupted. Reply with a parameter
>> length protocol violation message.
>> 
>> Signed-off-by: Thomas Graf <tgraf@suug.ch>
...
>> 
> Looks good, thanks Thomas.
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 

Applied, thanks.
