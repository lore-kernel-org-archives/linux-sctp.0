From: Qiujun Huang <hqjagain@gmail.com>
Date: Fri, 20 Mar 2020 23:36:24 +0000
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjoedC4PTycGEpv_pCfbzW9zaA+kz2JTJaTi-EDWxcPUvFA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200320110959.2114-1-hqjagain@gmail.com> <2dc8673f-a46d-1438-95a8-cfb455bbea57@gmail.com>
In-Reply-To: <2dc8673f-a46d-1438-95a8-cfb455bbea57@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Sat, Mar 21, 2020 at 1:10 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
>
> This does not really solve the issue.
>
> Even if the particular syzbot repro is now fine.
>
> Really, having anything _after_ the sock_wfree(skb) is the bug, since the current thread no longer
> own a reference on a socket.

I get it, thanks.

>
>
>
>
