From: David Miller <davem@davemloft.net>
Date: Tue, 01 Mar 2016 22:25:51 +0000
Subject: Re: [PATCH net] sctp: lack the check for ports in sctp_v6_cmp_addr
Message-Id: <20160301.172551.1571133128115239882.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <415cb449b7811635a13245e5ec99a5679516524a.1456625031.git.lucien.xin@gmail.com>
In-Reply-To: <415cb449b7811635a13245e5ec99a5679516524a.1456625031.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 28 Feb 2016 10:03:51 +0800

> As the member .cmp_addr of sctp_af_inet6, sctp_v6_cmp_addr should also check
> the port of addresses, just like sctp_v4_cmp_addr, cause it's invoked by
> sctp_cmp_addr_exact().
> 
> Now sctp_v6_cmp_addr just check the port when two addresses have different
> family, and lack the port check for two ipv6 addresses. that will make
> sctp_hash_cmp() cannot work well.
> 
> so fix it by adding ports comparison in sctp_v6_cmp_addr().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
