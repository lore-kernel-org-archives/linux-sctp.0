From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Mon, 17 Feb 2014 17:59:20 +0000
Subject: Re: [PATCH lksctp-tools] Remove dependency to implementation-specific a_rwnd behavior
Message-Id: <53024DF8.1080203@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52F72A2F.2070705@nsn.com>
In-Reply-To: <52F72A2F.2070705@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

On 02/17/2014 02:22 PM, ext Daniel Borkmann wrote:
> On 02/09/2014 08:11 AM, Matija Glavinic Pecotic wrote:
>> test_timetolive and test_sctp_sendrecvmsq take advantage of the following lksctp
>> characteristic:
>>
>>   - SO_RECVBUF being set prior association is established will control initially
>>     advertised rwnd
>>   - Modifying SO_RECVBUF later will keep maximum rwnd at the initial value which
>>     is defined at the association startup
>>
>> Test cases use this fact in order to initially advertise small rwnd, increase
>> buffer later, but keeping the initial rwnd as maximum one. However, we may at
>> later time increase buffer, and implementation may advertise this to the
>> partner. RFC4960 only forbids decrease of the buffer space:
>>
>>     Advertised Receiver Window Credit (a_rwnd): 32 bits (unsigned
>>     integer)
>>
>>        This value represents the dedicated buffer space, in number of
>>        bytes, the sender of the INIT has reserved in association with
>>        this window.  During the life of the association, this buffer
>>        space SHOULD NOT be lessened (i.e., dedicated buffers taken away
>>        from this association); however, an endpoint MAY change the value
>>        of a_rwnd it sends in SACK chunks.
>>
>> Having in mind that rwnd reflects free space in receiver's buffer,
>> implementation may advertise new value, and therefore test case should not
>> rely on above defined behavior. There is no impact on functional behavior of
>> test cases due to this change.
>>
>> This change was done in course of '[PATCH v2] net: sctp: Fix a_rwnd/rwnd
>> management to reflect real state of the receiver's buffer', as with this patch
>> behavior is changed from described to rwnd reflecting real buffer state.
> 
> Before applying this, does that break user space? I had a test run of
> test_timetolive of the latest net tree and without this patch here,
> test_timetolive is stuck forever; with this patch, it works again.
> Before your kernel change, the test suite passed.

this is correct observation

> So you're saying that the test case is simply implemented wrong by
> "violating" the RFC in the fact that it keeps/resets the old small
> init rwnd along. Hence, these hunks should be removed as it "SHOULD
> NOT" be lessened.

Here is discussed "it may be changed", and in this particular case, it may grow. What test case relies is that initially set rwnd will never change, regardless of the socket buffer change. However, with proposed fair advertisement, if SO_RECVBUF is changed, new buffer size will be reported to the sender in form of increased/decreased maximum rwnd. This makes tc hang, fillmessage being created with size of increased buffer (much more then REALLY_BIG, at least on my machine where rmem_defualt is 160k) and not the original (SMALL_RCVBUF). This will deplete receiver, hang sender on next message, and since everything is done in same thread, receiver never gets opportunity to read.

maximum (and minimum?) rwnd might be clamped to deal with this particular scenario, but I would still propose to go for completely fair advertisement.

>> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
