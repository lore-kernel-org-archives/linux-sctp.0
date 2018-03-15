From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 15 Mar 2018 13:20:17 +0000
Subject: Re: [PATCH net-next 0/5] sctp: add support for some sctp auth APIs from RFC6458
Message-Id: <20180315132017.GA15724@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1521025473.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem@davemloft.net

On Wed, Mar 14, 2018 at 07:05:29PM +0800, Xin Long wrote:
> This patchset mainly adds support for SCTP AUTH Information for sendmsg,
> described in RFC6458:
> 
>     5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)
> 
> and also adds a sockopt described in RFC6458:
> 
>     8.3.4.  Deactivate a Shared Key (SCTP_AUTH_DEACTIVATE_KEY)
> 
> and two types of events for AUTHENTICATION_EVENT described in RFC6458:
> 
>     6.1.8.  SCTP_AUTHENTICATION_EVENT:
>              - SCTP_AUTH_NO_AUTH
>              - SCTP_AUTH_FREE_KEY
> 
> After this patchset, we have fully support for sctp_sendv in kernel.
> 
> Note that this patchset won't touch that sctp options merge conflict.
> 
> Xin Long (5):
>   sctp: add refcnt support for sh_key
>   sctp: add support for SCTP AUTH Information for sendmsg
>   sctp: add sockopt SCTP_AUTH_DEACTIVATE_KEY
>   sctp: add SCTP_AUTH_FREE_KEY type for AUTHENTICATION_EVENT
>   sctp: add SCTP_AUTH_NO_AUTH type for AUTHENTICATION_EVENT
> 
>  include/net/sctp/auth.h    |  21 ++++---
>  include/net/sctp/command.h |   1 +
>  include/net/sctp/sm.h      |   3 +-
>  include/net/sctp/structs.h |  10 +++-
>  include/uapi/linux/sctp.h  |  22 ++++++-
>  net/sctp/auth.c            | 146 +++++++++++++++++++++++++++++++--------------
>  net/sctp/chunk.c           |  14 +++++
>  net/sctp/output.c          |  18 +++++-
>  net/sctp/sm_make_chunk.c   |  33 +++++++++-
>  net/sctp/sm_sideeffect.c   |  13 ++++
>  net/sctp/sm_statefuns.c    |  56 ++++++++++++++---
>  net/sctp/socket.c          |  77 ++++++++++++++++++++++++
>  12 files changed, 342 insertions(+), 72 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

