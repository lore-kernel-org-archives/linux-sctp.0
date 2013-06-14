From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 14 Jun 2013 14:07:00 +0000
Subject: Re: [PATCH net-next 0/4] Some SCTP cleanups/improvements
Message-Id: <20130614140700.GA19213@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371139463-12512-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1371139463-12512-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, Jun 13, 2013 at 06:04:19PM +0200, Daniel Borkmann wrote:
> v1 -> v2:
>   - Apply Neil's feedback, I'll send out the first patch at a later
>     point in time though, have not included it in this set
>   - Add two other patches that appear to be useful from the last
>     couple of days debugging SCTP code
> 
> Daniel Borkmann (4):
>   net: sctp: throw BUG if primary_path in sctp_seq_dump_local_addrs is NULL
>   net: sctp: sctp_sf_do_prm_asoc: do SCTP_CMD_INIT_CHOOSE_TRANSPORT first
>   net: sctp: minor: remove variable in sctp_init_sock
>   net: sctp: sctp_association_init: put refs in reverse order on error
> 
>  net/sctp/associola.c    |  7 +++----
>  net/sctp/proc.c         | 15 ++++++++++++---
>  net/sctp/sm_statefuns.c |  8 ++++----
>  net/sctp/socket.c       |  6 ++----
>  4 files changed, 21 insertions(+), 15 deletions(-)
> 
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

For the series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
