From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 14 Oct 2008 00:30:52 +0000
Subject: Re: [Lksctp-developers] [PATCH] sctp: Fix to handle SHUTDOWN in	SHUTDOWN-PENDING
Message-Id: <48F3E83C.1090605@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48EF54F4.2000507@hp.com>
In-Reply-To: <48EF54F4.2000507@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Michael T=FCxen wrote:
> Hi Wei,
>
> this is an RFC 4960 issue.
> Can you bring this up on tsvwg@ietf.org?

I had posted a query to tsvwg@ietf.org. Link is:

http://www.ietf.org/mail-archive/web/tsvwg/current/msg08653.html

>
> Thanks a lot.
>
> Best regards
> Michael
>
> On Oct 13, 2008, at 5:25 AM, Wei Yongjun wrote:
>
>> Hi Vlad:
>>>> Hi Wei
>>>>
>>>> If I can't take that without a patch that processes SHUTDOWN chunks in
>>>> SHUTDOWN_RECEIVED state.
>>>>
>>>> The problem is that if B in your example has more data to send,
>>>> it will ignore subsequent SHUTDOWN chunks.  If A uses only SHUTDOWNS
>>>> to acknowledge data, then this would results us ignoring acks and
>>>> retransmitting and eventually ABORTING the association.
>>>>
>>>>
>>>
>>> I think the current kernel has the same problem when process=20
>>> SHUTDOWN in
>>> ESTABLISHED state:
>>>
>>> Endpoint A                       Endpoint B       ULP
>>> (ESTABLISHED)                    (ESTABLISHED)
>>>
>>>               <-----------      DATA (TSN=3D1)
>>>               <-----------      DATA (TSN=3D2)
>>>  SHUTDOWN(TSN=3D1) ------------>  enter SHUTDOWN-RECEIVED state
>>>               <-----------      DATA (TSN=3D2)
>>>  SACK(TSN=3D2)  ------------>
>>>  SHUTDOWN(TSN=3D2) ------------>  discard
>>>
>>> I have not test it, and check it later.
>>>
>>> RFC4960 said:
>>>   Once an endpoint has reached the SHUTDOWN-RECEIVED state, it MUST NOT
>>>   send a SHUTDOWN in *response to a ULP request*, and should *discard*
>>>   subsequent SHUTDOWN chunks.
>>>
>>>
>>
>> The old RFC 2960 said:
>>   While in SHUTDOWN-SENT state, the SHUTDOWN sender MUST immediately
>>   respond to each received packet containing one or more DATA chunk(s)
>>   *with a SACK*, a SHUTDOWN chunk, and restart the T2-shutdown timer. If
>>   it has no more outstanding DATA chunks, the SHUTDOWN receiver shall
>>   send a SHUTDOWN ACK and start a T2-shutdown timer of its own,
>>   entering the SHUTDOWN-ACK-SENT state.  If the timer expires, the
>>   endpoint must re-send the SHUTDOWN ACK.
>>
>> The old RFC2960 force to send a sack to the DATA sender, so after
>> received the
>> sack, the assoc can be shutdown correctly.
>>
>> Endpoint A                       Endpoint B       ULP
>> (ESTABLISHED)                    (ESTABLISHED)
>>
>>               <-----------      DATA (TSN=3D1)
>>               <-----------      DATA (TSN=3D2)
>>  SHUTDOWN(TSN=3D1) ------------>  enter SHUTDOWN-RECEIVED state
>>               <-----------      DATA (TSN=3D2)
>>  SHUTDOWN(TSN=3D2) ------------>  discard
>>  SACK(TSN=3D2)  ------------>     accept
>>               <-----------      SHUTDOWN-ACK
>>
>>
>> SACK in SHUTDOWN-RECEIVED state will cause a SHUTDOWN-ACK be sent, if
>> the SACKcan ack all of the outstanding DATA chunks.
>>
>> But new RFC 4960 said:
>>   While in the SHUTDOWN-SENT state, the SHUTDOWN sender MUST
>>   immediately respond to each received packet containing one or more
>>   DATA chunks with *a SHUTDOWN chunk* and restart the T2-shutdown timer.
>>   If a SHUTDOWN chunk by itself cannot acknowledge all of the received
>>   DATA chunks (i.e., there are TSNs that can be acknowledged that are
>>   larger than the cumulative TSN, and thus gaps exist in the TSN
>>   sequence), or if duplicate TSNs have been received, then a SACK chunk
>>   MUST also be sent.
>>
>> This maybe wrong since the SACK will not send if the SHUTDOWN chunk can
>> acknowledge all of the received DATA chunks, and SHUTDOWN chunk is=20
>> discard
>> in SHUTDOWN-RECEIVED state.
>>
>> We need to fix RFC4960, either force to send SACK in SHUTDOWN-SENT state
>> or accept the SHUTDOWN in SHUTDOWN-RECEIVED state. (The current code
>> is force send SACK)
>>
>>
>>>
>>>
>>>> -vlad
>>>>
>>>> Wei Yongjun wrote:
>>>>
>>>>
>>>>> If SHUTDOWN is received in SHUTDOWN-PENDING state, enpoint should=20
>>>>> enter
>>>>> the SHUTDOWN-RECEIVED state and check the Cumulative TSN Ack field of
>>>>> the SHUTDOWN chunk (RFC 4960 Section 9.2). If the SHUTDOWN chunk can
>>>>> acknowledge all of the send DATA chunks, SHUTDOWN-ACK should be sent.
>>>>>
>>>>> But now endpoint just silently discarded the SHUTDOWN chunk.
>>>>>
>>>>> SHUTDOWN received in SHUTDOWN-PENDING state can happend when the last
>>>>> SACK is lost by network, or the SHUTDOWN chunk can acknowledge all of
>>>>> the received DATA chunks. The packet sequence(SACK lost) is like=20
>>>>> this:
>>>>>
>>>>> Endpoint A                       Endpoint B       ULP
>>>>> (ESTABLISHED)                    (ESTABLISHED)
>>>>>
>>>>>               <-----------      DATA
>>>>>                                             <--- shutdown
>>>>>                                 Enter SHUTDOWN-PENDING state
>>>>>  SACK         ----lost---->
>>>>>
>>>>>  SHUTDOWN(*1) ------------>
>>>>>
>>>>>               <-----------      SHUTDOWN-ACK
>>>>>
>>>>> (*1) silently discarded now.
>>>>>
>>>>> This patch fix to handle SHUTDOWN in SHUTDOWN-PENDING state as the=20
>>>>> same
>>>>> as ESTABLISHED state.
>>>>>

