From: David Miller <davem@davemloft.net>
Date: Wed, 02 May 2018 15:16:45 +0000
Subject: Re: [PATCH net] sctp: use the old asoc when making the cookie-ack chunk in dupcook_d
Message-Id: <20180502.111645.2168255311623555739.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b4d64902d4a8e0774c44752056e35a32d69966a9.1525239586.git.lucien.xin@gmail.com>
In-Reply-To: <b4d64902d4a8e0774c44752056e35a32d69966a9.1525239586.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  2 May 2018 13:39:46 +0800

> When processing a duplicate cookie-echo chunk, for case 'D', sctp will
> not process the param from this chunk. It means old asoc has nothing
> to be updated, and the new temp asoc doesn't have the complete info.
> 
> So there's no reason to use the new asoc when creating the cookie-ack
> chunk. Otherwise, like when auth is enabled for cookie-ack, the chunk
> can not be set with auth, and it will definitely be dropped by peer.
> 
> This issue is there since very beginning, and we fix it by using the
> old asoc instead.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
