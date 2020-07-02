From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 02 Jul 2020 12:55:39 +0000
Subject: Re: [PATCH] sctp: Wake up all processes after closing the connection
Message-Id: <20200702125539.GT2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200702080126.8951-1-oss@malat.biz>
In-Reply-To: <20200702080126.8951-1-oss@malat.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 02, 2020 at 10:01:26AM +0200, Petr Malat wrote:
> All waiters need to be woken up after a state change to ESTABLISHED,
> CLOSED or SHUTDOWN_RECEIVED, as that's the time when they all should
> react - for example all threads blocked in send() must return an
> error when the connection is closed, not only one of them.
> 
> This solves the problem of threads sleeping indefinitely in
> sctp_sendmsg_to_asoc() when the connection was closed while multiple
> threads were waiting for SNDBUF.
> 
> Signed-off-by: Petr Malat <oss@malat.biz>

Thanks.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
