From: Tommi Rantala <tommi.t.rantala@nokia.com>
Date: Wed, 31 Jan 2018 06:58:59 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <d226eb63-c613-69ae-c92d-c71785108733@nokia.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
 <20180130225227.GC3503@localhost.localdomain>
In-Reply-To: <20180130225227.GC3503@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On 31.01.2018 00:52, Marcelo Ricardo Leitner wrote:
> On Mon, Jan 29, 2018 at 05:55:45PM +0200, Tommi Rantala wrote:
>> Hi,
>>
>> When running sctp_test from lksctp-tools in netns in 4.4 and 4.9 with
>> suitable arguments, the local loopback device in the netns is not getting
>> destroyed after deleting the netns.
>>
> ...
>>
>> Based on a quick test, 4.14 and 4.15 does not suffer from this, but its
>> reproducible e.g. in 4.4.113 and 4.9.75
>>
>> Any ideas?
> 
> By the versions you mentioned and report, maybe f186ce61bb82 ("Fix an
> intermittent pr_emerg warning about lo becoming free.") fixed it.

Thanks, found that commit too, but it does not help. It has been 
included 4.4.76 already.

Also the warning is not intermittent, but permanent...

It makes it impossible to add another netns, in 4.4 "ip netns add" gets 
stuck in uninterruptible sleep:

$ grep State /proc/$(pidof ip)/status
State:  D (disk sleep)

$ cat /proc/$(pidof ip)/stack
[<ffffffff8249c342>] copy_net_ns+0x72/0x100
[<ffffffff82075ee9>] create_new_namespaces+0xf9/0x1b0
[<ffffffff82076141>] unshare_nsproxy_namespaces+0x61/0xa0
[<ffffffff82056c1b>] SyS_unshare+0x1ab/0x2e0
[<ffffffff825a266e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[<ffffffffffffffff>] 0xffffffffffffffff


Tommi
