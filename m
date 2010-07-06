From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 06 Jul 2010 13:43:22 +0000
Subject: Re: [PATCH 3/3] sctp: add heartbeat expired counter to /proc/net/sctp/snmp
Message-Id: <4C3332FA.7050107@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C2DA0A2.6070201@cn.fujitsu.com>
In-Reply-To: <4C2DA0A2.6070201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Shan Wei wrote:
> Vlad Yasevich wrote, at 07/02/2010 10:38 PM:
>> Shan Wei wrote:
>>> Just like T4-RTO, T3-RXT timeout events, add HEARTBEAT timeout
>>> counter for debug. It is useful because all these timeout events
>>> cause association error counter to increase.
>>>
>> Unlinke T4-RTO and T3-RTO, heartbeat timeouts happen all the time
>> and do not necessarily mean that a something is wrong.
> 
> They are different. I ignore this. 
>  
>> It may be worth tracking the number of non-responded heartbeats, since those
>> will actually cause association destruction.
> 
> If a heartbeat chunk is not responded, the global
> error counter value is increased. If this error value exceeds association_max_retrans,
> abort the association. But the error counter is also added by T3-RTO, T4-RTO event.
> 
> Although we know the number of non-responded heartbeats, we also don't know
> the closer of association destruction.
> 

Correct, but you are still not going to know this if you track the HB timeouts.
T3 and T4 timeouts are rare and signify a problem on the network.  HB timeouts do
not.  The number of HB timeouts on the system will be so large and potentially wrap
so quickly that it will not provide any useful information.

On the other hands, timeouts triggered by a non-responsive HB do have value.  They
indicate a similar problem as T3 and T4 timeouts, i.e the path to the remote end is down.
Keeping that value would provide as much information as the T3 timeout value.

-vlad
