From: David Miller <davem@davemloft.net>
Date: Mon, 11 Jan 2016 22:13:45 +0000
Subject: Re: [PATCH] sctp: fix use-after-free in pr_debug statement
Message-Id: <20160111.171345.1807630667848434364.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <566AF20F.9060504@gmail.com>
	<51dffdfdb37c240ff7e9b0b2a93433f217fa4d2c.1452257700.git.marcelo.leitner@gmail.com>
In-Reply-To: <51dffdfdb37c240ff7e9b0b2a93433f217fa4d2c.1452257700.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, dvyukov@google.com, vyasevich@gmail.com, eric.dumazet@gmail.com, syzkaller@googlegroups.com, kcc@google.com, glider@google.com, sasha.levin@oracle.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  8 Jan 2016 11:00:54 -0200

> Dmitry Vyukov reported a use-after-free in the code expanded by the
> macro debug_post_sfx, which is caused by the use of the asoc pointer
> after it was freed within sctp_side_effect() scope.
> 
> This patch fixes it by allowing sctp_side_effect to clear that asoc
> pointer when the TCB is freed.
> 
> As Vlad explained, we also have to cover the SCTP_DISPOSITION_ABORT case
> because it will trigger DELETE_TCB too on that same loop.
> 
> Also, there were places issuing SCTP_CMD_INIT_FAILED and ASSOC_FAILED
> but returning SCTP_DISPOSITION_CONSUME, which would fool the scheme
> above. Fix it by returning SCTP_DISPOSITION_ABORT instead.
> 
> The macro is already prepared to handle such NULL pointer.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thank you.
