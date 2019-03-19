From: David Miller <davem@davemloft.net>
Date: Tue, 19 Mar 2019 01:31:40 +0000
Subject: Re: [PATCH net 00/13] sctp: fix ignoring asoc_id for tcp-style sockets on some setsockopts
Message-Id: <20190318.183140.473186602081749388.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1552910681.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1552910681.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 20:05:58 +0800

> This is a patchset to fix ignoring asoc_id for tcp-style sockets on
> some setsockopts, introduced by SCTP_CURRENT_ASSOC of the patchset:
> 
>   [net-next,00/24] sctp: support SCTP_FUTURE/CURRENT/ALL_ASSOC
>   (https://patchwork.ozlabs.org/cover/1031706/)
> 
> As Marcelo suggested, we fix it on each setsockopt that is using
> SCTP_CURRENT_ASSOC one by one by adding the check:
> 
>     if (sctp_style(sk, TCP))
>         	xxx.xxx_assoc_id = SCTP_FUTURE_ASSOC;
> 
> so that assoc_id will be completely ingored for tcp-style socket on
> setsockopts, and works as SCTP_FUTURE_ASSOC.

Series applied, thanks Xin.
