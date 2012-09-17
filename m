From: David Miller <davem@davemloft.net>
Date: Mon, 17 Sep 2012 18:25:04 +0000
Subject: Re: [PATCH net-next v3 0/4] Take care of xfrm policy when checking dst entries
Message-Id: <20120917.142504.115219640757684297.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1347350987-8054-1-git-send-email-nicolas.dichtel@6wind.com>
	<20120917.124953.1599275868994343219.davem@davemloft.net>
	<5057688B.3030509@gmail.com>
In-Reply-To: <5057688B.3030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nicolas.dichtel@6wind.com, eric.dumazet@gmail.com, sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 17 Sep 2012 14:14:35 -0400

> I think he expected you to take Eric's patch that removed those
> pieces.

Eric's patch was a cleanup, so it went into 'net-next'.

Nicolas's patch is a bonafide bug fix so needs to be
targetted at 'net'
