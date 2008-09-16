From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 16 Sep 2008 09:48:54 +0000
Subject: Re: [PATCH] sctp: Fix to start T5-shutdown-guard timer while enter
Message-Id: <48CF8106.4050008@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48C0837E.3060304@cn.fujitsu.com>
In-Reply-To: <48C0837E.3060304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad:

Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> RFC 4960: Section 9.2
>> The sender of the SHUTDOWN MAY also start an overall guard timer
>> 'T5-shutdown-guard' to bound the overall time for the shutdown
>> sequence.  At the expiration of this timer, the sender SHOULD abort
>> the association by sending an ABORT chunk.  If the 'T5-shutdown-
>> guard' timer is used, it SHOULD be set to the recommended value of 5
>> times 'RTO.Max'.
>>
>> The timer 'T5-shutdown-guard' is used to counter the overall time
>> for shutdown sequence, and it's start by the sender of the SHUTDOWN.
>> So timer 'T5-shutdown-guard' should be start when we send the first
>> SHUTDOWN chunk and enter the SHUTDOWN-SENT state, not start when we
>> receipt of the SHUTDOWN primitive and enter SHUTDOWN-PENDING state.
>>
>> If 'T5-shutdown-guard' timer is start at SHUTDOWN-PENDING state, the
>> association may be ABORT while data is still transmitting.
>>     
>
> Hi Wei
>
> You missed the autoclose case which would have been very easy to test
> had you run the regressions test from the lksctp-tools package.
>
> In the future please run those tests and feel free to add tests there
> to enhance our test matrix.
>
> I'll fix it up this time.  Thanks
>   
  Sorry for my stupid mistake. I'll do the regressions test next time 
when I make patchs.

  I had a look at all the place used 
SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD, may be following lines in 
sctp_sf_shutdown_pending_abort() and 
sctp_sf_shutdown_pending_prm_abort() become useless after this patch:(T5 
time is invalid and not start in SHUTDOWN_PENDING state)
------------------------------------------------------
2080         sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
2081                         SCTP_TO(SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD));
------------------------------------------------------
 So, If you want to fix this patch, you may also need to delete those 
useless codes.

 Thanks.


