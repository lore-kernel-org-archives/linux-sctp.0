From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 19 Nov 2013 15:25:45 +0000
Subject: Re: [PATCH 2/2] ipv6: use sk_v6_copy_addrs when memcpy struct ipv6_pinfo
Message-Id: <528B82F9.6000708@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1384829247-8624-1-git-send-email-wangweidong1@huawei.com>	  <1384829247-8624-3-git-send-email-wangweidong1@huawei.com>	  <20131119031408.GQ16541@order.stressinduktion.org>	  <528ADBDD.9040209@huawei.com>	  <1384833538.8604.83.camel@edumazet-glaptop2.roam.corp.google.com>	 <1384833653.8604.84.camel@edumazet-glaptop2.roam.corp.google.com>	 <528B4D0B.10204@redhat.com> <1384871001.8604.103.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1384871001.8604.103.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>, Daniel Borkmann <dborkman@redhat.com>
Cc: wangweidong <wangweidong1@huawei.com>, davem@davemloft.net, gerrit@erg.abdn.ac.uk, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, nhorman@tuxdriver.com, dccp@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dingtianhong@huawei.com

On 11/19/2013 09:23 AM, Eric Dumazet wrote:
> On Tue, 2013-11-19 at 12:35 +0100, Daniel Borkmann wrote:
>> On 11/19/2013 05:00 AM, Eric Dumazet wrote:
>>> On Mon, 2013-11-18 at 19:58 -0800, Eric Dumazet wrote:
>>>
>>>> But sctp is not tcp ;)
>>>>
>>>> sctp_copy_sock() is doing some clever/partial copy of the socket, so
>>>> please fix it ;)
>>>>
>>>> No idea why it's not doing the normal copy of the socket.
>>>
>>> BTW, not doing the full copy means for example that SO_MAX_PACING_RATE
>>> is broken for SCTP.
>>
>> Yep, indeed. Looking into it ...
> 
> It might be the time to finally use inet_csk_clone_lock() in SCTP.
> 
> 

I can see sk_clone_lock() since SCTP doesn't use icsk sockets.  Need
to study the code a bit.

-vlad

