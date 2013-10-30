From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 30 Oct 2013 11:29:07 +0000
Subject: Re: [PATCH net-next 0/5] SCTP fix/updates
Message-Id: <20131030112907.GB10220@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Wed, Oct 30, 2013 at 11:50:47AM +0100, Daniel Borkmann wrote:
> Please see patch 5 for the main description/motivation, the rest just
> brings in the needed functionality for that. Although this is actually
> a fix, I've based it against net-next as some additional work for
> fixing it was needed.
> 
> Thanks!
> 
> Daniel Borkmann (5):
>   lib: crc32: clean up spacing in test cases
>   lib: crc32: add functionality to combine two crc32{,c}s in GF(2)
>   lib: crc32: add test cases for crc32{,c}_combine routines
>   net: skb_checksum: allow custom update/combine for walking skb
>   net: sctp: fix and consolidate SCTP checksumming code
> 
>  include/linux/crc32.h       |  40 ++++
>  include/linux/skbuff.h      |  13 +-
>  include/net/checksum.h      |   6 +
>  include/net/sctp/checksum.h |  56 ++----
>  lib/crc32.c                 | 453 +++++++++++++++++++++++++-------------------
>  net/core/skbuff.c           |  31 ++-
>  net/sctp/output.c           |   9 +-
>  7 files changed, 350 insertions(+), 258 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
