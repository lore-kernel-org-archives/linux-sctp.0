From: David Miller <davem@davemloft.net>
Date: Fri, 30 Sep 2016 06:08:05 +0000
Subject: Re: [PATCHv3 net 0/3] sctp: a bunch of fixes for prsctp polices
Message-Id: <20160930.020805.696758129244744153.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1475087147.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1475087147.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Sep 2016 02:37:25 +0800

> This patchset is to fix 2 issues for prsctp polices:
> 
>   1. patch 1 and 2 fix "netperf-Throughput_Mbps -37.2% regression" issue
>      when overloading the CPU.
> 
>   2. patch 3 fix "prsctp polices should check both sides' prsctp_capable,
>      instead of only local side".

Series applied, thanks.
