From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 03 Jul 2018 10:50:53 +0000
Subject: Re: [PATCHv2 net-next 0/5] sctp: fully support for dscp and flowlabel per transport
Message-Id: <20180703105053.GA20268@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1530526661.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1530526661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net, hideaki.yoshifuji@miraclelinux.com

On Mon, Jul 02, 2018 at 06:21:10PM +0800, Xin Long wrote:
> Now dscp and flowlabel are set from sock when sending the packets,
> but being multi-homing, sctp also supports for dscp and flowlabel
> per transport, which is described in section 8.1.12 in RFC6458.
> 
> v1->v2:
>   - define ip_queue_xmit as inline in net/ip.h, instead of exporting
>     it in Patch 1/5 according to David's suggestion.
>   - fix the param len check in sctp_s/getsockopt_peer_addr_params()
>     in Patch 3/5 to guarantee that an old app built with old kernel
>     headers could work on the newer kernel per Marcelo's point.
> 
> Xin Long (5):
>   ipv4: add __ip_queue_xmit() that supports tos param
>   sctp: add support for dscp and flowlabel per transport
>   sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams
>   sctp: add support for setting flowlabel when adding a transport
>   sctp: check for ipv6_pinfo legal sndflow with flowlabel in
>     sctp_v6_get_dst
> 
>  include/linux/sctp.h       |   7 ++
>  include/net/ip.h           |   9 ++-
>  include/net/sctp/structs.h |   9 +++
>  include/uapi/linux/sctp.h  |   4 +
>  net/ipv4/ip_output.c       |   9 ++-
>  net/sctp/associola.c       |  15 ++++
>  net/sctp/ipv6.c            |  20 ++++-
>  net/sctp/protocol.c        |  16 +++-
>  net/sctp/socket.c          | 182 +++++++++++++++++++++++++++++++++++++++++++--
>  9 files changed, 254 insertions(+), 17 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
For the Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

