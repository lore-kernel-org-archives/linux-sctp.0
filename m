From: David Miller <davem@davemloft.net>
Date: Tue, 20 Aug 2019 01:27:43 +0000
Subject: Re: [PATCH net-next 0/8] sctp: support per endpoint auth and asconf flags
Message-Id: <20190819.182743.22753599842704079.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 22:02:42 +0800

> This patchset mostly does 3 things:
> 
>   1. add per endpint asconf flag and use asconf flag properly
>      and add SCTP_ASCONF_SUPPORTED sockopt.
>   2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
>   3. remove the 'global feature switch' to discard chunks.

Series applied, thanks.
