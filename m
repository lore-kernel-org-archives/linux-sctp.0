From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 20 Feb 2009 02:39:38 +0000
Subject: Re: [PATCH] sctp: Fix broken RTO-doubling for data retransmits
Message-Id: <499E17EA.7060908@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1235063487-9470-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1235063487-9470-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Vlad Yasevich wrote:
>> Commit faee47cdbfe8d74a1573c2f81ea6dbb08d735be6
>> (sctp: Fix the RTO-doubling on idle-link heartbeats)
>> broke the RTO doubling for data retransmits.  If the
>> heartbeat was sent before the data T3-rtx time, the
>> the RTO will not double upon the T3-rtx expiration.
>> Distingish between the operations by passing an argument
>> to the function.
>>   
> 
> Hi Vlad
> 
> I think we should talk about what the SCTP_CMD_TRANSPORT_RESET and
> SCTP_CMD_HB_TIMER_UPDATE command do.
> 
> SCTP_CMD_TRANSPORT_RESET
> --> sctp_cmd_transport_reset()
> --> sctp_transport_lower_cwnd()
> ... transport->cwnd = XXX if timer expire
> ... partial_bytes_acked = 0;
> --> sctp_do_8_2_transport_strike()
> ... asoc->overall_error_count++;
> ... transport->rto = XXX if not send HB
> 
> SCTP_CMD_HB_TIMER_UPDATE
> --> sctp_cmd_hb_timer_update()
> ... mod_timer(&t->hb_timer, sctp_transport_timeout(t))
> 
> In sctp_sf_do_prm_requestheartbeat(), it used
> SCTP_CMD_TRANSPORT_RESET command, not SCTP_CMD_HB_TIMER_UPDATE,
> so if user request to send HB, the partial_bytes_acked will be clear,
> and the overall_error_count be increased.

I am concerned about partial_bytes_acked, but the error count should be
increased.

> And the heartbeat primitive
> may not send HB, but only mark the transport state to SCTP_INACTIVE.

How?  Once you reach sctp_sf_do_prm_requestheartbeat, you will either
send a HB, or error out with NOMEM.  The transport reset happens after
the HB is sent.

> 
> We user request to send HB immediately:
> - the HB timer will be update, so HB will expires after
> (HB_INTERVAL + RTO +/- 50% * RTO).
> - the overall_error_count should not be increased. Because this is not
> a idle-link heartbeat.

No, the error count should still increase.

> - the cwnd and partial_bytes_acked should not be changed.

This is true.  Because the link is not idle, these 2 things shouldn't happen.

Looks like there is more work to do here.

-vlad

> 
> Is this correct?
> 
> And after the patch I sent, used SCTP_CMD_HB_TIMER_UPDATE instead of
> SCTP_CMD_TRANSPORT_RESET command. The action of idle-link heartbeat
> and user initiated heartbeat are like this.
> 
> idle-link heartbeat:
> 
> Endpoint A                      Endpoint B
>    |
>    | idle
>    |
> HEARTBEAT    ----------->
>    | lower cwnd
>    | overall_error_count++
>    | RTO = RTO * 2
>    | expires HB_INTERVAL + RTO +/- 50% * RTO
> HEARTBEAT    ----------->
>    | lower cwnd
>    | overall_error_count++
>    | RTO = RTO * 2
>    | expires HB_INTERVAL + RTO +/- 50% * RTO
> 
> user initiated heartbeat
> 
> Endpoint A                      Endpoint B
>    |
>    |
>    |
> HEARTBEAT    ----------->     (*) first HB
>    |
>    | reset hb_timer, not update RTO
>    |
> HEARTBEAT    ----------->
>    | lower cwnd
>    | overall_error_count++
>    | RTO = RTO * 2
>    | expires HB_INTERVAL + RTO +/- 50% * RTO
> 
> 
> The different between two is that only reset the HB timer, the
> other increased overall_error_count and lower cwnd. I agree with
> reset the HB timer.
> 
> Regards.
> 
>> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
>> ---
>>  net/sctp/sm_sideeffect.c |   10 ++++++----
>>  1 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
>> index 0146cfb..4ac6163 100644
>> --- a/net/sctp/sm_sideeffect.c
>> +++ b/net/sctp/sm_sideeffect.c
>> @@ -434,7 +434,8 @@ sctp_timer_event_t *sctp_timer_events[SCTP_NUM_TIMEOUT_TYPES] = {
>>   *
>>   */
>>  static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
>> -					 struct sctp_transport *transport)
>> +					 struct sctp_transport *transport,
>> +					 int is_hb)
>>  {
>>  	/* The check for association's overall error counter exceeding the
>>  	 * threshold is done in the state function.
>> @@ -466,7 +467,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
>>  	 * The first unacknowleged HB triggers it.  We do this with a flag
>>  	 * that indicates that we have an outstanding HB.
>>  	 */
>> -	if (transport->hb_sent) {
>> +	if (!is_hb || transport->hb_sent) {
>>  		transport->last_rto = transport->rto;
>>  		transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
>>  	}
>> @@ -667,7 +668,7 @@ static void sctp_cmd_transport_reset(sctp_cmd_seq_t *cmds,
>>  	sctp_transport_lower_cwnd(t, SCTP_LOWER_CWND_INACTIVE);
>>  
>>  	/* Mark one strike against a transport.  */
>> -	sctp_do_8_2_transport_strike(asoc, t);
>> +	sctp_do_8_2_transport_strike(asoc, t, 1);
>>  
>>  	t->hb_sent = 1;
>>  }
>> @@ -1459,7 +1460,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
>>  
>>  		case SCTP_CMD_STRIKE:
>>  			/* Mark one strike against a transport.  */
>> -			sctp_do_8_2_transport_strike(asoc, cmd->obj.transport);
>> +			sctp_do_8_2_transport_strike(asoc, cmd->obj.transport,
>> +						    0);
>>  			break;
>>  
>>  		case SCTP_CMD_TRANSPORT_RESET:
>>   
> 
> 

