From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 05 Jan 2018 15:20:08 +0000
Subject: Re: [PATCH net v3 0/2] SCTP PMTU discovery fixes
Message-Id: <20180105152008.GA18004@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515152627.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515152627.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

On Fri, Jan 05, 2018 at 11:17:16AM -0200, Marcelo Ricardo Leitner wrote:
> This patchset fixes 2 issues with PMTU discovery that can lead to flood
> of retransmissions.
> The first patch fixes the issue for when PMTUD is disabled by the
> application, while the second fixes it for when its enabled.
> 
> Please consider these to stable.
> 
> Thanks,
> 
> Marcelo Ricardo Leitner (2):
>   sctp: do not retransmit upon FragNeeded if PMTU discovery is disabled
>   sctp: fix the handling of ICMP Frag Needed for too small MTUs
> 
>  include/net/sctp/structs.h |  2 +-
>  net/sctp/input.c           | 28 ++++++++++++++++------------
>  net/sctp/transport.c       | 29 +++++++++++++++++++----------
>  3 files changed, 36 insertions(+), 23 deletions(-)
> 
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

