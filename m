From: David Miller <davem@davemloft.net>
Date: Thu, 17 Jan 2013 23:40:38 +0000
Subject: Re: [PATCH] sctp: refactor sctp_outq_teardown to insure proper re-initalization
Message-Id: <20130117.184038.2028006072256759665.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1358457308-6407-1-git-send-email-nhorman@tuxdriver.com>
	<50F87FB4.3070604@gmail.com>
In-Reply-To: <50F87FB4.3070604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, Jamie.Parsons@metaswitch.com, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 17 Jan 2013 17:48:20 -0500

> On 01/17/2013 04:15 PM, Neil Horman wrote:
>> Jamie Parsons reported a problem recently, in which the
>> re-initalization of an
>> association (The duplicate init case), resulted in a loss of receive
>> window
>> space.  He tracked down the root cause to sctp_outq_teardown, which
>> discarded
>> all the data on an outq during a re-initalization of the corresponding
>> association, but never reset the outq->outstanding_data field to zero.
>> I wrote,
>> and he tested this fix, which does a proper full re-initalization of
>> the outq,
>> fixing this problem, and hopefully future proofing us from simmilar
>> issues down
>> the road.
>>
> 
> Good find.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied and queued up for -stable, thanks everyone.
