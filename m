From: David Miller <davem@davemloft.net>
Date: Wed, 28 Sep 2016 12:13:03 +0000
Subject: Re: [PATCHv2 net 0/5] sctp: some fixes of prsctp polices
Message-Id: <20160928.081303.661512609700070565.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1475059350.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1475059350.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 28 Sep 2016 18:46:27 +0800

> This patchset is to improve some codes about prsctp polices, and also
> to fix some issues.
> 
> v1->v2:
>   - wrap the check of chunk->sent_count in a macro:
>     sctp_chunk_retransmitted in patch 2/5.

This series is a mix of bug fixes (patch #1) which should be targetting
'net' and simplifications/cleanups (patch #2-5) which should be targetting
'net-next'.

Please do not mix things up like this, and submit patches targetting
the appropriate tree.

