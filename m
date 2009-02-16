From: David Miller <davem@davemloft.net>
Date: Mon, 16 Feb 2009 08:07:16 +0000
Subject: Re: [PATCH net-next 0/4] sctp: Updates and fixes
Message-Id: <20090216.000716.118829405.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1234550024-30915-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1234550024-30915-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Feb 2009 13:33:40 -0500

> Here are some updates and fixes for SCTP:
>     - Allow disabling of checksum with a module parameter.
>     - Cleanup the sctp checksum code to get rid of excessive casts
>     - Fix the exponention RTO update with Heartbeats.
>     - Preserve socket level options on accept/peeloff.

All applied, thanks Vlad.
