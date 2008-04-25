From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 25 Apr 2008 17:56:18 +0000
Subject: Re: [PATCH] SCTP: Fix DATA retransmit after fast retransmit
Message-Id: <48121B42.8070205@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48085441.2030904@cn.fujitsu.com>
In-Reply-To: <48085441.2030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Hi Vlad:
> 
> Vlad Yasevich wrote:
>> Hi Wei
>>
>> I was able to reproduce the problem as well as understand when the rfc 
>> really
>> wants us to do.
>>
>> On further analysis we have a lot of problems with fast retransmit.
>>
>> 1.  We really should be restarting the T3 timer any time we fast 
>> retransmit the
>> lowest outstanding TSN.  In your scenario, we would restart the T3-rtx 
>> time when
>> we fast retransmit TSN 2.
> 
> Does this means that when we do fast retransmit, we would restart the 
> T3-rtx time?

Yes, but only when fast retransmitting the lowest outstanding TSN.
So, let's take the scenario we've been working with.

Endpoint A                       Endpoint B
DATA (TSN = 1)  ------------->
DATA (TSN = 2)  -- (lost)---->
DATA (TSN = 3)  ------------->
DATA (TSN = 4)  ------------->
              <-------------   SACK (CTSN = 1)
                                   At this point, lowest outstanding is 2.

DATA (TSN = 5)  ------------->
              <-------------   SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 2)
              <------------    SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 3)
              <------------    SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 4)

DATA (TSN = 2)  -(fast rtx)-->
    Since we are doing fast rtx for lowest outstanding, restart the T3 timer
    giving this chunk a chance to be acked.

              <---(lost)----   SACK (CTSN = 5) 


We can also extend this scenario a little bit more:

DATA (TSN = 1)  ------------->
DATA (TSN = 2)  -- (lost)---->
DATA (TSN = 3)  ------------->
DATA (TSN = 4)  -- (lost)---->
              <-------------   SACK (CTSN = 1)
                                   At this point, lowest outstanding is 2.

DATA (TSN = 5)  ------------->
              <-------------   SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 2)
              <------------    SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 2, GAP-START = 4, END = 4)
DATA (TSN = 6) -------------->
              <------------    SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 2, GAP-START = 4, END = 5)

DATA (TSN = 2)  -(fast rtx, lost)-->
    Since we are doing fast rtx for lowest outstanding, restart the T3 timer
    giving this chunk a chance to be acked.

DATA (TSN = 7) ------------>
              <-------------   SACK (CTSN = 1, GAP-START = 2, GAP-ENT = 2, GAP-START = 4, END = 6)

DATA (TSN = 4) -(fast rtx) ---->
    At this point since TSN 2 is still the lowest outstanding, we do NOTrestart
    the T3 timer.


> If not, fast retransmit TSN1 or TSN5 or the other does not need restart 
> the T3-rtx?

Does the above example clarify?

-vlad
