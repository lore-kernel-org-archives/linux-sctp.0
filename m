From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 02 Aug 2018 11:21:59 +0000
Subject: Re: [PATCH lksctp-tools] doc: update docs to match current rfc documents
Message-Id: <20180802112159.GA28190@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <6b56ee62ae03b3ed19091c75346b558545109c34.1533140089.git.marcelo.leitner@gmail.com>
In-Reply-To: <6b56ee62ae03b3ed19091c75346b558545109c34.1533140089.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 01, 2018 at 01:33:03PM -0300, Marcelo Ricardo Leitner wrote:
> We applied some changes to the docs but forgot to update Makefile.am to
> reflect them, so currently 'make distcheck' fails with some files not
> being found.
> 
> This patch syncs it with the current folder content.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  doc/Makefile.am | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/doc/Makefile.am b/doc/Makefile.am
> index 6e7c648acf89f1c1264c3f05dc8b1781536301a7..6ed32b80633c2a7c3f19953ecdf2c16c4f509b22 100644
> --- a/doc/Makefile.am
> +++ b/doc/Makefile.am
> @@ -2,10 +2,11 @@ include $(top_srcdir)/Makefile.vars
>  include $(top_srcdir)/Makefile.rules
>  
>  internet_drafts = \
> -   draft-ietf-tsvwg-sctpsocket-14.txt \
> -   draft-ietf-tsvwg-addip-sctp-15.txt
> +	draft-stewart-tsvwg-sctpipv6-00.txt \
> +	draft-stewart-tsvwg-sctpscore-01.txt
>  
> -rfcs = rfc2960.txt rfc3309.txt rfc3257.txt rfc3286.txt rfc3758.txt \
> -       rfc3873.txt rfc4460.txt 
> +rfcs = rfc2960.txt rfc3257.txt rfc3286.txt rfc3309.txt rfc3554.txt \
> +       rfc3758.txt rfc3873.txt rfc4460.txt rfc4820.txt rfc4895.txt \
> +       rfc4960.txt rfc5061.txt rfc5062.txt rfc6458.txt
>  
>  EXTRA_DIST += $(rfcs) $(internet_drafts)
> -- 
> 2.17.1
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
