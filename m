From: David Miller <davem@davemloft.net>
Date: Wed, 16 Oct 2019 17:47:47 +0000
Subject: Re: Stable request
Message-Id: <20191016.134747.1774326347358314168.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190823.144250.2063544404229146484.davem@davemloft.net>
        <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
        <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
In-Reply-To: <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: ecree@solarflare.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, brouer@redhat.com, dvyukov@google.com, syzkaller-bugs@googlegroups.com

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 16 Oct 2019 16:26:50 +0100

> On 04/10/2019 16:17, Edward Cree wrote:
>> On 23/08/2019 22:42, David Miller wrote:
>>> From: Xin Long <lucien.xin@gmail.com>
>>> Date: Fri, 23 Aug 2019 19:33:03 +0800
>>>
>>>> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
>>>> listify ip_rcv_finish in case of forwarding") does for ipv4.
>>>>
>>>> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
>>>> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
>>>> trace was:
>>>  ...
>>>> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish=
()")
>>>> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL sk=
bs")
>>>> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
>>>> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>> Applied, thanks.
>> Just noticed that this only went to net-next (and 5.4-rc1), when actually
>> =A0it's needed on all kernels back to 4.19 (per the first Fixes: tag).=
=A0 The
>> =A0second Fixes: reference, 323ebb61e32b, merely enables syzbot to hit i=
t on
>> =A0whatever hardware it has, but the bug was already there, and hittable=
 on
>> =A0sfc NICs.
>> David, can this go to stable please?
> Hi, did this get missed or was my request improper in some way?

Sorry, I'm just getting over a cold and very backlogged on this kind of stu=
ff.

I'll get to this while I can Ed.
