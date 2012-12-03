From: David Miller <davem@davemloft.net>
Date: Mon, 03 Dec 2012 18:33:12 +0000
Subject: Re: [PATCH v4 net-next] sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STA
Message-Id: <20121203.133312.69027699789824133.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1354373382-15230-1-git-send-email-michele@acksyn.org>
	<50BCD956.2090706@gmail.com>
In-Reply-To: <50BCD956.2090706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: michele@acksyn.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, tgraf@suug.ch, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 03 Dec 2012 11:54:46 -0500

> On 12/01/2012 09:49 AM, Michele Baldessari wrote:
>> The current SCTP stack is lacking a mechanism to have per association
>> statistics. This is an implementation modeled after OpenSolaris'
>> SCTP_GET_ASSOC_STATS.
>>
>> Userspace part will follow on lksctp if/when there is a general ACK on
>> this.
 ...
>> Signed-off: Michele Baldessari <michele@acksyn.org>
> 
> Looks good
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied.
