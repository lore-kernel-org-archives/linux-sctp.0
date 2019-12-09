From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 09 Dec 2019 12:26:49 +0000
Subject: Re: [PATCHv2 net] sctp: get netns from asoc and ep base
Message-Id: <20191209122649.GA5058@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
In-Reply-To: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Dec 09, 2019 at 01:45:18PM +0800, Xin Long wrote:
> Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
> in asoc and ep base since they're created, and it will never change.
> It's a better way to get netns from asoc and ep base, comparing to
> calling sock_net().
> 
> This patch is to replace them.
> 
> v1->v2:
>   - no change.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
