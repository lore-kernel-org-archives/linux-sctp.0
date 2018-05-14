From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 00:21:09 +0000
Subject: Re: [PATCH net-next v2 3/8] sctp: move the flush of ctrl chunks into its own function
Message-Id: <20180514002109.GZ5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142784.git.marcelo.leitner@gmail.com>
 <629f02a784ff90761adee451a870c7548069287d.1526142784.git.marcelo.leitner@gmail.com>
In-Reply-To: <629f02a784ff90761adee451a870c7548069287d.1526142784.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

On Sat, May 12, 2018 at 07:21:01PM -0300, Marcelo Ricardo Leitner wrote:
> Named sctp_outq_flush_ctrl and, with that, keep the contexts contained.

Trinity triggered a panic on this patch. I'm debugging it.

