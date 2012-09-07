From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 07 Sep 2012 15:08:29 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <1347030509.2484.774.camel@edumazet-glaptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <5049FAE3.2050403@6wind.com>
	 <1347033467-3757-1-git-send-email-nicolas.dichtel@6wind.com>
	 <1347033467-3757-2-git-send-email-nicolas.dichtel@6wind.com>
	 <1347028510.2484.736.camel@edumazet-glaptop>  <504A09FD.1050201@gmail.com>
In-Reply-To: <504A09FD.1050201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>, davem@davemloft.net, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Fri, 2012-09-07 at 10:51 -0400, Vlad Yasevich wrote:

> I thought of that too, but that requires hacking xfrm to know the 
> namespace at the time it changes the flow_cache_genid.  This one seems 
> simpler to do.

Simpler maybe, but its yet another test done in fast path.



