From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Aug 2019 14:30:52 +0000
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-Id: <20190819143052.GC2870@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
> flag. With this feature, each endpoint will have its own flag
> for its future asoc's asconf_capable, instead of netns asconf
> flag.

Is this backed by a RFC? If yes, it should be noted in the patch
description.
Quickly searching, I found only FreeBSD references.
