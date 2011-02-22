From: Mingyuan Zhu <liyha.zhu@gmail.com>
Date: Tue, 22 Feb 2011 13:14:15 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <AANLkTim=hf+A0-r1HQnALx30tFqFcR9aOmjh4eMJucmw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

What kind of test tool you used for the testing? I'm working on 2.6.34
Linux kernel. Can you have a test on 2.6.34?

Thanks very much!

2011/2/22 Shan Wei <shanwei@cn.fujitsu.com>:
> Mingyuan Zhu wrote, at 02/18/2011 10:04 PM:
>> Is it probably a lksctp usage issue or kinda bug of lksctp?
>> I read some source code of lksctp-test and didn't find related test
>> cases. Did someone test this scenaria before?
>
> I have just tested it like following:
> H2 is the tested Linux with latest kernel 2.6.37.
> and it can retransmit again and again.
>
> H1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 H2(2.6.37kernel)
>
> =A0 <--------------- D1
> =A0 <--------------- D2
> =A0 <--------------- D3
> =A0 <--------------- D4
>
> =A0SACK(ACK=D1,gap_start=3D2,gap_end=3D2)
> =A0--------------->
>
> =A0<--------------- D5
>
> =A0SACK(ACK=D1,gap_start=3D2,gap_end=3D3)
> =A0--------------->
>
> =A0<--------------- D2(retransmitted!!)
>
> =A0SACK(ACK=D1,gap_start=3D2,gap_end=3D4)
> =A0--------------->
>
> =A0<--------------- D2(retransmitted Again!)
>
> =A0SACK(ACK=D1,gap_start=3D2,gap_end=3D4)
> =A0--------------->
>
> =A0<--------------- D2(retransmitted Again!!)
>
>
>>
>> Great appreciate if you could provide some information.
>>
>> 2011/2/17 Mingyuan Zhu <liyha.zhu@gmail.com>:
>>> Please see the result below. Can you give any suggestion from below inf=
ormation?
>>>
>>> #cat /proc/net/sctp/assocs
>>> =A0ASSOC =A0 =A0 SOCK =A0 STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UI=
D INODE
>>> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>>> ffff880206882000 ffff8801f36be0c0 2 =A0 1 =A0 4 =A037699 =A0 =A01 =A0 =
=A0 2710
>>> =A00 =A0 =A0 =A0 0 580897 2944 =A0 4944 =A0*169.254.64.6 <-> *192.168.4=
.103
>>> =A0 2500 =A0 =A0 4 =A0 =A0 4 =A0 10 =A0 =A00 =A0 =A00 =A0 =A0 =A0 =A00
>>>
>>> #cat /proc/net/sctp/remaddr
>>> ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX =A0START
>>> 192.168.4.103 =A01 1 750 5 0 0
>>>
>>> #sysctl -a | grep max_retrans
>>> net.netfilter.nf_conntrack_tcp_timeout_max_retrans =3D 300
>>> net.netfilter.nf_conntrack_tcp_max_retrans =3D 3
>>> net.sctp.association_max_retrans =3D 10
>>> net.sctp.path_max_retrans =3D 5
>>>
>>>
>>> 2011/2/16 Mingyuan Zhu <liyha.zhu@gmail.com>:
>>>> I will rerun the test case to get the other two info:
>>>> # cat /proc/net/sctp/assocs
>>>> # cat /proc/net/sctp/remaddr
>>>>
>>>>
>>>> msw12:~ # sysctl -a | grep max_retrans
>>>> net.netfilter.nf_conntrack_tcp_timeout_max_retrans =3D 300
>>>> net.netfilter.nf_conntrack_tcp_max_retrans =3D 3
>>>> net.sctp.association_max_retrans =3D 10
>>>> net.sctp.path_max_retrans =3D 5
>>>>
>>>>
>>>> 2011/2/16 Vasil Velichkov <vasil.velichkov@opencode.com>:
>>>>> On 15.02.2011 15:58, Mingyuan Zhu wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>>
>>>>>>
>>>>>> I have observed a problem while doing load testing on SCTP. The test=
ed
>>>>>> equipment is an open suse linux box with 2.6.34 kernel. The
>>>>>> application of the equipment will send/receive messages through linux
>>>>>> kernel sctp. The peer is an equipment using Aricent sctp stack.
>>>>>>
>>>>>> During the load testing, the peer equipment drops sctp chunks and
>>>>>> reports gaps through SACK to the tested equipment.
>>>>>>
>>>>>> The tested equipment (Linux box) retransmitts the missing chunks. But
>>>>>> it always retransmit the same #TSN only once even it receives more
>>>>>> SACKs with the reporting gap.
>>>>>>
>>>>>> =A0From the ethereal captures:
>>>>>>
>>>>>> - TSN 2254147468 is not received by the peer equipment, so it reports
>>>>>> the gap by SACK.
>>>>>>
>>>>>> - Linux box retransmit TSN 2254147468.
>>>>>>
>>>>>> - The peer still does not get it. It reports the gap by SACK again a=
nd
>>>>>> again.
>>>>>>
>>>>>> - Linux box never retransmit the missing chunk again.
>>>>>>
>>>>>> - Finally, neither linux box nor the peer can send/receive any more
>>>>>> chunks.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Could someone help to look at the problem? Any help would be highly
>>>>>> appreciated!
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp=
" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>>
>>>>>
>>>>> Hi Mingyuan Zhu,
>>>>>
>>>>> On the Linux box, check whether net.sctp.path_max_retrans(MAX_PATH_RT=
X) or
>>>>> net.sctp.association_max_retrans(MAXRT) parameters are set to 1.
>>>>>
>>>>> # cat /proc/net/sctp/assocs
>>>>> =A0ASSOC =A0 =A0 SOCK =A0 STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE =
UID INODE LPORT
>>>>> RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>>>>> f2876000 f35ee1c0 2 =A0 1 =A0 4 =A038050 =A0 =A01 =A0 =A0 =A0 =A00 =
=A0 =A0 =A0 =A00 =A0 =A0 =A0 0 6429275
>>>>> 2975 =A0 2985 =A0*127.0.0.1 <-> *127.0.0.1 =A0 =A0 =A0 =A0 =A0 =A0500=
0 =A0 =A032 =A0 =A032 =A0 =A05 =A0 =A00
>>>>> =A0 =A00 =A0 =A0 =A0 =A00
>>>>> f444c800 e8407c00 2 =A0 1 =A0 4 =A041620 =A0 =A02 =A0 =A0 =A0 =A00 =
=A0 =A0 =A0 =A00 =A0 =A0 500 6429276
>>>>> 2985 =A0 2975 =A0*127.0.0.1 <-> *127.0.0.1 =A0 =A0 =A0 =A0 =A0 =A0500=
0 =A0 =A032 =A0 =A032 =A0 =A05 =A0 =A00
>>>>> =A0 =A00 =A0 =A0 =A0 =A00
>>>>>
>>>>> # cat /proc/net/sctp/remaddr
>>>>> ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX =A0START
>>>>> 127.0.0.1 =A01 1 1000 5 0 0
>>>>> 127.0.0.1 =A02 1 1000 5 0 0
>>>>>
>>>>> # sysctl -a | grep max_retrans
>>>>> net.sctp.association_max_retrans =3D 10
>>>>> net.sctp.path_max_retrans =3D 5
>>>>>
>>>>> BR
>>>>> Vasil Velichkov
>>>>>
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
>
> Best Regards
> -----
> Shan Wei
>
