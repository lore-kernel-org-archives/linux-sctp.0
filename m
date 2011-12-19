From: Thomas Graf <tgraf@infradead.org>
Date: Mon, 19 Dec 2011 23:19:36 +0000
Subject: Re: [PATCH] sctp: Do not account for sizeof(struct sk_buff) in
Message-Id: <20111219231936.GA21801@canuck.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1324303900-8360-1-git-send-email-tgraf@redhat.com>
In-Reply-To: <1324303900-8360-1-git-send-email-tgraf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org

On Mon, Dec 19, 2011 at 03:11:40PM +0100, Thomas Graf wrote:
> Trying to reproduce this I found that with the sk_buff overhead removed,
> the performance would improve significantly unless socket buffer limits
> are increased.

I believe this is likely to be misunderstood. What I meant is that by
removing the sk_buff overhead and while using default socket buffer limits
the performance increases as shown below. If socket buffers are enlarged
performance differences fade until there is no longer any difference.

Sorry for poor wording.

> The following numbers have been gathered using a patched iperf
> supporting SCTP over a live 1 Gbit ethernet network. The -l option
> was used to limit DATA chunk sizes. The numbers listed are based on
> the average of 3 test runs each. Default values have been used for
> sk_(r|w)mem.
> 
> Chunk
> Size    Unpatched     No Overhead
> -------------------------------------
>    4    15.2 Kbit [!]   12.2 Mbit [!]
>    8    35.8 Kbit [!]   26.0 Mbit [!]
>   16    95.5 Kbit [!]   54.4 Mbit [!]
>   32   106.7 Mbit      102.3 Mbit
>   64   189.2 Mbit      188.3 Mbit
>  128   331.2 Mbit      334.8 Mbit
>  256   537.7 Mbit      536.0 Mbit
>  512   766.9 Mbit      766.6 Mbit
> 1024   810.1 Mbit      808.6 Mbit
