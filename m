From: David Miller <davem@davemloft.net>
Date: Fri, 26 Aug 2016 18:43:38 +0000
Subject: Re: [PATCH net] veth: sctp: add NETIF_F_SCTP_CRC to device features
Message-Id: <20160826.114338.1613853981669207386.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3b9880c091c96f4e6780b96b4f3e2c4d38dffe42.1472102509.git.lucien.xin@gmail.com>
In-Reply-To: <3b9880c091c96f4e6780b96b4f3e2c4d38dffe42.1472102509.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 25 Aug 2016 13:21:49 +0800

> Commit b17c706987fa ("loopback: sctp: add NETIF_F_SCTP_CSUM to device
> features") added NETIF_F_SCTP_CRC to device features for lo device to
> improve the performance of sctp over lo.
> 
> This patch is to add NETIF_F_SCTP_CRC to device features for veth to
> improve the performance of sctp over veth.
 ...
> Tested-by: Li Shuang <tjlishuang@yeah.net>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied to net-next, thanks.
