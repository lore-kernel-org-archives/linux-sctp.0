From: David Miller <davem@davemloft.net>
Date: Sat, 02 Apr 2011 04:46:00 +0000
Subject: Re: [PATCH 1/2] sctp: fix auth_hmacs field's length of struct
Message-Id: <20110401.214600.116373329.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D959D2E.40605@cn.fujitsu.com>
In-Reply-To: <4D959D2E.40605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 01 Apr 2011 17:38:54 +0800

> auth_hmacs field of struct sctp_cookie is used for store
> Requested HMAC Algorithm Parameter, and each HMAC Identifier
> is 2 bytes, so the length should be:
>   SCTP_AUTH_NUM_HMACS * sizeof(__u16) + 2
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
