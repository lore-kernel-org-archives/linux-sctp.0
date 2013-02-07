From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 07 Feb 2013 14:52:30 +0000
Subject: Re: [PATCH net 0/2] fixes for net/sctp/auth.c
Message-Id: <20130207145230.GC2379@shamino.rdu.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360231701.git.dborkman@redhat.com>
In-Reply-To: <cover.1360231701.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, Feb 07, 2013 at 11:55:35AM +0100, Daniel Borkmann wrote:
> This set fixes two issues in the net/sctp/auth.c implementation.
> 
> Daniel Borkmann (2):
>   net: sctp: sctp_auth_make_key_vector: fix undefined ref-count behaviour
>   net: sctp: sctp_auth_key_put: use kzfree instead of kfree
> 
>  net/sctp/auth.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

