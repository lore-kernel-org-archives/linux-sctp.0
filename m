From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 14 Dec 2017 19:58:20 +0000
Subject: Re: [PATCHv2 net-next 0/8] sctp: Implement Stream Interleave: Interaction with Other SCTP Extensions
Message-Id: <20171214195820.GB30889@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Fri, Dec 15, 2017 at 12:41:24AM +0800, Xin Long wrote:
> Stream Interleave would be implemented in two Parts:
> 
>    1. The I-DATA Chunk Supporting User Message Interleaving
>    2. Interaction with Other SCTP Extensions
> 
> Overview in section 2.3 of RFC8260 for Part 2:
> 
>    The usage of the I-DATA chunk might interfere with other SCTP
>    extensions.  Future SCTP extensions MUST describe if and how they
>    interfere with the usage of I-DATA chunks.  For the SCTP extensions
>    already defined when this document was published, the details are
>    given in the following subsections.
> 
> As the 2nd part of Stream Interleave Implementation, this patchset mostly
> adds the support for SCTP Partial Reliability Extension with I-FORWARD-TSN
> chunk. Then adjusts stream scheduler and stream reconfig to make them work
> properly with I-DATA chunks.
> 
> In the last patch, all stream interleave codes will be enabled by adding
> sysctl to allow users to use this feature.
> 
> v1 -> v2:
>   - removed the intl_enable check from sctp_chunk_event_lookup, as Marcelo's
>     suggestion.
>   - fixed a typo in changelog.
> 
> Xin Long (8):
>   sctp: add basic structures and make chunk function for ifwdtsn
>   sctp: implement generate_ftsn for sctp_stream_interleave
>   sctp: implement validate_ftsn for sctp_stream_interleave
>   sctp: implement report_ftsn for sctp_stream_interleave
>   sctp: implement handle_ftsn for sctp_stream_interleave
>   sctp: add stream interleave support in stream scheduler
>   sctp: update mid instead of ssn when doing stream and asoc reset
>   sctp: support sysctl to allow users to use stream interleave
> 
>  include/linux/sctp.h                 |  17 +++
>  include/net/sctp/sm.h                |   3 +
>  include/net/sctp/stream_interleave.h |   7 ++
>  include/net/sctp/structs.h           |  12 ++
>  net/sctp/outqueue.c                  |  12 +-
>  net/sctp/sm_make_chunk.c             |  24 ++++
>  net/sctp/sm_sideeffect.c             |  24 +---
>  net/sctp/sm_statefuns.c              |  24 ++--
>  net/sctp/sm_statetable.c             |   4 +-
>  net/sctp/stream.c                    |  46 +++++---
>  net/sctp/stream_interleave.c         | 216 +++++++++++++++++++++++++++++++++++
>  net/sctp/stream_sched.c              |   3 +-
>  net/sctp/sysctl.c                    |   7 ++
>  13 files changed, 334 insertions(+), 65 deletions(-)
> 
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
For the series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
