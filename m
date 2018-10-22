From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 22 Oct 2018 14:20:52 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add support for sk_reuseport
Message-Id: <20181022142052.GN6634@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1540095102.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1540095102.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Sun, Oct 21, 2018 at 12:43:35PM +0800, Xin Long wrote:
> sctp sk_reuseport allows multiple socks to listen on the same port and
> addresses, as long as these socks have the same uid. This works pretty
> much as TCP/UDP does, the only difference is that sctp is multi-homing
> and all the bind_addrs in these socks will have to completely matched,
> otherwise listen() will return err.
> 

FWIW, I won't be able to review this patchset thoroughly. The 2 small
comments that I sent are all I have.

Thanks,
Marcelo
