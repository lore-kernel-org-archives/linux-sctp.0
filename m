From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 30 Oct 2013 14:29:48 +0000
Subject: Re: [PATCH net-next 0/5] SCTP fix/updates
Message-Id: <527117DC.3030400@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 10/30/2013 06:50 AM, Daniel Borkmann wrote:
> Please see patch 5 for the main description/motivation, the rest just
> brings in the needed functionality for that. Although this is actually
> a fix, I've based it against net-next as some additional work for
> fixing it was needed.
>
> Thanks!
>
> Daniel Borkmann (5):
>    lib: crc32: clean up spacing in test cases
>    lib: crc32: add functionality to combine two crc32{,c}s in GF(2)
>    lib: crc32: add test cases for crc32{,c}_combine routines
>    net: skb_checksum: allow custom update/combine for walking skb
>    net: sctp: fix and consolidate SCTP checksumming code
>
>   include/linux/crc32.h       |  40 ++++
>   include/linux/skbuff.h      |  13 +-
>   include/net/checksum.h      |   6 +
>   include/net/sctp/checksum.h |  56 ++----
>   lib/crc32.c                 | 453 +++++++++++++++++++++++++-------------------
>   net/core/skbuff.c           |  31 ++-
>   net/sctp/output.c           |   9 +-
>   7 files changed, 350 insertions(+), 258 deletions(-)
>

Series
Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
