From: Sun Paul <paulrbk@gmail.com>
Date: Wed, 11 Jan 2017 08:39:29 +0000
Subject: Re: Problem on SCTP
Message-Id: <CAFXGft+XA_r+R2hxJU2qYvFJbS+avQ7TTOQ50xkTXm8q8KpDtg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
 <20170106123711.GA15139@hmsreliant.think-freely.org> <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
 <CAFXGftJkR75OjWOKZhF_jgv_W1ysFky-msMj1asCU5MQMFE43w@mail.gmail.com>
 <20170109122408.GA20973@hmswarspite.think-freely.org> <CAFXGftLY1ywdRj79RMHW57oLa9_HNEEcUYRAiM=zs6YHHGVFzw@mail.gmail.com>
 <20170109191823.GC20973@hmswarspite.think-freely.org> <CAFXGft+C9Wf0Xgq0n-cw+ffeq-maDWoP=6dUV0c=zt80ugZLJQ@mail.gmail.com>
 <20170110143351.GA10195@hmswarspite.think-freely.org>
In-Reply-To: <20170110143351.GA10195@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Laight <David.Laight@aculab.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

yes. whenever the INIT packet send to 192.168.206.65, it will forward
to 192.168.206.66. My question is when this packet arrive to
192.168.206.66, why LKSCTP never pass to user level.

On Tue, Jan 10, 2017 at 10:33 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Jan 10, 2017 at 09:30:39AM +0800, Sun Paul wrote:
>> Packet received (From client)
>> ===========
>>
>> No.     Time                          Source                SPort
>> Destination           Protocol DPort  Length Info
>>                                       DSCP
>>       1 2017-01-06 08:52:49.662142    192.168.206.83        50001
>> 192.168.206.65        SCTP     3868   98     INIT
>>                                       CS0
>>
>> Frame 1: 98 bytes on wire (784 bits), 98 bytes captured (784 bits)
>>     Encapsulation type: Ethernet (1)
>>     Arrival Time: Jan  6, 2017 16:52:49.662142000 Malay Peninsula Standard Time
>>     [Time shift for this packet: 0.000000000 seconds]
>>     Epoch Time: 1483692769.662142000 seconds
>>     [Time delta from previous captured frame: 0.000000000 seconds]
>>     [Time delta from previous displayed frame: 0.000000000 seconds]
>>     [Time since reference or first frame: 0.000000000 seconds]
>>     Frame Number: 1
>>     Frame Length: 98 bytes (784 bits)
>>     Capture Length: 98 bytes (784 bits)
>>     [Frame is marked: False]
>>     [Frame is ignored: False]
>>     [Protocols in frame: eth:ethertype:ip:sctp]
>> Ethernet II, Src: RealtekU_54:81:87 (52:54:00:54:81:87), Dst:
>> Vmware_81:41:6b (00:50:56:81:41:6b)
>>     Destination: Vmware_81:41:6b (00:50:56:81:41:6b)
>>         Address: Vmware_81:41:6b (00:50:56:81:41:6b)
>>         .... ..0. .... .... .... .... = LG bit: Globally unique
>> address (factory default)
>>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>>     Source: RealtekU_54:81:87 (52:54:00:54:81:87)
>>         Address: RealtekU_54:81:87 (52:54:00:54:81:87)
>>         .... ..1. .... .... .... .... = LG bit: Locally administered
>> address (this is NOT the factory default)
>>         .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>>     Type: IPv4 (0x0800)
>> Internet Protocol Version 4, Src: 192.168.206.83, Dst: 192.168.206.65
>>     0100 .... = Version: 4
>>     .... 0101 = Header Length: 20 bytes (5)
>>     Differentiated Services Field: 0x02 (DSCP: CS0, ECN: ECT(0))
>>         0000 00.. = Differentiated Services Codepoint: Default (0)
>>         .... ..10 = Explicit Congestion Notification: ECN-Capable
>> Transport codepoint '10' (2)
>>     Total Length: 84
>>     Identification: 0x0000 (0)
>>     Flags: 0x02 (Don't Fragment)
>>         0... .... = Reserved bit: Not set
>>         .1.. .... = Don't fragment: Set
>>         ..0. .... = More fragments: Not set
>>     Fragment offset: 0
>>     Time to live: 64
>>     Protocol: SCTP (132)
>>     Header checksum: 0x1c3e [validation disabled]
>>         [Good: False]
>>         [Bad: False]
>>     Source: 192.168.206.83
>>     Destination: 192.168.206.65
>>     [Source GeoIP: Unknown]
>>     [Destination GeoIP: Unknown]
>> Stream Control Transmission Protocol, Src Port: 50001 (50001), Dst
>> Port: 3868 (3868)
>>     Source port: 50001
>>     Destination port: 3868
>>     Verification tag: 0x00000000
>>     [Assocation index: 0]
>>     Checksum: 0xbaea49e5 (not verified)
>>     INIT chunk (Outbound streams: 3000, inbound streams: 3000)
>>         Chunk type: INIT (1)
>>             0... .... = Bit: Stop processing of the packet
>>             .0.. .... = Bit: Do not report
>>         Chunk flags: 0x00
>>         Chunk length: 52
>>         Initiate tag: 0xe79f40cb
>>         Advertised receiver window credit (a_rwnd): 62464
>>         Number of outbound streams: 3000
>>         Number of inbound streams: 3000
>>         Initial TSN: 176990880
>>         IPv4 address parameter (Address: 192.168.206.83)
>>             Parameter type: IPv4 address (0x0005)
>>                 0... .... .... .... = Bit: Stop processing of chunk
>>                 .0.. .... .... .... = Bit: Do not report
>>             Parameter length: 8
>>             IP Version 4 address: 192.168.206.83
>>         IPv4 address parameter (Address: 192.168.1.83)
>>             Parameter type: IPv4 address (0x0005)
>>                 0... .... .... .... = Bit: Stop processing of chunk
>>                 .0.. .... .... .... = Bit: Do not report
>>             Parameter length: 8
>>             IP Version 4 address: 192.168.1.83
>>         Supported address types parameter (Supported types: IPv6, IPv4)
>>             Parameter type: Supported address types (0x000c)
>>                 0... .... .... .... = Bit: Stop processing of chunk
>>                 .0.. .... .... .... = Bit: Do not report
>>             Parameter length: 8
>>             Supported address type: IPv6 address (6)
>>             Supported address type: IPv4 address (5)
>>         ECN parameter
>>             Parameter type: ECN (0x8000)
>>                 1... .... .... .... = Bit: Skip parameter and continue
>> processing of the chunk
>>                 .0.. .... .... .... = Bit: Do not report
>>             Parameter length: 4
>>         Forward TSN supported parameter
>>             Parameter type: Forward TSN supported (0xc000)
>>                 1... .... .... .... = Bit: Skip parameter and continue
>> processing of the chunk
>>                 .1.. .... .... .... = Bit: Do report
>>             Parameter length: 4
>>
>>
>> On Tue, Jan 10, 2017 at 3:18 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > On Tue, Jan 10, 2017 at 12:31:01AM +0800, Sun Paul wrote:
>> >> what kind of information do you need? the whole INIT packet?
>> >>
>> > That would be ideal.
>> >
>> >> On Mon, Jan 9, 2017 at 8:25 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >> > On Mon, Jan 09, 2017 at 06:00:36PM +0800, Sun Paul wrote:
>> >> >> Hi
>> >> >>
>> >> >> the linux router just change the destination, so it can arrive on the
>> >> >> the SERVER.
>> >> >>
>> >> > Please post the relevant snippets from the client and server tcpdump
>> >> > operations
>> >> >
>> >> > Neil
>> >> >
>> >> >> On Mon, Jan 9, 2017 at 5:51 PM, David Laight <David.Laight@aculab.com> wrote:
>> >> >> > From: Sun Paul
>> >> >> >> Sent: 09 January 2017 02:08
>> >> >> >
>> >> >> >> >> I am setting up a lab where the SCTP traffics from  client is passing
>> >> >> >> >> through a linux router before reaching to the SCTP server running
>> >> >> >> >> LKSCTP.
>> >> >> >> >>
>> >> >> >> >> The linux router did not change the source address of the client, so
>> >> >> >> >> when it arrived to the SCTP server, the source address is the oriingal
>> >> >> >> >> one.
>> >> >> >>
>> >> >> >> the INIT chunk arrive on the SERVER, but then no response. the
>> >> >> >> application that using in SERVER is the same as the other test.
>> >> >> >>
>> >> >> >> I noticed one thing in Ethernet frame of the incoming packet on the
>> >> >> >> SERVER compared to the one captured from the client is the LG bit on
>> >> >> >> the source address.
>> >> >> >>
>> >> >> >> The LG bit is set to 0 on the request packet received in the
>> >> >> >> SERVER,but it is 0 from the one originated on the client. willl it be
>> >> >> >> the root cause?
>> >> >> >
>> >> >> > Which addresses are you talking about, and what do you mean by the LG bit?
>> >> >> >
>> >> >> > Is your linux 'router' just routing (ie IP forwarding) or is it doing NAT?
>> >> >> > If it is changing the IP addresses then the addresses inside some SCTP
>> >> >> > chunks also need changing.
>> >> >> >
>> >> >> >         David
>> >> >> >
>> >> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> It looks like you have some destination NAT-ing going on in these packets.  In
> one trace your destination address is 192.168.206.65, and in the other its
> 192.168.206.66.
>
> Neil
>
