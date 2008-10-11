From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 11 Oct 2008 07:26:58 +0000
Subject: Re: [Lksctp-developers] [PATCH] sctp: Fix to handle SHUTDOWN in	SHUTDOWN-PENDING
Message-Id: <48F05542.6060307@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48EF54F4.2000507@hp.com>
In-Reply-To: <48EF54F4.2000507@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad:

> Hi Wei
>
> If I can't take that without a patch that processes SHUTDOWN chunks in
> SHUTDOWN_RECEIVED state.
>
> The problem is that if B in your example has more data to send,
> it will ignore subsequent SHUTDOWN chunks.  If A uses only SHUTDOWNS
> to acknowledge data, then this would results us ignoring acks and
> retransmitting and eventually ABORTING the association.
>   

I think the current kernel has the same problem when process SHUTDOWN in 
ESTABLISHED state:

Endpoint A                       Endpoint B       ULP
(ESTABLISHED)                    (ESTABLISHED)

               <-----------      DATA (TSN=1)
               <-----------      DATA (TSN=2)
  SHUTDOWN(TSN=1) ------------>  enter SHUTDOWN-RECEIVED state
               <-----------      DATA (TSN=2)
  SACK(TSN=2)  ------------>
  SHUTDOWN(TSN=2) ------------>  discard

I have not test it, and check it later.

RFC4960 said:
   Once an endpoint has reached the SHUTDOWN-RECEIVED state, it MUST NOT
   send a SHUTDOWN in *response to a ULP request*, and should *discard*
   subsequent SHUTDOWN chunks.

So maybe the RFC is wrong, and we still need to process the SHUTDOWN 
chunk in
SHUTDOWN-RECEIVED state, or when we received SHUTDOWN, we only enter
SHUTDOWN-RECEIVED state if the TSN can ack all its outstanding DATA chunks.

Wei Yongjun

> -vlad
>
> Wei Yongjun wrote:
>   
>> If SHUTDOWN is received in SHUTDOWN-PENDING state, enpoint should enter
>> the SHUTDOWN-RECEIVED state and check the Cumulative TSN Ack field of
>> the SHUTDOWN chunk (RFC 4960 Section 9.2). If the SHUTDOWN chunk can
>> acknowledge all of the send DATA chunks, SHUTDOWN-ACK should be sent.
>>
>> But now endpoint just silently discarded the SHUTDOWN chunk.
>>
>> SHUTDOWN received in SHUTDOWN-PENDING state can happend when the last
>> SACK is lost by network, or the SHUTDOWN chunk can acknowledge all of
>> the received DATA chunks. The packet sequence(SACK lost) is like this:
>>
>> Endpoint A                       Endpoint B       ULP
>> (ESTABLISHED)                    (ESTABLISHED)
>>
>>                <-----------      DATA
>>                                              <--- shutdown
>>                                  Enter SHUTDOWN-PENDING state
>>   SACK         ----lost---->
>>
>>   SHUTDOWN(*1) ------------>
>>
>>                <-----------      SHUTDOWN-ACK
>>
>>  (*1) silently discarded now.
>>
>> This patch fix to handle SHUTDOWN in SHUTDOWN-PENDING state as the same
>> as ESTABLISHED state.
>>     
