From: wangweidong <wangweidong1@huawei.com>
Date: Tue, 19 Nov 2013 04:44:10 +0000
Subject: Re: [PATCH 2/2] ipv6: use sk_v6_copy_addrs when memcpy struct ipv6_pinfo
Message-Id: <528AEC9A.5050100@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1384829247-8624-1-git-send-email-wangweidong1@huawei.com>	 <1384829247-8624-3-git-send-email-wangweidong1@huawei.com>	 <20131119031408.GQ16541@order.stressinduktion.org>	 <528ADBDD.9040209@huawei.com>	 <1384833538.8604.83.camel@edumazet-glaptop2.roam.corp.google.com> <1384833653.8604.84.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1384833653.8604.84.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, gerrit@erg.abdn.ac.uk, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, vyasevich@gmail.com, nhorman@tuxdriver.com, dccp@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dingtianhong@huawei.com

On 2013/11/19 12:00, Eric Dumazet wrote:
> On Mon, 2013-11-18 at 19:58 -0800, Eric Dumazet wrote:
> 
>> But sctp is not tcp ;)
>>
>> sctp_copy_sock() is doing some clever/partial copy of the socket, so
>> please fix it ;)
>>
>> No idea why it's not doing the normal copy of the socket.
> 
> BTW, not doing the full copy means for example that SO_MAX_PACING_RATE
> is broken for SCTP.
> 
> 
>

The dccp will copy the geniric socket, too. And You mean to say that only
add the copies in sctp_copy_sock(). 

Thanks. 
> 
> 
> 
> 


