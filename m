From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 15 May 2008 11:49:36 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH v3] [SCTP] Fast retransmit fixes
Message-Id: <482C2350.4010404@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482C0926.9030600@cn.fujitsu.com>
In-Reply-To: <482C0926.9030600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Hi Vlad:
> 
> There are other problems, description as following:
> 
> 1. If the first DATA is lost, it can not do fast retransmit, instead, 
> T3-timeout is happend.See dump file in attachment 1.html.Lik0.dump.
> 
> Endpoint A                       Endpoint B
> DATA (TSN = 1)  -- (lost)---->
> DATA (TSN = 2)  ------------->
> DATA (TSN = 3)  ------------->
> DATA (TSN = 4)  ------------->
>               <-------------   SACK (CTSN = 0, GAP-START = 2, GAP-END = 2)
>               <-------------   SACK (CTSN = 0, GAP-START = 2, GAP-ENT = 3)
>               <------------    SACK (CTSN = 0, GAP-START = 2, GAP-ENT = 4)
> DATA (TSN = 1)  -- (not fast rtx, but t3-timeout)---->
>               <------------    SACK (CTSN = 4)
> DATA (TSN = 5) ------------->
>               <-------------   SACK (CTSN = 5)
> 
> The cwnd change sequence is: 4380 -> 1500

This is not a new problem.  This happens with the original code as well
and is due to the SFR algorithm.

> 
> 
> 2. Shutdown can not be send after all of the data has been ack, unknow 
> reason, kill the sctp process can cause shutdown be sent .

Hm.. At what point does the app does a close?  In my test that's similar
to the second scenario from the dump where second and third packets are
lost, I have a graceful shutdown after all the data is acknowledged.


> And while do 
> the second fast retransmit DATA(TSN = 3), new data is sent, is this 
> correct? See dump file in attachment 2.html.Lik0.dump. I send 20 data 
> packet to Endpoint B, and the data size is 1024.

That's fine.  It's not really a fast retransmit any more.  In this scenario,
both chunks strike out at the same time and we only fast-rtx the first one,
leaving the next one to be retransmitted when the sack arrives.  Once the SACK
arrives, we do standard retransmit of as much as we can subject to congestion
window and if we can send new data, we do.

The part the confuses me is the part about shutdown since this change shouldn't
effect anything wrt to shutdown procedure.

-vlad

> 
> Endpoint A                       Endpoint B
> DATA (TSN = 1)  -- (lost)---->
> DATA (TSN = 2)  ------------->
> DATA (TSN = 3)  ------------->
> DATA (TSN = 4)  ------------->
> DATA (TSN = 5)  ------------->
>               <------------    SACK (CTSN = 1)
> DATA (TSN = 6)  ------------->
> DATA (TSN = 7)  ------------->
>               <-------------   SACK (CTSN = 1, GAP-START = 3, GAP-END = 6)
> DATA (TSN = 8)  ------------->
> DATA (TSN = 9)  ------------->
> DATA (TSN = 10)  ------------->
> DATA (TSN = 11)  ------------->
>               <-------------   SACK (CTSN = 1, GAP-START = 3, GAP-END = 10)
> DATA (TSN = 12)  ------------->
> DATA (TSN = 13)  ------------->
> DATA (TSN = 14)  ------------->
> DATA (TSN = 15)  ------------->
>               <-------------   SACK (CTSN = 1, GAP-START = 3, GAP-END = 14)
> DATA (TSN = 2)  -- (fast rtx)---->
>               <-------------   SACK (CTSN = 2, GAP-START = 2, GAP-END = 13)
> DATA (TSN = 3)  -- (fast rtx)---->
> DATA (TSN = 16)  ------------->
> DATA (TSN = 17)  ------------->
> DATA (TSN = 18)  ------------->
> DATA (TSN = 19)  ------------->
>               <-------------   SACK (CTSN = 15)
>               <-------------   SACK (CTSN = 19)
> DATA (TSN = 20, last data)  ------------->
>               <-------------   SACK (CTSN = 20)
> 
> 
> The cwnd change sequence is:
> 
> NO. ASSOC-ID STATE             RWND     UNACKDATA PENDDATA INSTRMS 
> OUTSTRMS FRAG-POINT SPINFO-STATE SPINFO-CWDN SPINFO-SRTT SPINFO-RTO 
> SPINFO-MTU
> 1   1        ESTABLISHED       54784    0         0        100     
> 10       1452       ACTIVE       4380        0           3000       1500
> 2   1        ESTABLISHED       48312    6         0        100     
> 10       1452       ACTIVE       5404        510         1530       1500
> 3   1        ESTABLISHED       53596    2         0        100     
> 10       1452       ACTIVE       6000        455         1179       1500
> 
> 
> 
> Vlad Yasevich wrote:
>> Changes from v2
>>     * remove the call sctp_list_dequeue() so that we don't change the
>>       retransmit list if we can't add the chunk to the packet.
>>
>>     * correctly catch the condition when we have to change the 
>> fast_retransmit
>>       state of the chunk.
>>
>>
>> Changes from v1
>>     * correclty clear the fast_rtx hint in the outq structure after fast
>>       retransmission is done.
>>
>>
>> Background (ver 1):
>>
>> 1.  We don't handle fast recovery correclty.  We reduce our congestion 
>> window
>> every time a new new chunk has to be retransmitted, which violates the 
>> fast
>> recover specification.
>>
>> 2.  We end up effectively fast retransmitting all of the chunks on the
>> retransmit queue.  This is because we flush the queue twice, once in
>> sctp_retransmit() and once in the sctp_outq_sack().  The queue must
>> be flushed only once so that future retransmissions are subject to cwnd.
>>
>> 3. As Wie found, we don't time-out retransmit a chunk that has been
>> fast-retransmitted.  This is because a fast-retransmitted chunk may
>> have been send less then rto ago.  To do proper time-outs, we need
>> to restart the T3 timer after we fast-retransmit the earliest outstanding
>> TSN.  Then the timer will be set correctly and T3 retransmissions will
>> happen.
>>
>>
>>   
> 

