From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 08:48:23 +0000
Subject: Re: [PATCH-v2] sctp: user perfect name for Delayed SACK Timer option
Message-Id: <4D36A557.6080708@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D3693CA.40508@cn.fujitsu.com> <4D36A324.4040307@cn.fujitsu.com>
In-Reply-To: <4D36A324.4040307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, Network-Maillist <netdev@vger.kernel.org>, SCTP-Maillist <linux-sctp@vger.kernel.org>


> The option name of Delayed SACK Timer should be SCTP_DELAYED_SACK,
> not SCTP_DELAYED_ACK.
>
> Left SCTP_DELAYED_ACK be concomitant with SCTP_DELAYED_SACK,
> for making compatibility with existing applications.

SCTP_DELAYED_ACK is introduced by my typo when change it to
API compliance two years ago. So:

Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>


