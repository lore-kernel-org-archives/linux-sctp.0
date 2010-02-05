From: Octavian Purdila <opurdila@ixiacom.com>
Date: Fri, 05 Feb 2010 12:28:12 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Message-Id: <201002051428.12767.opurdila@ixiacom.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100204.094110.64247447.davem@davemloft.net> <201002050305.22227.opurdila@ixiacom.com> <4B6BB447.8080806@redhat.com>
In-Reply-To: <4B6BB447.8080806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cong Wang <amwang@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, davem@davemloft.net, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org

On Friday 05 February 2010 08:01:43 you wrote:

> >> If you can accept his version, I want to use his version (with an
> >> interface for updating above "reserved_ports" by not only root user's
> >> sysctl() but also MAC's policy configuration).
> >
> > I think that simply using an interface to update the reserved_ports from
> > MAC policy configuration module wouldn't work, as root will be able to
> > modify the policy via sysctl.
> >
> > I think that we might need to:
> >
> > a) have a reserved_port updater
> >
> > b) put a LSM hook into that
> >
> > c) use the reserved_port updater from sysctl
> 
> Ideally, you'd provide an interface for port allocator to use, so
> doing port reservation will be easier.
> 

If I understand the TOMOYO requirements correctly, we need a way to restrict a 
user action based on some security policy (in this case the ability to clear 
reserved ports). Traditionally that has been done with LSM hooks, so I think 
that approach is preferable.
