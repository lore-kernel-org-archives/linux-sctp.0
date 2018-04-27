From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 27 Apr 2018 10:04:11 +0000
Subject: Re: [PATCH net-next 00/13] sctp: refactor MTU handling
Message-Id: <CADvbK_c3iePtYUps40aAhDRBqqSQDXs+nZVRnuc=UpX7kVV4zA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Apr 27, 2018 at 3:58 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Currently MTU handling is spread over SCTP stack. There are multiple
> places doing same/similar calculations and updating them is error prone
> as one spot can easily be left out.
>
> This patchset converges it into a more concise and consistent code. In
> general, it moves MTU handling from functions with bigger objectives,
> such as sctp_assoc_add_peer(), to specific functions.
>
> It's also a preparation for the next patchset, which removes the
> duplication between sctp_make_op_error_space and
> sctp_make_op_error_fixed and relies on sctp_mtu_payload introduced here.
>
> More details on each patch.
>
> Marcelo Ricardo Leitner (13):
>   sctp: remove old and unused SCTP_MIN_PMTU
>   sctp: move transport pathmtu calc away of sctp_assoc_add_peer
>   sctp: remove an if() that is always true
>   sctp: introduce sctp_assoc_set_pmtu
>   sctp: introduce sctp_mtu_payload
>   sctp: introduce sctp_assoc_update_frag_point
>   sctp: remove sctp_assoc_pending_pmtu
>   sctp: introduce sctp_dst_mtu
>   sctp: remove sctp_transport_pmtu_check
>   sctp: re-use sctp_transport_pmtu in sctp_transport_route
>   sctp: honor PMTU_DISABLED when handling icmp
>   sctp: consider idata chunks when setting SCTP_MAXSEG
>   sctp: allow unsetting sockopt MAXSEG
>
>  include/net/sctp/constants.h |  5 ++--
>  include/net/sctp/sctp.h      | 52 ++++++++++++++------------------------
>  include/net/sctp/structs.h   |  2 ++
>  net/sctp/associola.c         | 60 +++++++++++++++++++++++---------------------
>  net/sctp/chunk.c             | 12 +--------
>  net/sctp/output.c            | 28 ++++++++-------------
>  net/sctp/socket.c            | 43 ++++++++++++++-----------------
>  net/sctp/transport.c         | 37 ++++++++++++++-------------
>  8 files changed, 105 insertions(+), 134 deletions(-)
>
> --
> 2.14.3
>
Series
Reviewed-by: Xin Long <lucien.xin@gmail.com>
