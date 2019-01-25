From: David Miller <davem@davemloft.net>
Date: Fri, 25 Jan 2019 02:25:22 +0000
Subject: Re: [PATCH net] sctp: improve the events for sctp stream adding
Message-Id: <20190124.182522.1259000615710256514.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a4261c440ed5821ddd5943ec7ed163004953d8b8.1548096012.git.lucien.xin@gmail.com>
In-Reply-To: <a4261c440ed5821ddd5943ec7ed163004953d8b8.1548096012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Jan 2019 02:40:12 +0800

> This patch is to improve sctp stream adding events in 2 places:
> 
>   1. In sctp_process_strreset_addstrm_out(), move up SCTP_MAX_STREAM
>      and in stream allocation failure checks, as the adding has to
>      succeed after reconf_timer stops for the in stream adding
>      request retransmission.
> 
>   3. In sctp_process_strreset_addstrm_in(), no event should be sent,
>      as no in or out stream is added here.
> 
> Fixes: 50a41591f110 ("sctp: implement receiver-side procedures for the Add Outgoing Streams Request Parameter")
> Fixes: c5c4ebb3ab87 ("sctp: implement receiver-side procedures for the Add Incoming Streams Request Parameter")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
