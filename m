From: Cong Wang <amwang@redhat.com>
Date: Wed, 03 Feb 2010 05:15:45 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
Message-Id: <4B690681.6070908@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <1265171993.3274.3.camel@edumazet-laptop>
In-Reply-To: <1265171993.3274.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

Eric Dumazet wrote:
> Le mardi 02 février 2010 à 23:30 -0500, Amerigo Wang a écrit :
>> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
>> it can be used like ip_local_port_range, but this is used to
>> reserve ports for third-party applications which use fixed
>> port numbers within ip_local_port_range.
>>
>> This only affects the applications which call socket functions
>> like bind(2) with port number 0, to prevent the kernel getting the ports
>> within the specified range for them. For applications which use fixed
>> port number, it will have no effects.
>>
>> Any comments are welcome.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> 
>>  		.procname	= "igmp_max_memberships",
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index f0126fd..83045ca 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -210,8 +210,11 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
>>  		inet_get_local_port_range(&low, &high);
>>  		remaining = (high - low) + 1;
>>  
>> +again:
>>  		rand = net_random();
>>  		first = (((u64)rand * remaining) >> 32) + low;
>> +		if (inet_is_reserved_local_port(first))
>> +			goto again;
>>  		/*
>>  		 * force rand to be an odd multiple of UDP_HTABLE_SIZE
>>  		 */
> 
> Unless I misread the patch, you are checking only the 'first' port that
> udp_lib_get_port() chose.
> 
> I would use inet_get_local_reserved_ports(&min_res, &max_res);
> and check every port that we chose in the loop to avoid it if necessary.
> 

Hmm, right, 'first' is used to do iteration, but I did missed 'last'.
Thanks! I will fix this in the next update.

