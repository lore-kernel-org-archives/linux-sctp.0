From: David Miller <davem@davemloft.net>
Date: Thu, 20 Jan 2011 00:51:42 +0000
Subject: Re: [PATCH-v2] sctp: user perfect name for Delayed SACK Timer
Message-Id: <20110119.165142.63040447.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D3693CA.40508@cn.fujitsu.com>
	<4D36A324.4040307@cn.fujitsu.com>
	<4D36E904.4050609@hp.com>
In-Reply-To: <4D36E904.4050609@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: shanwei@cn.fujitsu.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 19 Jan 2011 08:37:08 -0500

> On 01/19/2011 03:39 AM, Shan Wei wrote:
>> The option name of Delayed SACK Timer should be SCTP_DELAYED_SACK,
>> not SCTP_DELAYED_ACK.
>> 
>> Left SCTP_DELAYED_ACK be concomitant with SCTP_DELAYED_SACK,
>> for making compatibility with existing applications.
>> 
>> Reference:
>> 8.1.19.  Get or Set Delayed SACK Timer (SCTP_DELAYED_SACK)
>> （http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-25)
>> 
> 
> this one much better.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
