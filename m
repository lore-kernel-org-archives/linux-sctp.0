From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 22 Feb 2017 09:20:19 +0000
Subject: Re: multihoming client question
Message-Id: <CADvbK_e8C938eBvvOtS0+WCeYzmvo43h6K8wQbbby8Z5WMV_BQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
In-Reply-To: <CAJ0j_BYFOO+szALYGoFryCcpOrRoYjrgPOx_VVcUvOtSUX31Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Feb 22, 2017 at 3:33 PM, Tim Tam <wctamtim2016@gmail.com> wrote:
> Dear Marcelo,
>
> As we want to setup a 2 way mutihome, we setup a Vlan config to divide 2 IP
> subnet (172.28.129.56, 172.28.129.184) and the iproute2 config as below.
> Therefore, it suppose the connection only allow 172.28.129.56 <----->
> 10.82.24.26, 172.28.129.184 <-----> 10.82.24.153
> However, during our test, it found the heatbeat send from server
> 10.82.24.153 ---> 172.28.129.184 but the heartbeat_ack always reply with
> other interface 172.28.129.56 ----> 10.82.24.153. we didn't setup any
> routing for this,  why the library always reply the ack with another
> interface?
> thanks
>
> iproute2:
>
>
> 32722:  from 172.28.129.184 to 10.82.24.153 lookup SCTP20
> 32723:  from 172.28.129.56 to 10.82.24.26 lookup SCTP19
>
> [root@lqsgwtest ~]# ip route show table SCTP19
> default via 172.28.129.1 dev em3
shouldn't it be "default via 172.28.129.1 dev em3.6" ?

> [root@lqsgwtest ~]# ip route show table SCTP20
> default via 172.28.129.129 dev em2
"default via 172.28.129.129 dev em2.5" ?

>
>
>
> interface:
>
> em2.5     Link encap:Ethernet  HWaddr 78:2B:CB:35:6D:52
>           inet addr:172.28.129.184  Bcast:172.28.129.255
> Mask:255.255.255.128
>           inet6 addr: fe80::7a2b:cbff:fe35:6d52/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0
>           RX bytes:0 (0.0 b)  TX bytes:468 (468.0 b)
>
>
>
> em3.6     Link encap:Ethernet  HWaddr 78:2B:CB:35:6D:54
>           inet addr:172.28.129.56  Bcast:172.28.129.127
> Mask:255.255.255.128
>           inet6 addr: fe80::7a2b:cbff:fe35:6d54/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0
>           RX bytes:0 (0.0 b)  TX bytes:468 (468.0 b)
>
> netstat route:
>
> 10.82.24.26     172.28.129.1    255.255.255.255 UGH       0 0          0 em3
> 10.82.24.153    172.28.129.129  255.255.255.255 UGH       0 0          0 em2
> 172.28.129.128  0.0.0.0         255.255.255.128 U         0 0          0
> em2.5
> 172.28.129.0    0.0.0.0         255.255.255.128 U         0 0          0
> em3.6
>
>
> Regards,
> Tim Tam
>
> On Tue, Feb 21, 2017 at 4:51 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
>>
>> Dear Sir,
>>
>> My partner TIm will help to provide information.
>>
>> Hi Tim,
>>
>> Please help to provide information.
>>
>> Regards,
>> Andrew
>>
>>
>> ---------- Forwarded message ----------
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Wed, Jan 11, 2017 at 9:19 PM
>> Subject: Re: multihoming client question
>> To: tsoi andrew <tsoiandrew@gmail.com>
>> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
>> linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
>>
>>
>> On Wed, Jan 11, 2017 at 6:24 PM, tsoi andrew <tsoiandrew@gmail.com> wrote:
>> > Dear Sir,
>> >
>> > We have used iproute2 to set the route but lksctp client still choose
>> > the path from IP A to IP Y.
>> > It is still under our investigation.  Any hints for me?
>> can you send your route entries, the NICs' names and their addresses,
>> peer's addresses?
>>
>> >
>> > Regards,
>> > Andrew
>> >
>> > On Wed, Dec 21, 2016 at 10:04 PM, Marcelo Ricardo Leitner
>> > <marcelo.leitner@gmail.com> wrote:
>> >> On Wed, Dec 21, 2016 at 05:10:22PM +0800, tsoi andrew wrote:
>> >>> Dear Sir,
>> >>>
>> >>> Would you provide the link for download the new library? I only find
>> >>> version 1.0.17 in http://lksctp.sourceforge.net/.
>> >>
>> >> 1.0.17 is the latest release we have.
>> >> You can a devel copy (may not be stable) via git,
>> >> https://github.com/sctp/lksctp-tools
>> >> but that's not going to help with this problem. The change Xin
>> >> mentioned
>> >> is on kernel level only.
>> >>
>> >>   Marcelo
>
>
