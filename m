From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 06 Jan 2018 05:05:47 +0000
Subject: Re: [PATCH net v3 0/2] SCTP PMTU discovery fixes
Message-Id: <CADvbK_fXKR5gm_R+piR5pLR3S-39qG=toENagE5j73cDXB=wog@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515152627.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515152627.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Jan 5, 2018 at 9:17 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
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
Reviewed-by: Xin Long <lucien.xin@gmail.com>
