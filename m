From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sun, 24 Nov 2019 02:29:19 +0000
Subject: Re: [PATCH net] sctp: cache netns in sctp_ep_common
Message-Id: <20191123182919.310d5bf6@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
In-Reply-To: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Sat, 23 Nov 2019 11:56:49 +0800, Xin Long wrote:
> This patch is to fix a data-race reported by syzbot:
> 
>   BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj

> It was caused by rhashtable access asoc->base.sk when sctp_assoc_migrate
> is changing its value. However, what rhashtable wants is netns from asoc
> base.sk, and for an asoc, its netns won't change once set. So we can
> simply fix it by caching netns since created.
> 
> Fixes: d6c0256a60e6 ("sctp: add the rhashtable apis for sctp global transport hashtable")
> Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you!
