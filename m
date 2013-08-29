From: David Miller <davem@davemloft.net>
Date: Thu, 29 Aug 2013 18:56:06 +0000
Subject: Re: [PATCH net-next] net: sctp: reorder sctp_globals to reduce cacheline usage
Message-Id: <20130829.145606.1418884404797972654.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377527640-22447-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377527640-22447-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 26 Aug 2013 16:34:00 +0200

> Reduce cacheline usage from 2 to 1 cacheline for sctp_globals structure. By
> reordering elements, we can close gaps and simply achieve the following:
> 
> Current situation:
>   /* size: 80, cachelines: 2, members: 10 */
>   /* sum members: 57, holes: 4, sum holes: 16 */
>   /* padding: 7 */
>   /* last cacheline: 16 bytes */
> 
> Afterwards:
>   /* size: 64, cachelines: 1, members: 10 */
>   /* padding: 7 */
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
