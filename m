From: David Miller <davem@davemloft.net>
Date: Tue, 20 Dec 2011 18:59:32 +0000
Subject: Re: [PATCH] sctp: Do not account for sizeof(struct sk_buff) in
Message-Id: <20111220.135932.1341471164986426570.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAPgLHd-JL8cjMBSqO5Lc5nEt42zqj8qAn+qHaM35HTmnhOHg7w@mail.gmail.com>
	<20111220093910.GB21801@canuck.infradead.org>
	<4EF0CD69.9000602@hp.com>
In-Reply-To: <4EF0CD69.9000602@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: weiyj.lk@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 20 Dec 2011 13:01:13 -0500

> 
> 
> On 12/20/2011 04:39 AM, Thomas Graf wrote:
>> On Tue, Dec 20, 2011 at 01:00:48PM +0800, Wei Yongjun wrote:
>>> I saw you discussed this with Vlad in old mail:
>>>      http://www.spinics.net/lists/linux-sctp/msg01365.html
>>>
>>> You said you will update patch to include a per packet overhead,
>>> but it does not include in this patch, what's wrong with in?
>>
>> It's not possible because upon retransmission of a chunk we need
>> to readd the overhead to the rwnd. There is no longer a reference
>> to a packet so we can't know how much to add. This explanation is
>> also in the original mail thread.
>>
> 
> 
> Right.  The original patches were done to work around the problem of
> leftover rwnd when socket buffer is exhausted and they didn't really
> address the problem sufficiently.  It was still possible to reach that
> condition.  Some subsequent patches added support to address this
> issue
> a different way.  As a result, I think this revert is just fine.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks everyone.
