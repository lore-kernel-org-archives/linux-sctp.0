From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 24 Aug 2018 15:29:56 +0000
Subject: Re: [PATCH 0/3] Fixes for kernel feature detection
Message-Id: <CADvbK_dt8G8ksY1nfK+jfmLhPeXRm4kDJEBxNTLnzTwp6tpU2Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535062650.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1535062650.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Aug 24, 2018 at 8:53 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Simple fixes, while the 2nd patch is the most important.
>
> Marcelo Ricardo Leitner (3):
>   build: remove v4.12 secondary defines in favor of
>     HAVE_SCTP_STREAM_RECONFIG
>   build: fix probing for HAVE_SCTP_SENDV
>   build: 0b0dce7a36fb actually belongs to v4.19
>
>  configure.ac                  | 15 +++------------
>  src/include/netinet/sctp.h.in |  2 --
>  2 files changed, 3 insertions(+), 14 deletions(-)
>
> --
> 2.17.1
>
Series Reviewed-by: Xin Long <lucien.xin@gmail.com>
