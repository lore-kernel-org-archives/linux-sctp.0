From: David Miller <davem@davemloft.net>
Date: Tue, 18 Apr 2017 17:40:22 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add proper process for duplicated stream reconf requests
Message-Id: <20170418.134022.1168044044884653759.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1492264734.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1492264734.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 15 Apr 2017 22:00:26 +0800

> Now sctp stream reconf will process a request again even if it's seqno
> is less than asoc->strreset_inseq. It may cause a replay attack.
> 
> This patchset is to avoid it by add proper process for all duplicated
> stream reconf requests.

Series applied, thanks.
