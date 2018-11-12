From: David Miller <davem@davemloft.net>
Date: Mon, 12 Nov 2018 17:10:16 +0000
Subject: Re: [PATCHv2 net-next 0/3] sctp: add support for sk_reuseport
Message-Id: <20181112.091016.2149576070001398879.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542018324.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1542018324.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Nov 2018 18:27:14 +0800

> sctp sk_reuseport allows multiple socks to listen on the same port and
> addresses, as long as these socks have the same uid. This works pretty
> much as TCP/UDP does, the only difference is that sctp is multi-homing
> and all the bind_addrs in these socks will have to completely matched,
> otherwise listen() will return err.
> 
> The below is when 5 sockets are listening on 172.16.254.254:6400 on a
> server, 26 sockets on a client connect to 172.16.254.254:6400 and each
> may be processed by a different socket on the server which is selected
> by hash(lport, pport, paddr) in reuseport_select_sock():
> 
>  # ss --sctp -nn
 ...

Series applied, thanks.
