From: David Miller <davem@davemloft.net>
Date: Thu, 06 Mar 2014 01:47:01 +0000
Subject: Re: [PATCH net] net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk
Message-Id: <20140305.204701.2006215043535025759.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393947351-11664-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1393947351-11664-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yasevich@gmail.com, nhorman@tuxdriver.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue,  4 Mar 2014 16:35:51 +0100

> While working on ec0223ec48a9 ("net: sctp: fix sctp_sf_do_5_1D_ce to
> verify if we/peer is AUTH capable"), we noticed that there's a skb
> memory leakage in the error path.
 ...
> Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks.
