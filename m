From: David Miller <davem@davemloft.net>
Date: Tue, 02 Jul 2019 02:02:24 +0000
Subject: Re: [PATCH net] sctp: fix error handling on stream scheduler initialization
Message-Id: <20190701.190224.767132828354505683.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
In-Reply-To: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, hdanton@sina.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 27 Jun 2019 19:48:10 -0300

> It allocates the extended area for outbound streams only on sendmsg
> calls, if they are not yet allocated.  When using the priority
> stream scheduler, this initialization may imply into a subsequent
> allocation, which may fail.  In this case, it was aborting the stream
> scheduler initialization but leaving the ->ext pointer (allocated) in
> there, thus in a partially initialized state.  On a subsequent call to
> sendmsg, it would notice the ->ext pointer in there, and trip on
> uninitialized stuff when trying to schedule the data chunk.
> 
> The fix is undo the ->ext initialization if the stream scheduler
> initialization fails and avoid the partially initialized state.
> 
> Although syzkaller bisected this to commit 4ff40b86262b ("sctp: set
> chunk transport correctly when it's a new asoc"), this bug was actually
> introduced on the commit I marked below.
> 
> Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Tested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
