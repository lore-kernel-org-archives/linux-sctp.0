From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 17 Jun 2013 13:56:06 +0000
Subject: Re: [PATCH net-next 0/2] Two SCTP cleanup patches
Message-Id: <51BF1576.4080203@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371462005-19310-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1371462005-19310-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06/17/2013 05:40 AM, Daniel Borkmann wrote:
> Two cleanup-only patches to make the code more readable and consistent
> with the rest of the kernel code.
>
> Daniel Borkmann (2):
>    net: sctp: get rid of t_new macro for kzalloc
>    net: sctp: remove SCTP_STATIC macro
>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
>   include/net/sctp/sctp.h  | 11 -------
>   net/sctp/associola.c     |  2 +-
>   net/sctp/bind_addr.c     |  2 +-
>   net/sctp/chunk.c         |  2 +-
>   net/sctp/endpointola.c   |  3 +-
>   net/sctp/input.c         |  4 +--
>   net/sctp/ipv6.c          |  6 ++--
>   net/sctp/protocol.c      |  6 ++--
>   net/sctp/sm_make_chunk.c | 10 +++----
>   net/sctp/socket.c        | 78 ++++++++++++++++++++++--------------------------
>   net/sctp/transport.c     |  2 +-
>   net/sctp/tsnmap.c        | 10 +++----
>   net/sctp/ulpevent.c      | 10 +++----
>   13 files changed, 64 insertions(+), 82 deletions(-)
>

