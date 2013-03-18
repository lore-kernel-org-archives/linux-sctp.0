From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 18 Mar 2013 20:48:48 +0000
Subject: Re: sctp: hang in sctp_remaddr_seq_show
Message-Id: <1363639728.21184.8.camel@edumazet-glaptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <51434D78.9030308@oracle.com>
	 <20130318110415.GA9478@hmsreliant.think-freely.org>
	 <1363620340.29475.132.camel@edumazet-glaptop> <5147333A.3010907@gmail.com>
	 <20130318203202.GB9478@hmsreliant.think-freely.org>
In-Reply-To: <20130318203202.GB9478@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sasha Levin <sasha.levin@oracle.com>, sri@us.ibm.com, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Dave Jones <davej@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, 2013-03-18 at 16:32 -0400, Neil Horman wrote:

> Vlads, right.  We need to grab the rcu lock before the read lock, but we should
> probably use the rcu_read_lock_bh variant, since we're going to disable bottom
> halves anyway.
> Neil

rcu_read_lock_bh() and {local_bh_disable();rcu_read_lock();} have quite
different semantics.

If you use rcu_read_lock_bh(), you also need to change rcu_dereference()
calls to rcu_dereference_bh() variant.



