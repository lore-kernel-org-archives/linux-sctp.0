From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 14 Jun 2013 17:00:54 +0000
Subject: Re: [PATCH net-next v3 0/4] Some SCTP cleanups/improvements
Message-Id: <51BB4C46.2080506@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371227047-16852-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1371227047-16852-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06/14/2013 12:24 PM, Daniel Borkmann wrote:
> v2 -> v3:
>    - Applied feedback from Vlad in first patch, rest is unchanged
>
> v1 -> v2:
>    - Applied Neil's feedback, I'll send out the first patch at a later
>      point in time though, have not included it in this set
>    - Add two other patches that appear to be useful from the last
>      couple of days debugging SCTP code
>
> Let it run through lksctp-tools and also my recent stress test tool,
> all looks good.

Looks good.

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

>
> Daniel Borkmann (4):
>    net: sctp: sideeffect: throw BUG if primary_path is NULL
>    net: sctp: sctp_sf_do_prm_asoc: do SCTP_CMD_INIT_CHOOSE_TRANSPORT first
>    net: sctp: minor: remove variable in sctp_init_sock
>    net: sctp: sctp_association_init: put refs in reverse order
>
>   net/sctp/associola.c     |  7 +++----
>   net/sctp/proc.c          | 19 ++++++++++++++++---
>   net/sctp/sm_sideeffect.c |  5 ++++-
>   net/sctp/sm_statefuns.c  |  8 ++++----
>   net/sctp/socket.c        |  6 ++----
>   5 files changed, 29 insertions(+), 16 deletions(-)
>

