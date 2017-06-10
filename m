From: David Miller <davem@davemloft.net>
Date: Sat, 10 Jun 2017 20:23:57 +0000
Subject: Re: [PATCHv2 net-next] sctp: no need to check assoc id before calling sctp_assoc_set_id
Message-Id: <20170610.162357.1913351871329909555.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ea556c7733c5bf63532ce35186e4bc7a519bf858.1497079632.git.lucien.xin@gmail.com>
In-Reply-To: <ea556c7733c5bf63532ce35186e4bc7a519bf858.1497079632.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2017 15:27:12 +0800

> sctp_assoc_set_id does the assoc id check in the beginning when
> processing dupcookie, no need to do the same check before calling
> it.
> 
> v1->v2:
>   fix some typo errs Marcelo pointed in changelog.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thanks.
