From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 04:49:32 +0000
Subject: Re: Gap is only retransmitted once
Message-Id: <4D6F1DDC.9000204@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
In-Reply-To: <AANLkTi=gP1+PTa4J+CYzpA8NCmasiMXS_p4P-zXAkyXK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Mingyuan Zhu wrote, at 03/03/2011 09:25 AM:
> So comes the question, why doesn't sctp retransmit immediately when it
> receives SACK, instead it retransmit after 3 seconds?

For this question, answer is that sctp implement it by design.
See rto_initial parameter.

rto_initial - INTEGER
	The initial round trip timeout value in milliseconds that will be used
	in calculating round trip times.  This is the initial time interval
	for retransmissions.

	Default: 3000

-- 
Best Regards
-----
Shan Wei
