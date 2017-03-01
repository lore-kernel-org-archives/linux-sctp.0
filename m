From: David Miller <davem@davemloft.net>
Date: Wed, 01 Mar 2017 17:51:44 +0000
Subject: Re: [PATCH net] sctp: call rcu_read_lock before checking for duplicate transport nodes
Message-Id: <20170301.125144.868804645631520813.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d239fb1c1f86e3421de4a891f8a704d37b236cbf.1488256889.git.lucien.xin@gmail.com>
In-Reply-To: <d239fb1c1f86e3421de4a891f8a704d37b236cbf.1488256889.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, andreyknvl@google.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 28 Feb 2017 12:41:29 +0800

> Commit cd2b70875058 ("sctp: check duplicate node before inserting a
> new transport") called rhltable_lookup() to check for the duplicate
> transport node in transport rhashtable.
> 
> But rhltable_lookup() doesn't call rcu_read_lock inside, it could cause
> a use-after-free issue if it tries to dereference the node that another
> cpu has freed it. Note that sock lock can not avoid this as it is per
> sock.
> 
> This patch is to fix it by calling rcu_read_lock before checking for
> duplicate transport nodes.
> 
> Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
