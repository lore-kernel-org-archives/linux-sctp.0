From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 13 Feb 2018 13:11:29 +0000
Subject: Re: [PATCHv2 net 0/2] sctp: rename sctp diag file and add file comments for it
Message-Id: <20180213131129.GD26100@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1518521415.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1518521415.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Feb 13, 2018 at 07:33:19PM +0800, Xin Long wrote:
> This patchset is to remove the sctp_ prefix for sctp diag file,
> and also to add the missing file comments for it.
> 
> v1->v2:
>   split them into two patches as Marcelo suggested.
> 
> Xin Long (2):
>   sctp: rename sctp_diag.c as diag.c
>   sctp: add file comments in diag.c
> 
>  net/sctp/Makefile    |   2 +
>  net/sctp/diag.c      | 557 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/sctp/sctp_diag.c | 526 ------------------------------------------------
>  3 files changed, 559 insertions(+), 526 deletions(-)
>  create mode 100644 net/sctp/diag.c
>  delete mode 100644 net/sctp/sctp_diag.c
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

