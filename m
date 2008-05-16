From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 16 May 2008 05:09:02 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH v3] [SCTP] Fast retransmit fixes
Message-Id: <482D16EE.10304@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482C0926.9030600@cn.fujitsu.com>
In-Reply-To: <482C0926.9030600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>
>>
>>
>> 2. Shutdown can not be send after all of the data has been ack, 
>> unknow reason, kill the sctp process can cause shutdown be sent .
>
> Hm.. At what point does the app does a close?  In my test that's similar
> to the second scenario from the dump where second and third packets are
> lost, I have a graceful shutdown after all the data is acknowledged.
>
>
>> And while do the second fast retransmit DATA(TSN = 3), new data is 
>> sent, is this correct? See dump file in attachment 2.html.Lik0.dump. 
>> I send 20 data packet to Endpoint B, and the data size is 1024.
>
> That's fine.  It's not really a fast retransmit any more.  In this 
> scenario,
> both chunks strike out at the same time and we only fast-rtx the first 
> one,
> leaving the next one to be retransmitted when the sack arrives.  Once 
> the SACK
> arrives, we do standard retransmit of as much as we can subject to 
> congestion
> window and if we can send new data, we do.
>
> The part the confuses me is the part about shutdown since this change 
> shouldn't
> effect anything wrt to shutdown procedure.
>

I found out that this is the bug of my program, not SCTP's. The close() 
function not call the shutdown because I created a child process by fork().
This patchset seems good to me. Thanks.

Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>



