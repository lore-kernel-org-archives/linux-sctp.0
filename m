From: Mingyuan Zhu <liyha.zhu@gmail.com>
Date: Sat, 19 Feb 2011 08:37:03 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <AANLkTikWBXvgUgy-f2SA+9bPNHxJ3o3GktJGxd2yErog@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

I read an email thread in lksctp archive mailing list. I think what's
happening on my test environment is the same as described in the email
thread. I put the link here.
http://sourceforge.net/mailarchive/forum.php?thread_nameL489B51.6060604%40h=
p.com&forum_name=3Dlksctp-developers

In the email thread, Vlad Yasevich mentioned a patch which should have
fixed the issue.
Is there someone can let me know if the patch works? Or where can I
get the patch with this fix.

I do need the fix for my product testing. Thanks very much!


2011/2/18 Mingyuan Zhu <liyha.zhu@gmail.com>:
> Is it probably a lksctp usage issue or kinda bug of lksctp?
> I read some source code of lksctp-test and didn't find related test
> cases. Did someone test this scenaria before?
>
> Great appreciate if you could provide some information.
>
> 2011/2/17 Mingyuan Zhu <liyha.zhu@gmail.com>:
>> Please see the result below. Can you give any suggestion from below info=
rmation?
>>
>> #cat /proc/net/sctp/assocs
>> =A0ASSOC =A0 =A0 SOCK =A0 STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE UID=
 INODE
>> LPORT RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>> ffff880206882000 ffff8801f36be0c0 2 =A0 1 =A0 4 =A037699 =A0 =A01 =A0 =
=A0 2710
>> =A00 =A0 =A0 =A0 0 580897 2944 =A0 4944 =A0*169.254.64.6 <-> *192.168.4.=
103
>> =A0 2500 =A0 =A0 4 =A0 =A0 4 =A0 10 =A0 =A00 =A0 =A00 =A0 =A0 =A0 =A00
>>
>> #cat /proc/net/sctp/remaddr
>> ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX =A0START
>> 192.168.4.103 =A01 1 750 5 0 0
>>
>> #sysctl -a | grep max_retrans
>> net.netfilter.nf_conntrack_tcp_timeout_max_retrans =3D 300
>> net.netfilter.nf_conntrack_tcp_max_retrans =3D 3
>> net.sctp.association_max_retrans =3D 10
>> net.sctp.path_max_retrans =3D 5
>>
>>
>> 2011/2/16 Mingyuan Zhu <liyha.zhu@gmail.com>:
>>> I will rerun the test case to get the other two info:
>>> # cat /proc/net/sctp/assocs
>>> # cat /proc/net/sctp/remaddr
>>>
>>>
>>> msw12:~ # sysctl -a | grep max_retrans
>>> net.netfilter.nf_conntrack_tcp_timeout_max_retrans =3D 300
>>> net.netfilter.nf_conntrack_tcp_max_retrans =3D 3
>>> net.sctp.association_max_retrans =3D 10
>>> net.sctp.path_max_retrans =3D 5
>>>
>>>
>>> 2011/2/16 Vasil Velichkov <vasil.velichkov@opencode.com>:
>>>> On 15.02.2011 15:58, Mingyuan Zhu wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>>
>>>>>
>>>>> I have observed a problem while doing load testing on SCTP. The tested
>>>>> equipment is an open suse linux box with 2.6.34 kernel. The
>>>>> application of the equipment will send/receive messages through linux
>>>>> kernel sctp. The peer is an equipment using Aricent sctp stack.
>>>>>
>>>>> During the load testing, the peer equipment drops sctp chunks and
>>>>> reports gaps through SACK to the tested equipment.
>>>>>
>>>>> The tested equipment (Linux box) retransmitts the missing chunks. But
>>>>> it always retransmit the same #TSN only once even it receives more
>>>>> SACKs with the reporting gap.
>>>>>
>>>>> =A0From the ethereal captures:
>>>>>
>>>>> - TSN 2254147468 is not received by the peer equipment, so it reports
>>>>> the gap by SACK.
>>>>>
>>>>> - Linux box retransmit TSN 2254147468.
>>>>>
>>>>> - The peer still does not get it. It reports the gap by SACK again and
>>>>> again.
>>>>>
>>>>> - Linux box never retransmit the missing chunk again.
>>>>>
>>>>> - Finally, neither linux box nor the peer can send/receive any more
>>>>> chunks.
>>>>>
>>>>>
>>>>>
>>>>> Could someone help to look at the problem? Any help would be highly
>>>>> appreciated!
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp"=
 in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>
>>>> Hi Mingyuan Zhu,
>>>>
>>>> On the Linux box, check whether net.sctp.path_max_retrans(MAX_PATH_RTX=
) or
>>>> net.sctp.association_max_retrans(MAXRT) parameters are set to 1.
>>>>
>>>> # cat /proc/net/sctp/assocs
>>>> =A0ASSOC =A0 =A0 SOCK =A0 STY SST ST HBKT ASSOC-ID TX_QUEUE RX_QUEUE U=
ID INODE LPORT
>>>> RPORT LADDRS <-> RADDRS HBINT INS OUTS MAXRT T1X T2X RTXC
>>>> f2876000 f35ee1c0 2 =A0 1 =A0 4 =A038050 =A0 =A01 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0 =A00 =A0 =A0 =A0 0 6429275
>>>> 2975 =A0 2985 =A0*127.0.0.1 <-> *127.0.0.1 =A0 =A0 =A0 =A0 =A0 =A05000=
 =A0 =A032 =A0 =A032 =A0 =A05 =A0 =A00
>>>> =A0 =A00 =A0 =A0 =A0 =A00
>>>> f444c800 e8407c00 2 =A0 1 =A0 4 =A041620 =A0 =A02 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0 =A00 =A0 =A0 500 6429276
>>>> 2985 =A0 2975 =A0*127.0.0.1 <-> *127.0.0.1 =A0 =A0 =A0 =A0 =A0 =A05000=
 =A0 =A032 =A0 =A032 =A0 =A05 =A0 =A00
>>>> =A0 =A00 =A0 =A0 =A0 =A00
>>>>
>>>> # cat /proc/net/sctp/remaddr
>>>> ADDR ASSOC_ID HB_ACT RTO MAX_PATH_RTX REM_ADDR_RTX =A0START
>>>> 127.0.0.1 =A01 1 1000 5 0 0
>>>> 127.0.0.1 =A02 1 1000 5 0 0
>>>>
>>>> # sysctl -a | grep max_retrans
>>>> net.sctp.association_max_retrans =3D 10
>>>> net.sctp.path_max_retrans =3D 5
>>>>
>>>> BR
>>>> Vasil Velichkov
>>>>
>>>
>>
>
