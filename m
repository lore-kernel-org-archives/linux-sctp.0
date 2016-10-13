From: David Miller <davem@davemloft.net>
Date: Thu, 13 Oct 2016 13:44:56 +0000
Subject: Re: [PATCH net-next] sctp: remove the old ttl expires policy
Message-Id: <20161013.094456.2092429969925371125.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <db5df5806c3c0b7c37ab9039a906664a33c74563.1475898016.git.lucien.xin@gmail.com>
In-Reply-To: <db5df5806c3c0b7c37ab9039a906664a33c74563.1475898016.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  8 Oct 2016 11:40:16 +0800

> The prsctp polices include ttl expires policy already, we should remove
> the old ttl expires codes, and just adjust the new polices' codes to be
> compatible with the old one for users.
> 
> This patch is to remove all the old expires codes, and if prsctp polices
> are not set, it will still set msg's expires_at and check the expires in
> sctp_check_abandoned.
> 
> Note that asoc->prsctp_enable is set by default, so users can't feel any
> difference even if they use the old expires api in userspace.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
