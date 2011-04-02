From: David Miller <davem@davemloft.net>
Date: Sat, 02 Apr 2011 04:46:10 +0000
Subject: Re: [PATCH 2/2] sctp: malloc enough room for asconf-ack chunk
Message-Id: <20110401.214610.200375443.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D959D2E.40605@cn.fujitsu.com>
	<4D959E1F.80504@cn.fujitsu.com>
In-Reply-To: <4D959E1F.80504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 01 Apr 2011 17:42:55 +0800

> Sometime the ASCONF_ACK parameters can equal to the fourfold of
> ASCONF parameters, this only happend in some special case:
> 
>   ASCONF parameter is :
>     Unrecognized Parameter (4 bytes)
>   ASCONF_ACK parameter should be:
>     Error Cause Indication parameter (8 bytes header)
>      + Error Cause (4 bytes header)
>        + Unrecognized Parameter (4bytes)
> 
> Four 4bytes Unrecognized Parameters in ASCONF chunk will cause panic.
 ...
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
