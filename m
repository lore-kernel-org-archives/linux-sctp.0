From: David Miller <davem@davemloft.net>
Date: Thu, 16 Nov 2017 01:49:47 +0000
Subject: Re: [PATCHv2 net] sctp: use the right sk after waking up from wait_buf sleep
Message-Id: <20171116.104947.1173420790283087407.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a9890f37f327c3765a58247636e6586c7439ae62.1510736246.git.lucien.xin@gmail.com>
In-Reply-To: <a9890f37f327c3765a58247636e6586c7439ae62.1510736246.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 15 Nov 2017 16:57:26 +0800

> Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
> sleeping on it") fixed the race between peeloff and wait sndbuf by
> checking waitqueue_active(&asoc->wait) in sctp_do_peeloff().
> 
> But it actually doesn't work, as even if waitqueue_active returns false
> the waiting sndbuf thread may still not yet hold sk lock. After asoc is
> peeled off, sk is not asoc->base.sk any more, then to hold the old sk
> lock couldn't make assoc safe to access.
> 
> This patch is to fix this by changing to hold the new sk lock if sk is
> not asoc->base.sk, meanwhile, also set the sk in sctp_sendmsg with the
> new sk.
> 
> With this fix, there is no more race between peeloff and waitbuf, the
> check 'waitqueue_active' in sctp_do_peeloff can be removed.
> 
> Thanks Marcelo and Neil for making this clear.
> 
> v1->v2:
>   fix it by changing to lock the new sock instead of adding a flag in asoc.
> 
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
