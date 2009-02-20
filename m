From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 20 Feb 2009 01:30:46 +0000
Subject: Re: [PATCH 4/4] sctp: heartbeats exceed maximum retransmssion limit
Message-Id: <499E07C6.7000904@cn.fujitsu.com>
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
>> The number of HEARTBEAT chunks that an association may transmit is
>> limited by Association.Max.Retrans count; however, the code allows
>> us to send one extra heartbeat.
>>
>> This patch limits the number of heartbeats to the maximum count.
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  net/sctp/sm_statefuns.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
>> index 3e7f6d2..ac7bf6d 100644
>> --- a/net/sctp/sm_statefuns.c
>> +++ b/net/sctp/sm_statefuns.c
>> @@ -962,7 +962,7 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
>>  {
>>  	struct sctp_transport *transport = (struct sctp_transport *) arg;
>>  
>> -	if (asoc->overall_error_count > asoc->max_retrans) {
>> +	if (asoc->overall_error_count >= asoc->max_retrans) {
>>  		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
>>  				SCTP_ERROR(ETIMEDOUT));
>>  		/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
>>     
>
> Hi Wei
>
> Here is the spec:
>
>    The endpoint should increment the respective error counter of the
>    destination transport address each time a HEARTBEAT is sent to that
>    address and not acknowledged within one RTO.
>
>    When the value of this counter reaches the protocol parameter
>    'Path.Max.Retrans', the endpoint should mark the corresponding
>    destination address as inactive...
>
> According to this, only unacknowledged HB count as errors.  The very
> first HB we sent doest count as an error until the RTO expires.  So
> the >= is the correct test here as we are really counting the number
> of timeouts with reacknowledgment.
>   

Hi vlad

There are two way to send HB. One is idle-like HB which is send after HB
timer expires, the other is user initiated heartbeat.

Now the user initiated heartbeat is retranmited 10 times after send the
first one, this is correctly. But the timer expires HB is sent 11 times,
which means HB timeout 12 times.

In the [PATCH 3/4], I changed to not inc the overall_error_count when
send the first HB, so the user initiated heartbeat will retranmited 11
times.

If you disagree with the [PATCH 3/4], this patch need update.

Regards.



