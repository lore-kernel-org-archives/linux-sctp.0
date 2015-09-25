From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 25 Sep 2015 19:52:49 +0000
Subject: Re: [PATCH net 0/2] sctp: Fix SCTP deadlock
Message-Id: <20150925195249.GA3087@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1443111307-16503-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Karl Heiss <kheiss@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On Thu, Sep 24, 2015 at 12:15:05PM -0400, Karl Heiss wrote:
> These patches fix a deadlock during accept() of an SCTP connection.
> 
> The first patch fixes whitespace issues.
> 
> The second patch actually fixes the deadlock race.
> 
> Karl Heiss (2):
>   sctp: Whitespace fix
>   sctp: Prevent soft lockup when sctp_accept() is called during a
>     timeout event
> 
>  net/sctp/sm_sideeffect.c |   44 ++++++++++++++++++++++++--------------------
>  1 files changed, 24 insertions(+), 20 deletions(-)
> 

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

