From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 03 May 2018 01:24:02 +0000
Subject: Re: [PATCH] sctp: fix a potential missing-check bug
Message-Id: <20180503012402.GK5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1525310145-28102-1-git-send-email-wang6495@umn.edu>
In-Reply-To: <1525310145-28102-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Wed, May 02, 2018 at 08:15:45PM -0500, Wenwen Wang wrote:
> In sctp_setsockopt_maxseg(), the integer 'val' is compared against min_len
> and max_len to check whether it is in the appropriate range. If it is not,
> an error code -EINVAL will be returned. This is enforced by a security
> check. But, this check is only executed when 'val' is not 0. In fact, if
> 'val' is 0, it will be assigned with a new value (if the return value of
> the function sctp_id2assoc() is not 0) in the following execution. However,
> this new value of 'val' is not checked before it is used to assigned to
> asoc->user_frag. That means it is possible that the new value of 'val'
> could be out of the expected range. This can cause security issues
> such as buffer overflows, e.g., the new value of 'val' is used as an index
> to access a buffer.
>
> This patch inserts a check for the new value of 'val' to see if it is in
> the expected range. If it is not, an error code -EINVAL will be returned.
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  net/sctp/socket.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)

?
This patch is the same as previous one. git send-email <old file>
maybe?

  Marcelo
