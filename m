From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 20 Feb 2009 02:43:53 +0000
Subject: Re: [PATCH] sctp: Fix broken RTO-doubling for data retransmits
Message-Id: <499E18E9.4000205@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1235063487-9470-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1235063487-9470-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>> Vlad Yasevich wrote:
>>> Commit faee47cdbfe8d74a1573c2f81ea6dbb08d735be6
>>> (sctp: Fix the RTO-doubling on idle-link heartbeats)
>>> broke the RTO doubling for data retransmits.  If the
>>> heartbeat was sent before the data T3-rtx time, the
>>> the RTO will not double upon the T3-rtx expiration.
>>> Distingish between the operations by passing an argument
>>> to the function.
>>>   
>> Hi Vlad
>>
>> I think we should talk about what the SCTP_CMD_TRANSPORT_RESET and
>> SCTP_CMD_HB_TIMER_UPDATE command do.
>>
>> SCTP_CMD_TRANSPORT_RESET
>> --> sctp_cmd_transport_reset()
>> --> sctp_transport_lower_cwnd()
>> ... transport->cwnd = XXX if timer expire
>> ... partial_bytes_acked = 0;
>> --> sctp_do_8_2_transport_strike()
>> ... asoc->overall_error_count++;
>> ... transport->rto = XXX if not send HB
>>
>> SCTP_CMD_HB_TIMER_UPDATE
>> --> sctp_cmd_hb_timer_update()
>> ... mod_timer(&t->hb_timer, sctp_transport_timeout(t))
>>
>> In sctp_sf_do_prm_requestheartbeat(), it used
>> SCTP_CMD_TRANSPORT_RESET command, not SCTP_CMD_HB_TIMER_UPDATE,
>> so if user request to send HB, the partial_bytes_acked will be clear,
>> and the overall_error_count be increased.
> 
> I am concerned about partial_bytes_acked, but the error count should be
> increased.
> 
>> And the heartbeat primitive
>> may not send HB, but only mark the transport state to SCTP_INACTIVE.
> 
> How?  Once you reach sctp_sf_do_prm_requestheartbeat, you will either
> send a HB, or error out with NOMEM.  The transport reset happens after
> the HB is sent.
> 
>> We user request to send HB immediately:
>> - the HB timer will be update, so HB will expires after
>> (HB_INTERVAL + RTO +/- 50% * RTO).
>> - the overall_error_count should not be increased. Because this is not
>> a idle-link heartbeat.
> 
> No, the error count should still increase.
> 
>> - the cwnd and partial_bytes_acked should not be changed.
> 
> This is true.  Because the link is not idle, these 2 things shouldn't happen.
> 
> Looks like there is more work to do here.
> 
> -vlad
> 
>> Is this correct?

Oh, forgot to address the state bellow.

>>
>> And after the patch I sent, used SCTP_CMD_HB_TIMER_UPDATE instead of
>> SCTP_CMD_TRANSPORT_RESET command. The action of idle-link heartbeat
>> and user initiated heartbeat are like this.
>>
>> idle-link heartbeat:
>>
>> Endpoint A                      Endpoint B
>>    |
>>    | idle
>>    |
>> HEARTBEAT    ----------->
>>    | lower cwnd
>>    | overall_error_count++
>>    | RTO = RTO * 2

no, in this case, RTO should not be doubled, since we did not have an
outstanding HB that was not acknowleged.

>>    | expires HB_INTERVAL + RTO +/- 50% * RTO
>> HEARTBEAT    ----------->
>>    | lower cwnd
>>    | overall_error_count++
>>    | RTO = RTO * 2
>>    | expires HB_INTERVAL + RTO +/- 50% * RTO

In this case, RTO doubles correctly.

>>
>> user initiated heartbeat
>>
>> Endpoint A                      Endpoint B
>>    |
>>    |
>>    |
>> HEARTBEAT    ----------->     (*) first HB
>>    |
>>    | reset hb_timer, not update RTO

We also need to update the error count.

>>    |
>> HEARTBEAT    ----------->
>>    | lower cwnd
>>    | overall_error_count++
>>    | RTO = RTO * 2
>>    | expires HB_INTERVAL + RTO +/- 50% * RTO

Yes, RTO doubles.

>>
>>
>> The different between two is that only reset the HB timer, the
>> other increased overall_error_count and lower cwnd. I agree with
>> reset the HB timer.
>>

It also needs to count the HB towards the error count.  They have count
the same way as if there was a timeout prior to the first HB sent.

-vlad
