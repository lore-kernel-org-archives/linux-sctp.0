From: David Miller <davem@davemloft.net>
Date: Thu, 06 Apr 2017 20:56:18 +0000
Subject: Re: [PATCH net] sctp: listen on the sock only when it's state is listening or closed
Message-Id: <20170406.135618.1664330530425584626.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <19f73778f8e27b05ee9aa25ece57db6b0e73d197.1491455452.git.lucien.xin@gmail.com>
In-Reply-To: <19f73778f8e27b05ee9aa25ece57db6b0e73d197.1491455452.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, andreyknvl@google.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu,  6 Apr 2017 13:10:52 +0800

> Now sctp doesn't check sock's state before listening on it. It could
> even cause changing a sock with any state to become a listening sock
> when doing sctp_listen.
> 
> This patch is to fix it by checking sock's state in sctp_listen, so
> that it will listen on the sock with right state.
> 
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
