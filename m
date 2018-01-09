From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 09 Jan 2018 01:23:52 +0000
Subject: Re: [PATCH net 0/3] Some sockopt optlen fixes
Message-Id: <20180109012352.GA25809@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515436112.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515436112.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, haliu@redhat.com

On Mon, Jan 08, 2018 at 07:02:26PM -0200, Marcelo Ricardo Leitner wrote:
> Hangbin Liu reported that some SCTP sockopt are allowing the user to get
> the kernel to allocate really large buffers by not having a ceiling on
> optlen.
> 
> This patchset address this issue (in patch 2), replace an GFP_ATOMIC
> that isn't needed and avoid calculating the option size multiple times
> in some setsockopt.
> 
> Marcelo Ricardo Leitner (3):
>   sctp: GFP_ATOMIC is not needed in sctp_setsockopt_events
>   sctp: add a ceiling to optlen in some sockopts
>   sctp: make use of pre-calculated len
> 
>  net/sctp/socket.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> -- 
> 2.14.3
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

