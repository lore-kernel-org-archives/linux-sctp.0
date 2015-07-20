From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 20 Jul 2015 14:43:02 +0000
Subject: Re: [PATCH v2 0/2] sctp: fix src address selection if using secondary address
Message-Id: <20150720144302.GB10706@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1437145508.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1437145508.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>

On Fri, Jul 17, 2015 at 12:34:16PM -0300, Marcelo Ricardo Leitner wrote:
> This series improves the way SCTP chooses its src address so that the
> choosen one will always belong to the interface being used for output.
> 
> v1->v2:
>  - split out the refactoring from the fix itself
>  - Doing a full reverse routing as in v1 is not necessary. Only looking
>    for the interface that has the address and comparing its number is
>    enough.
> 
> Marcelo Ricardo Leitner (2):
>   sctp: reduce indent level on sctp_v4_get_dst
>   sctp: fix src address selection if using secondary addresses
> 
>  net/sctp/protocol.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> -- 
> 2.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>

