From: David Miller <davem@davemloft.net>
Date: Thu, 06 Dec 2018 04:16:15 +0000
Subject: Re: [PATCH net] sctp: frag_point sanity check
Message-Id: <20181205.201615.2105941098946347576.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181204192741.35357-1-jakub.audykowicz@gmail.com>
In-Reply-To: <20181204192741.35357-1-jakub.audykowicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jakub.audykowicz@gmail.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org

From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Tue,  4 Dec 2018 20:27:41 +0100

> If for some reason an association's fragmentation point is zero,
> sctp_datamsg_from_user will try to endlessly try to divide a message
> into zero-sized chunks. This eventually causes kernel panic due to
> running out of memory.
> 
> Although this situation is quite unlikely, it has occurred before as
> reported. I propose to add this simple last-ditch sanity check due to
> the severity of the potential consequences.
> 
> Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>

Applied.
