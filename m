From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 20 Jan 2014 11:37:06 +0000
Subject: Re: [PATCH net-next 0/2] sctp: some small clean ups
Message-Id: <52DD0A62.9050807@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1390217247-9408-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1390217247-9408-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 01/20/2014 12:27 PM, Wang Weidong wrote:
> We have the macros in sctp.h, so use them for coding accordance
> in sctp.

Thanks for doing this Wang.

I am actually wondering why we have these macro locking wrappers
and not use these functions directly? Hm, any reasons? Maybe we
should rather go in the other direction with this?

> Wang Weidong (2):
>    sctp: use sctp_local_bh_{disable|enable} instead
>      local_bh_{disable|enable}
>    sctp: use sctp_read_[un]lock instead of read_[un]lock
>
>   net/sctp/endpointola.c   |  4 ++--
>   net/sctp/input.c         | 10 +++++-----
>   net/sctp/proc.c          | 12 ++++++------
>   net/sctp/sm_make_chunk.c |  8 ++++----
>   net/sctp/socket.c        |  8 ++++----
>   5 files changed, 21 insertions(+), 21 deletions(-)
>
