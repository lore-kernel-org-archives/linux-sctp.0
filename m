From: David Miller <davem@davemloft.net>
Date: Thu, 26 Dec 2019 21:07:24 +0000
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Message-Id: <20191226.130724.181678918934442450.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
In-Reply-To: <20191226122917.431-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: qdkevin.kou@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, marcelo.leitner@gmail.com

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Thu, 26 Dec 2019 12:29:17 +0000

> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
> and trigger sctp_probe_path_trace in sctp_outq_sack.
 ...

Applied, but why did you remove the trace enabled check, just out of
curiosity?
