From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 23 Feb 2017 06:07:57 +0000
Subject: Re: Problem on SCTP
Message-Id: <CADvbK_f0EGaaYcbnBw33sy7j3zueTdEdctxGQ+MxeQz3WrDnNQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170106123711.GA15139@hmsreliant.think-freely.org>
 <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
 <CAFXGftJkR75OjWOKZhF_jgv_W1ysFky-msMj1asCU5MQMFE43w@mail.gmail.com>
 <20170109122408.GA20973@hmswarspite.think-freely.org> <CAFXGftLY1ywdRj79RMHW57oLa9_HNEEcUYRAiM=zs6YHHGVFzw@mail.gmail.com>
 <20170109191823.GC20973@hmswarspite.think-freely.org> <CAFXGft+C9Wf0Xgq0n-cw+ffeq-maDWoP=6dUV0c=zt80ugZLJQ@mail.gmail.com>
 <20170110143351.GA10195@hmswarspite.think-freely.org> <CAFXGft+XA_r+R2hxJU2qYvFJbS+avQ7TTOQ50xkTXm8q8KpDtg@mail.gmail.com>
 <20170111125708.GA1518@hmswarspite.think-freely.org> <CAFXGftLSFgPpxD6Oak8h1Y5y11-zXWLj0v4ziMFkjX8eZ4ZJgA@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025F9FD@AcuExch.aculab.com>
 <4163FC71-3A20-4484-8CDC-FA22D4FA72CF@lurchi.franken.de> <CAFXGftJe=ooG8sQR+NmMcVMNthvu6qtaH9YBPBFJMM+Ax-4UOA@mail.gmail.com>
 <CAFXGftLn8Kc9svJJRRmUiHxN_5_O0se2srw996BbPSVTbDP0fA@mail.gmail.com>
 <15C09FCB-B635-4144-84FA-E699A9C684CA@lurchi.franken.de> <10F99ED9-3820-4D7B-8AB8-B520741247C5@lurchi.franken.de>
 <CAFXGftJjt_oQk67YeZntvLKSgT-SmM01b0mTdRLLChyyw7OBqg@mail.gmail.com>
 <CADvbK_cmR4eS_SStfaT5fOBc0KSdXUW=QaFWcg8xK3jvZQoKAQ@mail.gmail.com>
 <CAFXGftJa=KZyV5Kr3GNaRUe4zBrvj9Ymk7UdRAbmFTY_zqYwDw@mail.gmail.com>
 <CADvbK_e2WDqTdL21kfqjr2x-4Kbef2Zjh60BxG7za=5JOF6OKQ@mail.gmail.com>
 <CAFXGft+f8AsMQe-MtkKoaCmGazbBR09nP6SiOj9__k13c-23YQ@mail.gmail.com>
 <CADvbK_fWrt=b0fOK92d9nVBMQim+3124UVn_0H2b5AHjFiayXA@mail.gmail.com> <CAFXGft+E7s_=YO5aSdHt5vT7rJqV6BK8eNQEapeY0bK-pApFPQ@mail.gmail.com>
In-Reply-To: <CAFXGft+E7s_=YO5aSdHt5vT7rJqV6BK8eNQEapeY0bK-pApFPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>
Cc: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>, David Laight <David.Laight@aculab.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Feb 23, 2017 at 1:30 PM, Sun Paul <paulrbk@gmail.com> wrote:
> does this fixed in RHEL7?
yes, I think so.

>
> On Wed, Feb 22, 2017 at 11:03 AM, Xin Long <lucien.xin@gmail.com> wrote:
>> On Wed, Feb 22, 2017 at 10:29 AM, Sun Paul <paulrbk@gmail.com> wrote:
>>> Hi Xin
>>>
>>> do you mean we need to patch the kernel?
>> Yups, pls comment on that bz if it's really needed for your env.
>> A z-stream kernel may be available for that issue soon.
>>
>> Thanks.
>>
>>>
>>>
>>>
>>> On Wed, Feb 22, 2017 at 10:00 AM, Xin Long <lucien.xin@gmail.com> wrote:
>>>> On Wed, Feb 22, 2017 at 9:12 AM, Sun Paul <paulrbk@gmail.com> wrote:
>>>>> Hi
>>>>>
>>>>> the router is actually is a linux running on RHEL6.8
>>>>> (2.6.32-642.4.2.el6.x86_64). it uses iptables to do SNAT aand DNAT
>>>>> forward.
>>>> https://bugzilla.redhat.com/show_bug.cgi?id12038
>>>>
>>>> sctp_manip_pkt->sctp_compute_cksum:
>>>>     struct sctphdr *sh = sctp_hdr(sub);
>>>>
>>>> But in rhel6, skb->transport_header is not yet set at that time.
>>>> This patch should be backported into rhel6.
>>>>
>>>> commit 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3
>>>> Author: Eric Dumazet <edumazet@google.com>
>>>> Date:   Mon Jul 15 20:03:19 2013 -0700
>>>>
>>>>     ipv4: set transport header earlier
>>>>
>>>>
>>>>>
>>>>> On Tue, Feb 21, 2017 at 11:53 PM, Xin Long <lucien.xin@gmail.com> wrote:
>>>>>> On Tue, Feb 21, 2017 at 12:26 PM, Sun Paul <paulrbk@gmail.com> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> sorry to get back late, the platform is running on KVM. and this
>>>>>>> problem is resolved by moving to VMware environment, however,  a new
>>>>>>> problem is coming out, we noticed that the HB REQ is being ABORT from
>>>>>>> client.
>>>>>>>
>>>>>>>
>>>>>>> 03:32:35.233572 IP 10.165.250.22.3868 > 192.168.2.13.40001: sctp (1)
>>>>>>> [HB REQ] (from server to sctp router)
>>>>>>> 03:32:35.233603 IP 192.168.2.14.3868 > 192.168.2.13.40001: sctp (1)
>>>>>>> [HB REQ] (from sctp router to client)
>>>>>>> 03:32:35.233852 IP 192.168.2.13.40001 > 192.168.2.14.3868: sctp (1)
>>>>>>> [ABORT] (from client to sctp router)
>>>>>>>
>>>>>>> 03:32:37.928679 IP 10.165.250.22.3868 > 192.168.2.13.40001: sctp (1) [HB REQ]
>>>>>>> 03:32:37.928717 IP 192.168.2.14.3868 > 192.168.2.13.40001: sctp (1) [HB REQ]
>>>>>>> 03:32:37.929247 IP 192.168.2.13.40001 > 192.168.2.14.3868: sctp (1) [ABORT]
>>>>>>>
>>>>>>> For the above packet flow, 10.165.250.22 is the server and
>>>>>>> 192.168.2.13 is the client, the server 10.165.250.22 sends HB REQ to
>>>>>>> client 192.168.2.13 through 192.168.2.14 (the SCTP router), and the
>>>>>>> SCTP router change the src address before forward the HB REQ to the
>>>>>>> client.
>>>>>>>
>>>>>>> But somehow the client is ABORT the HB REQ, any idea? is it related to
>>>>>>> the HEARTBEAT information? or the checksum again>?
>>>>>> The incorrect checksum won't cause ABORT, but the abnormal HB REQ
>>>>>> could be, if HB information was modified when calculating the checksum
>>>>>> on router, the ABORT may be caused in client process.
>>>>>>
>>>>>> is your SCTP router linux ? if yes, what's the kernel version ?
>>>>>>
>>>>>>>
>>>>>>> On Fri, Jan 13, 2017 at 9:19 PM, Michael Tuexen
>>>>>>> <Michael.Tuexen@lurchi.franken.de> wrote:
>>>>>>>>> On 13 Jan 2017, at 10:43, Michael Tuexen <Michael.Tuexen@lurchi.franken.de> wrote:
>>>>>>>>>
>>>>>>>>> Your router does NOT change any field in the SCTP packet, but the
>>>>>>>>> SCTP checksum was modified from
>>>>>>>>>   Checksum: 0xbaea49e5 (not verified)
>>>>>>>>> to
>>>>>>>>>   Checksum: 0xa9a86d3f (not verified)
>>>>>>>>> At least one of these is wrong. Read the tracefiles in wireshark and
>>>>>>>>> enable checksum validation and wireshark will tell you which one is
>>>>>>>>> correct. (That is why I asked for .pcap file instead of a .txt).
>>>>>>>>>
>>>>>>>>> My guess is that the initial checksum is correct and your box middlebox
>>>>>>>>> not only changes the destination address and ttl field and header
>>>>>>>>> checksum in the IP-header (which is expected) but also incorrectly the
>>>>>>>>> SCTP checksum. Since no field in the SCTP packet has changed, the checksum
>>>>>>>>> must be the same.
>>>>>>>> At the server have a look at the SNMP counters:
>>>>>>>> cat /proc/net/sctp/snmp
>>>>>>>> You should find a line staring with
>>>>>>>> SctpChecksumErrors
>>>>>>>> If the number reported there is positive, the node received packets
>>>>>>>> with checksum errors.
>>>>>>>>
>>>>>>>> Best regards
>>>>>>>> Michael
>>>>>>>>>
>>>>>>>>> Best regards
>>>>>>>>> Michael
>>>>>>>>>> On 13 Jan 2017, at 04:29, Sun Paul <paulrbk@gmail.com> wrote:
>>>>>>>>>>
>>>>>>>>>> Frame 2: 98 bytes on wire (784 bits), 98 bytes captured (784 bits)
>>>>>>>>>>   Encapsulation type: Ethernet (1)
>>>>>>>>>>   Arrival Time: Jan  6, 2017 16:52:49.662321000 Malay Peninsula Standard Time
>>>>>>>>>>   [Time shift for this packet: 0.000000000 seconds]
>>>>>>>>>>   Epoch Time: 1483692769.662321000 seconds
>>>>>>>>>>   [Time delta from previous captured frame: 0.000179000 seconds]
>>>>>>>>>>   [Time delta from previous displayed frame: 0.000179000 seconds]
>>>>>>>>>>   [Time since reference or first frame: 0.000179000 seconds]
>>>>>>>>>>   Frame Number: 2
>>>>>>>>>>   Frame Length: 98 bytes (784 bits)
>>>>>>>>>>   Capture Length: 98 bytes (784 bits)
>>>>>>>>>>   [Frame is marked: False]
>>>>>>>>>>   [Frame is ignored: False]
>>>>>>>>>>   [Protocols in frame: eth:ethertype:ip:sctp]
>>>>>>>>>> Ethernet II, Src: Vmware_81:41:6b (00:50:56:81:41:6b), Dst:
>>>>>>>>>> Vmware_81:a6:a3 (00:50:56:81:a6:a3)
>>>>>>>>>>   Destination: Vmware_81:a6:a3 (00:50:56:81:a6:a3)
>>>>>>>>>>       Address: Vmware_81:a6:a3 (00:50:56:81:a6:a3)
>>>>>>>>>>       .... ..0. .... .... .... .... = LG bit: Globally unique
>>>>>>>>>> address (factory default)
>>>>>>>>>>       .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>>>>>>>>>>   Source: Vmware_81:41:6b (00:50:56:81:41:6b)
>>>>>>>>>>       Address: Vmware_81:41:6b (00:50:56:81:41:6b)
>>>>>>>>>>       .... ..0. .... .... .... .... = LG bit: Globally unique
>>>>>>>>>> address (factory default)
>>>>>>>>>>       .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
>>>>>>>>>>   Type: IPv4 (0x0800)
>>>>>>>>>> Internet Protocol Version 4, Src: 192.168.206.83, Dst: 192.168.206.66
>>>>>>>>>>   0100 .... = Version: 4
>>>>>>>>>>   .... 0101 = Header Length: 20 bytes (5)
>>>>>>>>>>   Differentiated Services Field: 0x02 (DSCP: CS0, ECN: ECT(0))
>>>>>>>>>>       0000 00.. = Differentiated Services Codepoint: Default (0)
>>>>>>>>>>       .... ..10 = Explicit Congestion Notification: ECN-Capable
>>>>>>>>>> Transport codepoint '10' (2)
>>>>>>>>>>   Total Length: 84
>>>>>>>>>>   Identification: 0x0000 (0)
>>>>>>>>>>   Flags: 0x02 (Don't Fragment)
>>>>>>>>>>       0... .... = Reserved bit: Not set
>>>>>>>>>>       .1.. .... = Don't fragment: Set
>>>>>>>>>>       ..0. .... = More fragments: Not set
>>>>>>>>>>   Fragment offset: 0
>>>>>>>>>>   Time to live: 63
>>>>>>>>>>   Protocol: SCTP (132)
>>>>>>>>>>   Header checksum: 0x1d3d [validation disabled]
>>>>>>>>>>       [Good: False]
>>>>>>>>>>       [Bad: False]
>>>>>>>>>>   Source: 192.168.206.83
>>>>>>>>>>   Destination: 192.168.206.66
>>>>>>>>>>   [Source GeoIP: Unknown]
>>>>>>>>>>   [Destination GeoIP: Unknown]
>>>>>>>>>> Stream Control Transmission Protocol, Src Port: 50001 (50001), Dst
>>>>>>>>>> Port: 3868 (3868)
>>>>>>>>>>   Source port: 50001
>>>>>>>>>>   Destination port: 3868
>>>>>>>>>>   Verification tag: 0x00000000
>>>>>>>>>>   [Assocation index: 0]
>>>>>>>>>>   Checksum: 0xa9a86d3f (not verified)
>>>>>>>>>>
>>>>>>>>>>   INIT chunk (Outbound streams: 3000, inbound streams: 3000)
>>>>>>>>>>       Chunk type: INIT (1)
>>>>>>>>>>           0... .... = Bit: Stop processing of the packet
>>>>>>>>>>           .0.. .... = Bit: Do not report
>>>>>>>>>>       Chunk flags: 0x00
>>>>>>>>>>       Chunk length: 52
>>>>>>>>>>       Initiate tag: 0xe79f40cb
>>>>>>>>>>       Advertised receiver window credit (a_rwnd): 62464
>>>>>>>>>>       Number of outbound streams: 3000
>>>>>>>>>>       Number of inbound streams: 3000
>>>>>>>>>>       Initial TSN: 176990880
>>>>>>>>>>       IPv4 address parameter (Address: 192.168.206.83)
>>>>>>>>>>           Parameter type: IPv4 address (0x0005)
>>>>>>>>>>               0... .... .... .... = Bit: Stop processing of chunk
>>>>>>>>>>               .0.. .... .... .... = Bit: Do not report
>>>>>>>>>>           Parameter length: 8
>>>>>>>>>>           IP Version 4 address: 192.168.206.83
>>>>>>>>>>       IPv4 address parameter (Address: 192.168.1.83)
>>>>>>>>>>           Parameter type: IPv4 address (0x0005)
>>>>>>>>>>               0... .... .... .... = Bit: Stop processing of chunk
>>>>>>>>>>               .0.. .... .... .... = Bit: Do not report
>>>>>>>>>>           Parameter length: 8
>>>>>>>>>>           IP Version 4 address: 192.168.1.83
>>>>>>>>>>       Supported address types parameter (Supported types: IPv6, IPv4)
>>>>>>>>>>           Parameter type: Supported address types (0x000c)
>>>>>>>>>>               0... .... .... .... = Bit: Stop processing of chunk
>>>>>>>>>>               .0.. .... .... .... = Bit: Do not report
>>>>>>>>>>           Parameter length: 8
>>>>>>>>>>           Supported address type: IPv6 address (6)
>>>>>>>>>>           Supported address type: IPv4 address (5)
>>>>>>>>>>       ECN parameter
>>>>>>>>>>           Parameter type: ECN (0x8000)
>>>>>>>>>>               1... .... .... .... = Bit: Skip parameter and continue
>>>>>>>>>> processing of the chunk
>>>>>>>>>>               .0.. .... .... .... = Bit: Do not report
>>>>>>>>>>           Parameter length: 4
>>>>>>>>>>       Forward TSN supported parameter
>>>>>>>>>>           Parameter type: Forward TSN supported (0xc000)
>>>>>>>>>>               1... .... .... .... = Bit: Skip parameter and continue
>>>>>>>>>> processing of the chunk
>>>>>>>>>>               .1.. .... .... .... = Bit: Do report
>>>>>>>>>>           Parameter length: 4
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
