From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 00:34:16 +0000
Subject: Re: [RFC PATCH v3] sctp: fix the sendmsg() flag SCTP_EOF to comply
Message-Id: <4C084A08.3020208@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C05C996.5060708@cn.fujitsu.com>
In-Reply-To: <4C05C996.5060708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> Wei Yongjun wrote:
>   
>>> Wei Yongjun wrote:
>>>   
>>>       
>>> Interesting approach and I applaud for creativity, but it doesn't work if there is
>>> data loss.
>>>
>>> I see only one way out of this mess and that's to remove the SHUTDOWN_PENDING
>>> state and make that a modifier/flag that can be set on other states <= ESTABLISHED.
>>>   
>>>       
>> Do you mean we should support multi send() with EOF flag?
>>
>> send(msg, SCTP_EOF);
>> send(msg, SCTP_EOF);
>> ...
>>     
> As long as they are for different associations.  SCTP_EOF is a way to do
> shutdown() for 1-to-many sockets.  If the second send() is for the same
> association, it should fail.
>
> I just realized that this might actually work....  Autoclose timer isn't started
> until association is up, so that takes care of any INIT retransmissions.
> And the autoclose will do the right thing by entering SHUTDOWN_PENDING and
> retransmitting DATA as needed.
>
> The only thing still missing is something that prevents the above multiple send
> scenario.
>
> That's why I though that removing the SHUTDOWN_PENDING state and changing it into
> a bit/flag would work.  This way, sends would return failure because even though
> we may be in COOKIE_WAIT, if the SHUTDOWN_PENDING flag is set, further writes are
> disallowed.
>
> With this code, multiple writes with EOF for the same association will work,
> if the init process takes a long time (due to retransmissions or long rto).
>   

I got it, thank you very much.

Wei Yongjun

> -vlad
>
>   
>>     
>>> In other words, if the user has queued up data to the association, even if it is
>>> not established, we should exhaust all retransmits before failing.
>>>   
>>>       
>> shutdown after all the outdata is acked?
>>
>>     
>>> -vlad
>>>
>>>   
>>>       
>>>>  	/* If we are already past ASSOCIATE, the lower
>>>>  	 * layers are responsible for association cleanup.
>>>>  	 */
>>>>     
>>>>         
>>>   
>>>       
>>     
>
>   
