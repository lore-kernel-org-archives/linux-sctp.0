From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 22 Jul 2020 20:46:47 +0000
Subject: Re: [PATCH net 0/2] sctp: shrink stream outq in the right place
Message-Id: <20200722204647.GB3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1595433039.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1595433039.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, Jul 22, 2020 at 11:52:10PM +0800, Xin Long wrote:
> Patch 1 is an improvement, and Patch 2 is a bug fix.
> 
> Xin Long (2):
>   sctp: shrink stream outq only when new outcnt < old outcnt
>   sctp: shrink stream outq when fails to do addstream reconf

Nice changelogs, thanks.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
