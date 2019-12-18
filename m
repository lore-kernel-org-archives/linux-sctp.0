From: David Miller <davem@davemloft.net>
Date: Wed, 18 Dec 2019 05:59:30 +0000
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream initialization
Message-Id: <20191217.215930.1954562133511895718.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
In-Reply-To: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, kent.overstreet@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 16 Dec 2019 22:01:16 -0300

> syzbot reported a memory leak when an allocation fails within
> genradix_prealloc() for output streams. That's because
> genradix_prealloc() leaves initialized members initialized when the
> issue happens and SCTP stack will abort the current initialization but
> without cleaning up such members.
> 
> The fix here is to always call genradix_free() when genradix_prealloc()
> fails, for output and also input streams, as it suffers from the same
> issue.
> 
> Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> Fixes: 2075e50caf5e ("sctp: convert to genradix")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
