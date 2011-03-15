From: David Miller <davem@davemloft.net>
Date: Tue, 15 Mar 2011 21:02:22 +0000
Subject: Re: [PATCH 04/17] net,rcu: convert call_rcu(tcf_common_free_rcu)
Message-Id: <20110315.140222.71135070.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D7F3610.6000809@cn.fujitsu.com> <4D7F37F0.1050801@cn.fujitsu.com>
In-Reply-To: <4D7F37F0.1050801-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-decnet-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, pekkas-UjJjq++bwZ7HOG6cAo2yLw@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, vladislav.yasevich-VXdhtT5mjnY@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 15 Mar 2011 17:57:04 +0800

> 
> 
> The rcu callback tcf_common_free_rcu() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(tcf_common_free_rcu).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
