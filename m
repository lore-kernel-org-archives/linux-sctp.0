From: David Miller <davem@davemloft.net>
Date: Tue, 14 Feb 2017 16:26:04 +0000
Subject: Re: [PATCH net-next] sctp: change to use uint<size>_t in uapi sctp.h
Message-Id: <20170214.112604.827348279100654183.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <05fb9cd9aed85d33cc8d635a18b0dcd3e7c0ff29.1487060628.git.lucien.xin@gmail.com>
In-Reply-To: <05fb9cd9aed85d33cc8d635a18b0dcd3e7c0ff29.1487060628.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 14 Feb 2017 16:23:48 +0800

> All structures in uapi sctp.h are exported for userspace, their members'
> types should use uint<size>_t instead of __u<size>.

This is not true.

__u<size> is in fact preferred for userspace exported datastructures.
