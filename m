From: David Miller <davem@davemloft.net>
Date: Wed, 16 Jan 2019 21:38:49 +0000
Subject: Re: [PATCH net] sctp: allocate sctp_sockaddr_entry with kzalloc
Message-Id: <20190116.133849.1334161442048173947.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b1033e296052216772051e87ba5aa61bfc222076.1547462042.git.lucien.xin@gmail.com>
In-Reply-To: <b1033e296052216772051e87ba5aa61bfc222076.1547462042.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, glider@google.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Jan 2019 18:34:02 +0800

> The similar issue as fixed in Commit 4a2eb0c37b47 ("sctp: initialize
> sin6_flowinfo for ipv6 addrs in sctp_inet6addr_event") also exists
> in sctp_inetaddr_event, as Alexander noticed.
> 
> To fix it, allocate sctp_sockaddr_entry with kzalloc for both sctp
> ipv4 and ipv6 addresses, as does in sctp_v4/6_copy_addrlist().
> 
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
