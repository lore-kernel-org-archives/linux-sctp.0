From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Aug 2013 15:29:41 +0000
Subject: Re: [PATCH net-next] net: sctp: reorder sctp_globals to reduce cacheline usage
Message-Id: <20130826152941.GA30662@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377527640-22447-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377527640-22447-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Mon, Aug 26, 2013 at 04:34:00PM +0200, Daniel Borkmann wrote:
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
Acked-by: Neil Horman <nhorman@tuxdriver.com>

