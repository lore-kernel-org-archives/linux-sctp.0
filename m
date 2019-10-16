From: Edward Cree <ecree@solarflare.com>
Date: Wed, 16 Oct 2019 15:26:50 +0000
Subject: Stable request (was Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case of forwarding
Message-Id: <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
 <20190823.144250.2063544404229146484.davem@davemloft.net>
 <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
In-Reply-To: <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, brouer@redhat.com, dvyukov@google.com, syzkaller-bugs@googlegroups.com

On 04/10/2019 16:17, Edward Cree wrote:
> On 23/08/2019 22:42, David Miller wrote:
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Fri, 23 Aug 2019 19:33:03 +0800
>>
>>> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
>>> listify ip_rcv_finish in case of forwarding") does for ipv4.
>>>
>>> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
>>> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
>>> trace was:
>>  ...
>>> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
>>> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
>>> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
>>> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> Applied, thanks.
> Just noticed that this only went to net-next (and 5.4-rc1), when actually
>  it's needed on all kernels back to 4.19 (per the first Fixes: tag).  The
>  second Fixes: reference, 323ebb61e32b, merely enables syzbot to hit it on
>  whatever hardware it has, but the bug was already there, and hittable on
>  sfc NICs.
> David, can this go to stable please?
Hi, did this get missed or was my request improper in some way?
Our testing has been hitting this issue on distro kernels (Fedora, Debian,
 Ubuntu), we'd like the fix to get everywhere it's needed and AIUI -stable
 is the proper route for that.
For reference, the fix was committed as c7a42eb49212.

-Ed
