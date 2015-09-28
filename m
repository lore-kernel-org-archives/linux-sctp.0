From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 28 Sep 2015 12:42:03 +0000
Subject: Re: [PATCH v2] net: sctp: Don't use 64 kilobyte lookup table for four elements
Message-Id: <20150928124203.GB24740@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1443443644-12825-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1443443644-12825-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 28, 2015 at 02:34:04PM +0200, Denys Vlasenko wrote:
> Seemingly innocuous sctp_trans_state_to_prio_map[] array
> is way bigger than it looks, since
> "[SCTP_UNKNOWN] = 2" expands into "[0xffff] = 2" !
> 
> This patch replaces it with switch() statement.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: linux-sctp@vger.kernel.org
> CC: netdev@vger.kernel.org
> CC: linux-kernel@vger.kernel.org

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

