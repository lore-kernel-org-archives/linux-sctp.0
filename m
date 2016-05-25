From: David Miller <davem@davemloft.net>
Date: Wed, 25 May 2016 19:24:21 +0000
Subject: Re: [PATCH net] sctp: sctp_diag should dump sctp socket type
Message-Id: <20160525.122421.1141954704190813920.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
In-Reply-To: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, phil@nwl.cc

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 May 2016 03:14:28 +0800

> For sctp_diag, ss support is not officially available, thus there
> are no official users of this yet, so we can add this field in the
> middle of sctp_info without breaking user API.

This is not what matters.

What matters is if a released kernel went out with the existing API.
