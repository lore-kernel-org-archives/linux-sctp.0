From: kunapaneni prashanth <prask9@gmail.com>
Date: Wed, 16 Sep 2015 08:54:15 +0000
Subject: Re: lksctp-tools:sctp_test fails when not using sock_stream
Message-Id: <CABZU2_QM4tuef2SdVuH20oY=GdeG_nesxCSBG0aHis=DcXG3KA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
In-Reply-To: <CABZU2_R03ZdCkC=YyTGhaM7gegGufkgB+PgBqX=0vt9Zf7qtDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Vlad,
 Client side output is as follows

sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -d 2
remote:addr=3D5.5.5.5, port$240, family=3D2
local:addr=3D5.5.5.8, port$241, family=3D2
seed =3D 1441869106

Starting tests...
    socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3D3
    bind(sk=3D3, [a:5.5.5.8,p:24241])  --  attempt 1/10

Client: Sending packets.(1/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1710682300
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1765869275
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=849299205
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidw5923576
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1177005326
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidX0481799
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1820434279
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=931838640
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1163854356
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidw0096763
Client: Sending packets.(2/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid#513767
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1224970862
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidr1236614
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidq4480381
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1547270326
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1717490031
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1160620866
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=872101
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidh0567177
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1437630606
Client: Sending packets.(3/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=125273689
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1035787573
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1035963077
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=186752879
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1279859637
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1262253125
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=930828640
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=992036574
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1016073615
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1104261184
Client: Sending packets.(4/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1277931395
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidW9272267
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidr2646812
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid!27230601
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1355195843
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1899652138
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidV0228752
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1028146475
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidh4007130
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1724083108
Client: Sending packets.(5/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1798243238
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidp7520898
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=801570323
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid71996205
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1422001279
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid 1357001
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid 89486236
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidC5138498
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid 2229103
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidb2569765
Client: Sending packets.(6/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1872769104
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid27502792
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1658357338
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidv1248533
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidQ4255671
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidy0733327
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid 23501659
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1445084311
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1782769901
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=892091626
Client: Sending packets.(7/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid@1861848
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=913217648
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1471363893
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1124508660
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=892964601
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidg9076089
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=876677150
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1453193353
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1707222564
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1560684280
Client: Sending packets.(8/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1029792814
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1357982154
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=120721530
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1831363137
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1729978359
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1542722810
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid 32720138
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1671980947
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1977861308
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=87465593
Client: Sending packets.(9/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=147067064
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1703146764
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidA4968385
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1805424402
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid16911650
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=929224056
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidD8674081
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=192929661
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid"6824720
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=83960334
Client: Sending packets.(10/10)
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1085021287
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidb8686568
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=997177983
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid@8901532
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1753195228
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1890142584
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1087977621
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidH2388730
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppid=1195852290
    sendmsg(sk=3D3, assoc=3D0)    1 bytes.
      SNDRCV(stream=3D0 flags=3D0x1 ppidd7716537
    close(sk=3D3)


Thank you,
Prashanth

On Tue, Sep 15, 2015 at 11:40 PM, Vlad Yasevich <vyasevich@gmail.com> wrote:
> On 09/10/2015 03:07 AM, kunapaneni prashanth wrote:
>> Hi Vlad/Marcelo,
>>  Thank you for the response.
>>
>>  I am using kernel 3.10.0-123.20.1.el7.x86_64.
>>
>>  I should give bit more details about my setup. My hosts H1 and H2 use
>> special ethernet adapters which run openvswitch. Due to this, i
>> believe there is initially bit more latency when connection is being
>> established. I checked the packets and packets are delivered to other
>> side without any errors.
>>
>>  i am new to sctp, so i am not exactly sure how kernel part of sctp work=
s.
>>
>> While testing case 1 mentioned in my previous mail.
>>
>> In Server side i see following:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>>
>> [root@localhost tmp]# sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 =
-l
>>
>> remote:addr=3D5.5.5.8, port$241, family=3D2
>> local:addr=3D5.5.5.5, port$240, family=3D2
>> seed =3D 1441868236
>>
>> Starting tests...
>>     socket(SOCK_SEQPACKET, IPPROTO_SCTP)  ->  sk=3D3
>>     bind(sk=3D3, [a:5.5.5.5,p:24240])  --  attempt 1/10
>>     listen(sk=3D3,backlog=100)
>> Server: Receiving packets.
>>     recvmsg(sk=3D3)
>>
>> Notification: SCTP_ASSOC_CHANGE(COMMUNICATION_UP)
>>         (assoc_change: state=3D0, error=3D0, instr=10 outstr=10)
>>     recvmsg(sk=3D3) Data 1 bytes. First 1 bytes: <empty> text[0]=3D0
>>     recvmsg(sk=3D3) Notification: SCTP_ASSOC_CHANGE(COMMUNICATION_LOST)
>>         (assoc_change: state=3D1, error=3D0, instr=3D0 outstr=3D0)
>>     recvmsg(sk=3D3)
>>
>
> Could you also provide the client side output as well..
>
> Thanks
> -vlad
>
>
>>
>> TCPDUMP on Server side
>> -------------------------------------
>>
>> [root@localhost tmp]# tcpdump -i oct0
>> tcpdump: verbose output suppressed, use -v or -vv for full protocol deco=
de
>> listening on oct0, link-type EN10MB (Ethernet), capture size 65535 bytes
>> 12:33:57.134221 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [INIT]
>> [init tag: 3460584308] [rwnd: 106496] [OS: 10] [MIS: 65535] [init TSN:
>> 2697986036]
>> 12:33:57.135112 IP 5.5.5.5.24240 > 5.5.5.8.24241: sctp (1) [INIT ACK]
>> [init tag: 3286358519] [rwnd: 106496] [OS: 10] [MIS: 10] [init TSN:
>> 942498333]
>> 12:33:57.135702 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [COOKIE
>> ECHO] , (2) [DATA] (U)(B)(E) [TSN: 2697986036] [SID: 0] [SSEQ 0] [PPID
>> 0x122c861b]
>> 12:33:57.136079 IP 5.5.5.5.24240 > 5.5.5.8.24241: sctp (1) [COOKIE
>> ACK] , (2) [SACK] [cum ack 2697986036] [a_rwnd 106495] [#gap acks 0]
>> [#dup tsns 0]
>> 12:33:57.136415 IP 5.5.5.8.24241 > 5.5.5.5.24240: sctp (1) [ABORT]
>>
>>
>>
>>
>>
>>
>> I  am assuming below is the sequence in Client side.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>>  when using "sc=
tp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l"
>>
>> 1. sctp_test calls sendmsg.
>> 2. Kernel initiates a handshake.
>> 3. sctp_test sends all the packets and closes the socket before
>> handshake is complete.
>> 4. Kernel sends a abort packet due to socket close without completing
>> the transfer of packets.
>>
>>
>> Just to confirm if above theory is correct, i increased the number of
>> packets to be sent by sctp_test using following command.
>>
>> "sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -x 30"
>>
>> I assume in this case, since sctp_test takes more time to send all the
>> packets, kernel has enough time to complete the handshake.
>>
>> This test passed always.
>>
>>  so is the theory that sctp_test is closing socket  too fast  correct?
>>
>>  if so, shouldn't the kernel complete the connection initiation,
>> transfer packet before closing the connection even when socket close
>> is called too fast.
>>
>> Thanks,
>> Prashanth
>>
>>
>> On Thu, Sep 10, 2015 at 2:49 AM, Vlad Yasevich <vyasevich@gmail.com> wro=
te:
>>> On 09/09/2015 04:13 AM, kunapaneni prashanth wrote:
>>>> Hi,
>>>>  in our setup, i am trying out sctp tests using lksctp tools between
>>>> two hosts connected back to back.
>>>>
>>>> H1(5.5.5.8)  --------------   H2 (5.5.5.5)
>>>>
>>>>
>>>> following are the commands i used.
>>>>
>>>> Case 1:
>>>> =3D=3D=3D=3D>>>> client:
>>>> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s
>>>>
>>>> server:
>>>> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
>>>>
>>>>
>>>> This test case fails, with client sending a abort after INIT/INIT-ACK.
>>>>
>>>> If i run same test case with "-T" option, it is successful.
>>>
>>> The test runs fine in my environment.  Which kernel are you using?
>>>
>>>>
>>>> i,e
>>>> Case 2:
>>>> =3D=3D=3D=3D
>>>> client:
>>>> sctp_test -H 5.5.5.8 -P 24241 -h 5.5.5.5 -p 24240 -s -T
>>>>
>>>> server:
>>>> sctp_test -h 5.5.5.8 -p 24241 -H 5.5.5.5 -P 24240 -l
>>>>
>>>>
>>>>
>>>>
>>>> i observed that in case 1, sctp_test never calls "connect", why is it
>>>> so? shouldnt a connect be called.
>>>>
>>>
>>> No, the connect is not required when using SOCK_SEQPACKET sockets and
>>> that is what the test tries to do.  Forcing it to always connect isn't
>>> the right thing.  You need to figure our why you are getting an ABORT.
>>>
>>> -vlad
>>>
>>>>
>>>>
>>>> I modified the code as follows to make sure a connect is issued. After
>>>> this everything works fine.
>>>>
>>>> Please confirm.
>>>>
>>>> 1386c1386
>>>> <         if (socket_type =3D SOCK_STREAM || connectx_count =3D 0)
>>>> ---
>>>>>         if (socket_type =3D SOCK_STREAM && connectx_count =3D 0)
>>>>
>>>>
>>>
>>>
>>>> Thank you,
>>>> Prashanth
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" =
in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>
