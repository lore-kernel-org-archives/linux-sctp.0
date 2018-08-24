From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 13:01:36 +0000
Subject: Re: [PATCH 0/3] Fixes for kernel feature detection
Message-Id: <20180824130136.GM5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535062650.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1535062650.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Sorry, forgot the tag.

On Fri, Aug 24, 2018 at 09:52:57AM -0300, Marcelo Ricardo Leitner wrote:
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
