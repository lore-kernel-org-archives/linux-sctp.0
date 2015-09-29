From: David Miller <davem@davemloft.net>
Date: Tue, 29 Sep 2015 05:52:42 +0000
Subject: Re: [PATCH v2] net: sctp: Don't use 64 kilobyte lookup table for four elements
Message-Id: <20150928.225242.1547755659279670596.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443443644-12825-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1443443644-12825-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dvlasenk@redhat.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Mon, 28 Sep 2015 14:34:04 +0200

> Seemingly innocuous sctp_trans_state_to_prio_map[] array
> is way bigger than it looks, since
> "[SCTP_UNKNOWN] = 2" expands into "[0xffff] = 2" !
> 
> This patch replaces it with switch() statement.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Applied, thank you.
