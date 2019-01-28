From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 28 Jan 2019 09:44:44 +0000
Subject: Re: [PATCH net-next 00/24] sctp: support SCTP_FUTURE/CURRENT/ALL_ASSOC
Message-Id: <20190128094444.GA1624@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Mon, Jan 28, 2019 at 03:08:22PM +0800, Xin Long wrote:
> This patchset adds the support for 3 assoc_id constants: SCTP_FUTURE_ASSOC
> SCTP_CURRENT_ASSOC, SCTP_ALL_ASSOC, described in rfc6458#section-7.2:
> 
>    All socket options set on a one-to-one style listening socket also
>    apply to all future accepted sockets.  For one-to-many style sockets,
>    often a socket option will pass a structure that includes an assoc_id
>    field.  This field can be filled with the association identifier of a
>    particular association and unless otherwise specified can be filled
>    with one of the following constants:
> 
>    SCTP_FUTURE_ASSOC:  Specifies that only future associations created
>       after this socket option will be affected by this call.
> 
>    SCTP_CURRENT_ASSOC:  Specifies that only currently existing
>       associations will be affected by this call, and future
>       associations will still receive the previous default value.
> 
>    SCTP_ALL_ASSOC:  Specifies that all current and future associations
>       will be affected by this call.
> 
> The functions for many other sockopts that use assoc_id also need to be
> updated accordingly.
> 
> Xin Long (24):
>   sctp: introduce SCTP_FUTURE/CURRENT/ALL_ASSOC
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_PARAMS sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_RTOINFO sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_ASSOCINFO sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_MAXSEG sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_LOCAL_AUTH_CHUNKS sockopt
>   sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_PR_SUPPORTED sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_RECONFIG_SUPPORTED sockopt
>   sctp: use SCTP_FUTURE_ASSOC for SCTP_INTERLEAVING_SUPPORTED sockopt
>   sctp: add SCTP_CURRENT_ASSOC for SCTP_STREAM_SCHEDULER_VALUE sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_DELAYED_SACK sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_DEFAULT_SEND_PARAM sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_DEFAULT_SNDINFO sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_CONTEXT sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_MAX_BURST sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_AUTH_KEY sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_AUTH_ACTIVE_KEY sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_AUTH_DELETE_KEY sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_AUTH_DEACTIVATE_KEY sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_DEFAULT_PRINFO sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for
>     SCTP_ENABLE_STREAM_RESET sockopt
>   sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_EVENT
>     sockopt
>   sctp: add SCTP_FUTURE_ASOC and SCTP_CURRENT_ASSOC for
>     SCTP_STREAM_SCHEDULER sockopt
> 
>  include/net/sctp/structs.h |   4 +
>  include/uapi/linux/sctp.h  |   4 +
>  net/sctp/associola.c       |   9 +-
>  net/sctp/outqueue.c        |   2 +-
>  net/sctp/socket.c          | 773 ++++++++++++++++++++++++++++++---------------
>  5 files changed, 525 insertions(+), 267 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Sorry, I'm traveling at the moment, but I'll review this as soon as I'm back on the ground
Neil
