From: David Miller <davem@davemloft.net>
Date: Wed, 19 Jan 2011 07:39:32 +0000
Subject: Re: [PATCH] sctp: user perfect name for Delayed SACK Timer option
Message-Id: <20110118.233932.91327830.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D3693CA.40508@cn.fujitsu.com>
In-Reply-To: <4D3693CA.40508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
To: shanwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 15:33:30 +0800

> The option name of Delayed SACK Timer should be SCTP_DELAYED_SACK,
> not SCTP_DELAYED_ACK.
> 
> Reference:
> 8.1.19.  Get or Set Delayed SACK Timer (SCTP_DELAYED_SACK)
> （http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-25)
> 
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>

You can't make this change, you'll break applications using the
existing definition.
