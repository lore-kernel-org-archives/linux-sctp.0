From: Sun Paul <paulrbk@gmail.com>
Date: Fri, 13 Jan 2017 03:27:08 +0000
Subject: Re: Problem on SCTP
Message-Id: <CAFXGftJe=ooG8sQR+NmMcVMNthvu6qtaH9YBPBFJMM+Ax-4UOA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170106123711.GA15139@hmsreliant.think-freely.org>
 <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
 <CAFXGftJkR75OjWOKZhF_jgv_W1ysFky-msMj1asCU5MQMFE43w@mail.gmail.com>
 <20170109122408.GA20973@hmswarspite.think-freely.org> <CAFXGftLY1ywdRj79RMHW57oLa9_HNEEcUYRAiM=zs6YHHGVFzw@mail.gmail.com>
 <20170109191823.GC20973@hmswarspite.think-freely.org> <CAFXGft+C9Wf0Xgq0n-cw+ffeq-maDWoP=6dUV0c=zt80ugZLJQ@mail.gmail.com>
 <20170110143351.GA10195@hmswarspite.think-freely.org> <CAFXGft+XA_r+R2hxJU2qYvFJbS+avQ7TTOQ50xkTXm8q8KpDtg@mail.gmail.com>
 <20170111125708.GA1518@hmswarspite.think-freely.org> <CAFXGftLSFgPpxD6Oak8h1Y5y11-zXWLj0v4ziMFkjX8eZ4ZJgA@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025F9FD@AcuExch.aculab.com> <4163FC71-3A20-4484-8CDC-FA22D4FA72CF@lurchi.franken.de>
In-Reply-To: <4163FC71-3A20-4484-8CDC-FA22D4FA72CF@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Cc: David Laight <David.Laight@aculab.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi All

below is the packet trace in text format.


Packet received (From client to router)  [ Source IP: 192.168.206.83,
Destination IP: 192.168.206.65. the IPv4 address parameter is
192.168.206.83 and 192.168.1.83 ]
======================

No.     Time                          Source                SPort
Destination           Protocol DPort  Length Info
                                      DSCP
      1 2017-01-06 08:52:49.662142    192.168.206.83        50001
192.168.206.65        SCTP     3868   98     INIT
                                      CS0

Frame 1: 98 bytes on wire (784 bits), 98 bytes captured (784 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Jan  6, 2017 16:52:49.662142000 Malay Peninsula Standard Time
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1483692769.662142000 seconds
    [Time delta from previous captured frame: 0.000000000 seconds]
    [Time delta from previous displayed frame: 0.000000000 seconds]
    [Time since reference or first frame: 0.000000000 seconds]
    Frame Number: 1
    Frame Length: 98 bytes (784 bits)
    Capture Length: 98 bytes (784 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:ip:sctp]
Ethernet II, Src: RealtekU_54:81:87 (52:54:00:54:81:87), Dst:
Vmware_81:41:6b (00:50:56:81:41:6b)
    Destination: Vmware_81:41:6b (00:50:56:81:41:6b)
        Address: Vmware_81:41:6b (00:50:56:81:41:6b)
        .... ..0. .... .... .... .... = LG bit: Globally unique
address (factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Source: RealtekU_54:81:87 (52:54:00:54:81:87)
        Address: RealtekU_54:81:87 (52:54:00:54:81:87)
        .... ..1. .... .... .... .... = LG bit: Locally administered
address (this is NOT the factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 192.168.206.83, Dst: 192.168.206.65
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x02 (DSCP: CS0, ECN: ECT(0))
        0000 00.. = Differentiated Services Codepoint: Default (0)
        .... ..10 = Explicit Congestion Notification: ECN-Capable
Transport codepoint '10' (2)
    Total Length: 84
    Identification: 0x0000 (0)
    Flags: 0x02 (Don't Fragment)
        0... .... = Reserved bit: Not set
        .1.. .... = Don't fragment: Set
        ..0. .... = More fragments: Not set
    Fragment offset: 0
    Time to live: 64
    Protocol: SCTP (132)
    Header checksum: 0x1c3e [validation disabled]
        [Good: False]
        [Bad: False]
    Source: 192.168.206.83
    Destination: 192.168.206.65
    [Source GeoIP: Unknown]
    [Destination GeoIP: Unknown]
Stream Control Transmission Protocol, Src Port: 50001 (50001), Dst
Port: 3868 (3868)
    Source port: 50001
    Destination port: 3868
    Verification tag: 0x00000000
    [Assocation index: 0]
    Checksum: 0xbaea49e5 (not verified)
    INIT chunk (Outbound streams: 3000, inbound streams: 3000)
        Chunk type: INIT (1)
            0... .... = Bit: Stop processing of the packet
            .0.. .... = Bit: Do not report
        Chunk flags: 0x00
        Chunk length: 52
        Initiate tag: 0xe79f40cb
        Advertised receiver window credit (a_rwnd): 62464
        Number of outbound streams: 3000
        Number of inbound streams: 3000
        Initial TSN: 176990880
        IPv4 address parameter (Address: 192.168.206.83)
            Parameter type: IPv4 address (0x0005)
                0... .... .... .... = Bit: Stop processing of chunk
                .0.. .... .... .... = Bit: Do not report
            Parameter length: 8
            IP Version 4 address: 192.168.206.83
        IPv4 address parameter (Address: 192.168.1.83)
            Parameter type: IPv4 address (0x0005)
                0... .... .... .... = Bit: Stop processing of chunk
                .0.. .... .... .... = Bit: Do not report
            Parameter length: 8
            IP Version 4 address: 192.168.1.83
        Supported address types parameter (Supported types: IPv6, IPv4)
            Parameter type: Supported address types (0x000c)
                0... .... .... .... = Bit: Stop processing of chunk
                .0.. .... .... .... = Bit: Do not report
            Parameter length: 8
            Supported address type: IPv6 address (6)
            Supported address type: IPv4 address (5)
        ECN parameter
            Parameter type: ECN (0x8000)
                1... .... .... .... = Bit: Skip parameter and continue
processing of the chunk
                .0.. .... .... .... = Bit: Do not report
            Parameter length: 4
        Forward TSN supported parameter
            Parameter type: Forward TSN supported (0xc000)
                1... .... .... .... = Bit: Skip parameter and continue
processing of the chunk
                .1.. .... .... .... = Bit: Do report
            Parameter length: 4

On Thu, Jan 12, 2017 at 6:53 PM, Michael Tuexen
<Michael.Tuexen@lurchi.franken.de> wrote:
>> On 12 Jan 2017, at 10:51, David Laight <David.Laight@ACULAB.COM> wrote:
>>
>> From: Sun Paul [mailto:paulrbk@gmail.com]
>>> Sent: 12 January 2017 09:31
>>> Let me clear the understanding. below is the flow.
>>>
>>> 1. Client sends to Linux Router: 192.168.206.83 -> 192.168.206.56,
>>> 2. Linux router sends to SERVER where the source IP is unchanged:
>>> 192.168.206.83 -> 192.168.206.66
>>>
>>> My question here is why SERVER cannot response this INIT chunk?
>>
>> Probably because the IP addresses embedded in the SCTP packet
>> don't match the ones in the IP header.
> I don't know if it matters on the linux implementation, but it shouldn't.
> An SCTP endpoint should consider the source address of the packet containing
> the INIT chunk and all the addresses listed in the INIT chunk as valid peer
> addresses.
>
> Could we get a .pcap file of the packet containing the INIT chunk captured
> at the server? I would expect an INIT-ACK or and ABORT. If that is not sent,
> the checksum was wrong or some kind of packet filtering is active on the
> server...
>
> Best regards
> Michael
>>
>>       David
>>
>> N‹§ēæėrļ›yúčšØbēXŽķĮ§vØ^–)Þš{.nĮ+‰·ĨŠ{ąąËiŠ{ayš Ę‡Ú™ë,j ­ĒfĢĒ·hš‹āzđ ŪwĨĒļ Ē·Ķj:+v‰ĻŠwčjØmķŸĸū Ŧ‘ęįzZ+ƒųšŽŠÝĒj" ú!
>
