From: Cong Wang <amwang@redhat.com>
Date: Fri, 05 Feb 2010 07:25:24 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
Message-Id: <4B6BC7E4.5070909@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <e2e108261002042311w59ba1372ld9f8fb2f369ca434@mail.gmail.com>
In-Reply-To: <e2e108261002042311w59ba1372ld9f8fb2f369ca434@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>

Bart Van Assche wrote:
> On Wed, Feb 3, 2010 at 5:30 AM, Amerigo Wang <amwang@redhat.com> wrote:
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
> 
> Relying on fixed port numbers is generally considered as a shortcoming
> in the application. It would be helpful if you could explain more in
> detail why port number reservation is necessary. Maybe there exists
> another solution that does not require modifying the bind() system
> call.
> 

The problem is that there are some existing applications which use
fixed port number, we don't have chances to change this for them,
thus making them working is desired, so they want to reserve these
port for those applications.

For example, if I have an appliction which uses port 40000, but
before this application starts, another application gets this port
number by bind() with port 0 (i.e. chosen by kernel), in this case,
that application will fail to start. Again, we don't have any chance
to change the source code of that application.

Hope this can make the problem clear.

Thanks.

