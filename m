From: David Miller <davem@davemloft.net>
Date: Fri, 14 Jul 2017 16:05:45 +0000
Subject: Re: [PATCH net] sctp: fix an array overflow when all ext chunks are set
Message-Id: <20170714.090545.1943040429462176763.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3e78f6040b834ee9221cd2ebf539324499a8bb4f.1500041253.git.lucien.xin@gmail.com>
In-Reply-To: <3e78f6040b834ee9221cd2ebf539324499a8bb4f.1500041253.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 14 Jul 2017 22:07:33 +0800

> Marcelo noticed an array overflow caused by commit c28445c3cb07
> ("sctp: add reconf_enable in asoc ep and netns"), in which sctp
> would add SCTP_CID_RECONF into extensions when reconf_enable is
> set in sctp_make_init and sctp_make_init_ack.
> 
> Then now when all ext chunks are set, 4 ext chunk ids can be put
> into extensions array while extensions array size is 3. It would
> cause a kernel panic because of this overflow.
> 
> This patch is to fix it by defining extensions array size is 4 in
> both sctp_make_init and sctp_make_init_ack.
> 
> Fixes: c28445c3cb07 ("sctp: add reconf_enable in asoc ep and netns")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
