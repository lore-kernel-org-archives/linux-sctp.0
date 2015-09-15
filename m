From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 15 Sep 2015 18:10:07 +0000
Subject: Re: lksctp-tools:sctp_test fails when not using sock_stream
Message-Id: <55F85EFF.3060404@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
In-Reply-To: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 09/10/2015 03:07 AM, kunapaneni prashanth wrote:
> Hi Vlad/Marcelo,
>  Thank you for the response.
> 
>  I am using kernel 3.10.0-123.20.1.el7.x86_64.
> 
>  I should give bit more details about my setup. My hosts H1 and H2 use
> special ethernet adapters which run openvswitch. Due to this, i
> believe there is initially bit more latency when connection is being
> established. I checked the packets and packets are delivered to other
> side without any errors.
> 
>  i am new to sctp, so i am not exactly sure how kernel part of sctp works.
> 
> While testing case 1 mentioned in my previous mail.
> 
> In Server side i see following:
> ==========> 
> [root@localhost tmp]# sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
> 
> remote:addr=5.5.5.8, port$241, family=2
> local:addr=5.5.5.5, port$240, family=2
> seed = 1441868236
> 
> Starting tests...
>     socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3
>     bind(sk=3, [a:5.5.5.5,p:24240])  --  attempt 1/10
>     listen(sk=3,backlog0)
> Server: Receiving packets.
>     recvmsg(sk=3)
> 
> Notification: SCTP_ASSOC_CHANGE(COMMUNICATION_UP)
>         (assoc_change: state=0, error=0, instr outstr)
>     recvmsg(sk=3) Data 1 bytes. First 1 bytes: <empty> text[0]=0
>     recvmsg(sk=3) Notification: SCTP_ASSOC_CHANGE(COMMUNICATION_LOST)
>         (assoc_change: state=1, error=0, instr=0 outstr=0)
>     recvmsg(sk=3)
> 

Could you also provide the client side output as well..

Thanks
-vlad


> 
> TCPDUMP on Server side
> -------------------------------------
> 
> [root@localhost tmp]# tcpdump -i oct0
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on oct0, link-type EN10MB (Ethernet), capture size 65535 bytes
> 12:33:57.134221 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [INIT]
> [init tag: 3460584308] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN:
> 2697986036]
> 12:33:57.135112 IP 5.5.5.5.24240 > 5.5.5.8.24241: sctp (1) [INIT ACK]
> [init tag: 3286358519] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN:
> 942498333]
> 12:33:57.135702 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [COOKIE
> ECHO] , (2) [DATA] (U)(B)(E) [TSN: 2697986036] [SID: 0] [SSEQ 0] [PPID
> 0x122c861b]
> 12:33:57.136079 IP 5.5.5.5.24240 > 5.5.5.8.24241: sctp (1) [COOKIE
> ACK] , (2) [SACK] [cum ack 2697986036] [a_rwnd 106495] [#gap acks 0]
> [#dup tsns 0]
> 12:33:57.136415 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [ABORT]
> 
> 
> 
> 
> 
> 
> I  am assuming below is the sequence in Client side.
> ==================>  when using "sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l"
> 
> 1. sctp_test calls sendmsg.
> 2. Kernel initiates a handshake.
> 3. sctp_test sends all the packets and closes the socket before
> handshake is complete.
> 4. Kernel sends a abort packet due to socket close without completing
> the transfer of packets.
> 
> 
> Just to confirm if above theory is correct, i increased the number of
> packets to be sent by sctp_test using following command.
> 
> "sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -x 30"
> 
> I assume in this case, since sctp_test takes more time to send all the
> packets, kernel has enough time to complete the handshake.
> 
> This test passed always.
> 
>  so is the theory that sctp_test is closing socket  too fast  correct?
> 
>  if so, shouldn't the kernel complete the connection initiation,
> transfer packet before closing the connection even when socket close
> is called too fast.
> 
> Thanks,
> Prashanth
> 
> 
> On Thu, Sep 10, 2015 at 2:49 AM, Vlad Yasevich <vyasevich@gmail.com> wrote:
>> On 09/09/2015 04:13 AM, kunapaneni prashanth wrote:
>>> Hi,
>>>  in our setup, i am trying out sctp tests using lksctp tools between
>>> two hosts connected back to back.
>>>
>>> H1(5.5.5.8)  --------------   H2 (5.5.5.5)
>>>
>>>
>>> following are the commands i used.
>>>
>>> Case 1:
>>> ====>>> client:
>>> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s
>>>
>>> server:
>>> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
>>>
>>>
>>> This test case fails, with client sending a abort after INIT/INIT-ACK.
>>>
>>> If i run same test case with "-T" option, it is successful.
>>
>> The test runs fine in my environment.  Which kernel are you using?
>>
>>>
>>> i,e
>>> Case 2:
>>> ====
>>> client:
>>> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -T
>>>
>>> server:
>>> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
>>>
>>>
>>>
>>>
>>> i observed that in case 1, sctp_test never calls "connect", why is it
>>> so? shouldnt a connect be called.
>>>
>>
>> No, the connect is not required when using SOCK_SEQPACKET sockets and
>> that is what the test tries to do.  Forcing it to always connect isn't
>> the right thing.  You need to figure our why you are getting an ABORT.
>>
>> -vlad
>>
>>>
>>>
>>> I modified the code as follows to make sure a connect is issued. After
>>> this everything works fine.
>>>
>>> Please confirm.
>>>
>>> 1386c1386
>>> <         if (socket_type = SOCK_STREAM || connectx_count = 0)
>>> ---
>>>>         if (socket_type = SOCK_STREAM && connectx_count = 0)
>>>
>>>
>>
>>
>>> Thank you,
>>> Prashanth
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

