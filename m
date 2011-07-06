From: Thomas Graf <tgraf@infradead.org>
Date: Wed, 06 Jul 2011 21:58:29 +0000
Subject: Re: [PATCHv2] sctp: Enforce retransmission limit during shutdown
Message-Id: <20110706215829.GC17652@canuck.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110629154814.GD10085@canuck.infradead.org>
 <4E0B4F71.4020108@hp.com>
 <20110630084933.GA24074@canuck.infradead.org>
 <4E0C8368.5090502@hp.com>
 <20110704135019.GA801@canuck.infradead.org>
 <4E146652.7010205@hp.com>
 <20110706141808.GA17652@canuck.infradead.org>
 <4E1471DC.2090407@hp.com>
 <20110706154900.GB17652@canuck.infradead.org>
 <4E148C16.8090505@hp.com>
In-Reply-To: <4E148C16.8090505@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, Wei Yongjun <yjwei@cn.fujitsu.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

On Wed, Jul 06, 2011 at 12:23:50PM -0400, Vladislav Yasevich wrote:
> You are right.  Without a receiver patch, a linux receiver would stay in 0-window condition
> while sending a SHUTDOWN with a_rwnd of 0.
> 
> How about instead of checking for "Not greater then or equals", we instead simply test for
> "less then"?

Agreed

Will repost the patch with your suggestions included and look into the
receiver patch as well.
