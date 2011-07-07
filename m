From: David Miller <davem@davemloft.net>
Date: Thu, 07 Jul 2011 21:09:04 +0000
Subject: Re: [PATCHv3] sctp: Enforce retransmission limit during shutdown
Message-Id: <20110707.140904.252541509664898900.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4E148C16.8090505@hp.com>
	<20110707102835.GA6277@canuck.infradead.org>
	<4E15B65A.3010209@hp.com>
In-Reply-To: <4E15B65A.3010209@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, yjwei@cn.fujitsu.com, sri@us.ibm.com, linux-sctp@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 07 Jul 2011 09:36:26 -0400

> On 07/07/2011 06:28 AM, Thomas Graf wrote:
>> When initiating a graceful shutdown while having data chunks
>> on the retransmission queue with a peer which is in zero
>> window mode the shutdown is never completed because the
>> retransmission error count is reset periodically by the
>> following two rules:
 ...
>> Signed-off-by: Thomas Graf <tgraf@infradead.org>
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
