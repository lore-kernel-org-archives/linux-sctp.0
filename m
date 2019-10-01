From: David Miller <davem@davemloft.net>
Date: Tue, 01 Oct 2019 22:30:46 +0000
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing listening sk backlog
Message-Id: <20191001.153046.1642212253518211617.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
In-Reply-To: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 30 Sep 2019 21:10:18 +0800

> This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
 ...

Marcel and Neil, please review.
