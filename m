From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 13:29:52 +0000
Subject: Re: [PATCH net-next 3/8] sctp: move the flush of ctrl chunks into its own function
Message-Id: <20180512132952.GX5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526077476.git.marcelo.leitner@gmail.com>
 <23e474529812a3e804b1a4311ec48f250b81bbc5.1526077476.git.marcelo.leitner@gmail.com>
In-Reply-To: <23e474529812a3e804b1a4311ec48f250b81bbc5.1526077476.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

On Fri, May 11, 2018 at 08:28:45PM -0300, Marcelo Ricardo Leitner wrote:
> Named sctp_outq_flush_ctrl and, with that, keep the contexts contained.

kbuild bot spotted some issues with this patch. They were corrected
later on on the series, but I should fix them here.

Will post a v2 later today.

