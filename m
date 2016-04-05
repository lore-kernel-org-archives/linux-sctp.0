From: David Miller <davem@davemloft.net>
Date: Tue, 05 Apr 2016 19:44:23 +0000
Subject: Re: [PATCH v2] sctp: use list_* in sctp_list_dequeue
Message-Id: <20160405.154423.1746284768680802731.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <729a27385f91aacaee46ecfa6f37f084f2843b9c.1459530791.git.marcelo.leitner@gmail.com>
In-Reply-To: <729a27385f91aacaee46ecfa6f37f084f2843b9c.1459530791.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri,  1 Apr 2016 14:30:32 -0300

> Use list_* helpers in sctp_list_dequeue, more readable.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> v2: patch rechecked

Also applied, thanks.
