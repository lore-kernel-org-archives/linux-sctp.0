From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 20 Feb 2009 03:25:32 +0000
Subject: Re: [PATCH 4/4] sctp: heartbeats exceed maximum retransmssion limit
Message-Id: <499E22AC.40409@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <499D2750.7030606@cn.fujitsu.com>
In-Reply-To: <499D2750.7030606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> Vlad Yasevich wrote:
>>     
>>> Wei Yongjun wrote:
>>>   
>>>       
>>>> The number of HEARTBEAT chunks that an association may transmit is
>>>> limited by Association.Max.Retrans count; however, the code allows
>>>> us to send one extra heartbeat.
>>>>
>>>> This patch limits the number of heartbeats to the maximum count.
>>>>
>>>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>>>> ---
>>>>  net/sctp/sm_statefuns.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>>>> index 3e7f6d2..ac7bf6d 100644
>>>> --- a/net/sctp/sm_statefuns.c
>>>> +++ b/net/sctp/sm_statefuns.c
>>>> @@ -962,7 +962,7 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
>>>>  {
>>>>  	struct sctp_transport *transport = (struct sctp_transport *) arg;
>>>>  
>>>> -	if (asoc->overall_error_count > asoc->max_retrans) {
>>>> +	if (asoc->overall_error_count >= asoc->max_retrans) {
>>>>  		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
>>>>  				SCTP_ERROR(ETIMEDOUT));
>>>>  		/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
>>>>     
>>>>         
>>> Hi Wei
>>>
>>> Here is the spec:
>>>
>>>    The endpoint should increment the respective error counter of the
>>>    destination transport address each time a HEARTBEAT is sent to that
>>>    address and not acknowledged within one RTO.
>>>
>>>    When the value of this counter reaches the protocol parameter
>>>    'Path.Max.Retrans', the endpoint should mark the corresponding
>>>    destination address as inactive...
>>>
>>> According to this, only unacknowledged HB count as errors.  The very
>>> first HB we sent doest count as an error until the RTO expires.  So
>>> the >= is the correct test here as we are really counting the number
>>> of timeouts with reacknowledgment.
>>>   
>>>       
>> Hi vlad
>>
>> There are two way to send HB. One is idle-like HB which is send after HB
>> timer expires, the other is user initiated heartbeat.
>>
>> Now the user initiated heartbeat is retranmited 10 times after send the
>> first one, this is correctly. But the timer expires HB is sent 11 times,
>> which means HB timeout 12 times.
>>     
>
> Yes, that correct.  In the idle-link case, you have to discount the first
> timeout and the first HB.
>   

Oh, maybe I mistaked for retranmit and unacknowledged HEARTBEAT.
The spec talk about the HEARTBEAT as unacknowledged HEARTBEAT. Such as:

8.1.  Endpoint Failure Detection
   An endpoint shall keep a counter on the total number of consecutive
   retransmissions to its peer (this includes retransmissions to all the
   destination transport addresses of the peer if it is multi-homed),
   *including unacknowledged HEARTBEAT chunks*.

8.2.  Path Failure Detection
   Each time the T3-rtx timer expires on any address, or when a
   *HEARTBEAT sent to an idle address is not acknowledged* within an RTO,
   the error counter of that destination address will be incremented.


So in my head the idle-link case is treat as unacknowledged HEARTBEAT, and
user initiated heartbeat is treat as retranmit. The idle_link case is 11
unacknowledged HEARTBEAT, and 10 retranmit, and also user-triggered case.

If overall_error_count count the retranmit, this patch is not need.


Regards

> The way we implement error counting is we increment the error _every_ time
> we send a HB, regardless of whether it's an idle-link detection, or user
> triggered.  Once the HB is acknowledged, we reset the error count, but if
> it times out, we send another HB and bump the error count.
>
> Let's assume that the user set the Path.Max.Retrans to 1.  Let's see
> what should happen in both cases:
>
> user-triggered:
> 	1) send HB.
> 	2) error = 1
> 	3) start timer
> 	4) timeout
> 		4a) send HB
> 		4b) error = 2
> 		4c) start timer
> 	5) timeout
> 		5a) error out.
>
> So we sent 1 HB, and 1 retransmission.
>
> idle_link:
> 	1) timeout
> 		1a) send HB
> 		1b) error = 1
> 		1c) start timer
>    	2) timeout
> 		2a) send HB
> 		2b) error = 2
> 		2c) start timer
> 	3) timeout
> 		3a) error out
>
> So we sent 1 HB, and 1 retransmission.
>
> In both cases we sent 2 HB chunks.  Essentially, we can not count the first HB
> we sent toward the max.path.retrans limit.
>
> If this is not what you are seeing, then we have problem.
>   


