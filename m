From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Aug 2019 11:02:21 +0000
Subject: Re: [PATCH net-next 0/3] sctp: add SCTP_ECN_SUPPORTED sockopt
Message-Id: <20190826110221.GA7831@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Mon, Aug 26, 2019 at 04:30:01PM +0800, Xin Long wrote:
> This patchset is to make ecn flag per netns and endpoint and then
> add SCTP_ECN_SUPPORTED sockopt, as does for other feature flags.
> 
> Xin Long (3):
>   sctp: make ecn flag per netns and endpoint
>   sctp: allow users to set netns ecn flag with sysctl
>   sctp: allow users to set ep ecn flag by sockopt
> 
>  include/net/netns/sctp.h   |  3 ++
>  include/net/sctp/structs.h |  3 +-
>  include/uapi/linux/sctp.h  |  1 +
>  net/sctp/endpointola.c     |  1 +
>  net/sctp/protocol.c        |  3 ++
>  net/sctp/sm_make_chunk.c   | 16 +++++++---
>  net/sctp/socket.c          | 73 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/sctp/sysctl.c          |  7 +++++
>  8 files changed, 102 insertions(+), 5 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
