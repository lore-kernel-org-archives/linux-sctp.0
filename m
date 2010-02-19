From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 19 Feb 2010 08:13:49 +0000
Subject: Re: [RFC 1/2] sctp: convert hash list to RCU
Message-Id: <1266567229.2877.29.camel@edumazet-laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100219055520.223027612@vyatta.com>
	 <20100219055628.436258223@vyatta.com>
In-Reply-To: <20100219055628.436258223@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Le jeudi 18 février 2010 à 21:55 -0800, Stephen Hemminger a écrit :
> pièce jointe document texte brut (sctp-rcu.patch)
> This patch converts existing SCTP hash list to using RCU
> rather than reader/writer lock. Also, get rid of no longer used
> locking wrappers.
> 
> In future, the SCTP hash locking should be broken out from the
> hash structure because of the wasted space for the hash locks
> and associated holes. A single lock per hashlist is sufficient
> now that RCU is used.
> 
> Compile tested only. I can't think of an SCTP stress application.
> 
> P.s: Some janitor ought to go through and remove the locking
> macros here.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 

Stephen, I read full patch and cannot see how you respect the rcu grace
period at dismantle phase. I am not familiar with SCTP, maybe its
already done ? (before the patch)



