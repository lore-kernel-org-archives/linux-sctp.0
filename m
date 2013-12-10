From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 10 Dec 2013 12:51:04 +0000
Subject: Re: [PATCH v6 0/3] sctp: check the rto_min and rto_max
Message-Id: <52A70E38.9020906@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386643597-22156-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1386643597-22156-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 12/10/2013 03:46 AM, Wang Weidong wrote:
> v5 -> v6
>    -patch1: do rto_min/max socket option handling in its own patch, and
>     fix the check of rto_min/max.
>    -patch2: do rto_min/max sysctl handling in its own patch.
>    -patch3: add Suggested-by Daniel.

Fyi, for future submission, please keep the full changelog.

I would have much rather liked seeing you with finishing the last
2 patches first, and then approach the newly introduced 1st one
in this series for now. You still haven't fully fixed whitespace
issues in your second patch in the function itself which I hoped
you would address, but fair enough ...

> Wang Weidong (3):
>    sctp: check the rto_min and rto_max in setsockopt
>    sctp: add check rto_min and rto_max in sysctl
>    sctp: fix up a spacing
>
>   net/sctp/socket.c | 32 +++++++++++++++--------
>   net/sctp/sysctl.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 89 insertions(+), 19 deletions(-)
>
